from lua_cpp_binding_helpers import *

import argparse
from argparse import RawTextHelpFormatter
#/** comments */

parser = argparse.ArgumentParser(description = """
Parses Javadoc like statements in a C++ file and generates binding functions
to help call the functions in lua. Also outputs a metatable for linking purposes
generates a `{OUT_LOCATION}/{OUT_BASENAME}.cc` and `{OUT_LOCATION}/{OUT_BASENAME}.hh`

The .cc file includes the contents of `{IN_FILE}` already, so you may use static
functions and will not need to include `{IN_FILE}` in your build.

javadoc functions are defined with `/** */`. rules are defined with `@lua-` statements
that each occupy their own line. Possible values are:

- `@lua-meta`
    -   specifies that this function is a low level lua linking function and can be
        directly included in the metatable. `@lua-name` still required.
- `@lua-name NAME`
    -   specifies the name this function will be called by from lua
- `@lua-arg NAME: TYPE`
    -   specifies an argument to the function. Ordering of these statements
        creates the order arguments will be accepted in.
- `@lua-return TYPE`
    -   specifies the type of value this function will return
- `@lua-constructor`
    -   specifies that this function is a constructor and the metatable should have
        `__index` set to the meta-indexer, which allows class-like use of instances

TYPE is one of the following patterns
- `string`
    - A simple heap-allocated C string
- `String`
    - A C++ stack allocated string
- `Class CTYPE [METATABLE_NAME]`
    - e.g. Class SDL_Surface Surface
    - e.g. Class Sprite Sprite
    - When this is a return TYPE, Lua only allocates the size of a pointer to
      the class
- `int`
    - a lua_Integer
- `number`
    - a lua_Number
- `Delete CTYPE`
    - Same as Class, but nulls the pointer after fetch, which is useful
      for functions in which you call `delete` on the returned pointer.
- `bool`
    - a boolean
- `Struct CTYPE [METATABLE_NAME]`
    - like class, but lua allocates the full size of this type onto the stack
""", formatter_class=RawTextHelpFormatter)
parser.add_argument("IN_FILE", help = "the input .cc file")
parser.add_argument("OUT_LOCATION", help = "the output directory")
parser.add_argument("OUT_BASENAME", help = "output file basename")
sys_args = parser.parse_args()
IN_FILEname = sys_args.IN_FILE
out_filename = os.path.join(sys_args.OUT_LOCATION, sys_args.OUT_BASENAME)
basename = sys_args.OUT_BASENAME

with open(IN_FILEname, "r") as IN_FILE, open(out_filename + ".cc", "w") as out_file, open(out_filename + ".hh", "w") as out_header:
    # create the .cc file
    contents = IN_FILE.read()
    didguard = guard.match(contents)
    if didguard != None:
        contents = contents[didguard.span()[1]:]
        groups = didguard.groups()
        out_file.write("#if{}def {}\n".format(*groups))
    out_file.write('#include "{}.hh"\n'.format(basename))
    out_file.write(contents)
    out_file.write("\n")
    fns = []
    for match in docpattern.finditer(contents):
        values = {}
        for lmatch in luapattern.finditer(match.group()):
            name = lmatch.group(1)
            contents = lmatch.group(2)
            if name not in luaforms:
                print("@lua-{} not a valid rule".format(name))
                sys.exit(1)
            luaforms[name](values, contents)
        if len(values) == 0:
            continue
        values["fn_name"] = fnnamepattern.search(
            match
            .group()
            .split("*/")[-1]).group()[:-1]
        if not "meta" in values:
            write_fn(out_file, values, basename)
        name = values["name"]
        if "meta" in values:
            fns.append('{{"{}", {}}},'.format(name, values["fn_name"]))
        else:
            fns.append('{{"{}", {}}},'.format(name, fn_name_get(name, basename)))
    if isClassG():
        fns.append('{"__index", l_meta_indexer},')
    fns.append("{NULL, NULL}};")

    out_file.write("\nconst struct luaL_Reg {}_meta[] = {{\n    ".format(
        basename))
    out_file.write("\n    ".join(fns))
    out_file.write("\n")
    if didguard != None:
        out_file.write("#endif\n")
    
    # create the .hh file
    if didguard != None:
        contents = contents[didguard.span()[1]:]
        groups = didguard.groups()
        out_header.write("#if{}def {}\n".format(*groups))
    out_header.write("""
#pragma once
#include "globals.hh"
#include "{}.hh"

extern const struct luaL_Reg {}_meta[];
""".format(basename, basename))
    if didguard != None:
        out_header.write("#endif\n")
    

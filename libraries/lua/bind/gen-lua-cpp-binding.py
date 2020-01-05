import argparse
from argparse import RawTextHelpFormatter
import sys
import re
import os.path
#/** comments */
docpattern = re.compile(r"""
/\*\* # start of doc
(?:[^\*]|\*(?!/))* # up to end of doc
[^\{]*\{ # collect the start of the function */
""", re.MULTILINE|re.DOTALL|re.VERBOSE)

# static void* <capture_this> (args){
fnnamepattern = re.compile(r"\w+\s*\(")

#@lua-(name) comments
luapattern = re.compile(r"@lua-([a-z]+)(.*)")

def type_split(x):
    x = x.strip().split(" ")
    if x[0] == "Class":
        assert len(x) >= 2, "{} must have a type".format(" ".join(x))
    return x

parser = argparse.ArgumentParser(description = """
Parses Javadoc like statements in a C++ file and generates binding functions
to help call the functions in lua. Also outputs a metatable for linking purposes
generates a {OUT_LOCATION}/{OUT_BASENAME}.cpp and {OUT_LOCATION}/{OUT_BASENAME}.h

The .cpp file includes the contents of {IN_FILE} already, so you may use static
functions and will not need to include {IN_FILE} in your build.

javadoc functions are defined with /** */. rules are defined with `@lua-` statements
that each occupy their own line. Possible values are:

- @lua-meta
    -   specifies that this function is a low level lua linking function and can be
        directly included in the metatable. `@lua-name` still required.
- @lua-name
    -   specifies the name this function will be called by from lua
- @lua-arg NAME: TYPE
    -   specifies an argument to the function. Ordering of these statements
        creates the order arguments will be accepted in.
- @lua-return TYPE
    -   specifies the type of value this function will return
- @lua-constructor
    -   specifies that this function is a constructor and the metatable should have
        __index set to the meta-indexer, which allows class-like use of instances
""", formatter_class=RawTextHelpFormatter)
parser.add_argument("IN_FILE", help = "the input .cpp file")
parser.add_argument("OUT_LOCATION", help = "the output directory")
parser.add_argument("OUT_BASENAME", help = "output file basename")
sys_args = parser.parse_args()
IN_FILEname = sys_args.IN_FILE
out_filename = os.path.join(sys_args.OUT_LOCATION, sys_args.OUT_BASENAME)
basename = sys_args.OUT_BASENAME

def lua_return(values, x):
    values["return"] = type_split(x)

isClass = False
def lua_class(values, x):
    global isClass
    isClass = True

def lua_meta(values, x):
    values["meta"] = True

def lua_name(values, x):
    values["name"] = x.strip()

def lua_arg(values, x):
    x = [x.strip() for x in x.split(":")]
    x[1] = type_split(x[1])
    assert len(x) == 2, "arg must be of the format 'name: type' {}".format(x)
    assert x[1][0] in argconvert, "{} must be in {}".format(x, argconvert)
    args = values.get("arg", [])
    args.append(x)
    values["arg"] = args

def struct_lget(arg_name, arg_type):
    return """
    {name} = reinterpret_cast<{ctype}*>(lua_touserdata(L, -1));
""".format(
        name = arg_name, ctype = arg_type[1])

def class_lget(arg_name, arg_type):
    return """
    {name} = *reinterpret_cast<{ctype}*>(lua_touserdata(L, -1));
    if ({name} == NULL) {{
        return 0;
    }}
""".format(
        name = arg_name, ctype = lua_ctypeof(arg_type))

def delete_lget(arg_name, arg_type):
    return """
    {ctype}* _d{name} = reinterpret_cast<{ctype}*>(lua_touserdata(L, -1));
    {name} = *_d{name};
    *_d{name} = NULL;
    if ({name} == NULL) {{
        return 0;
    }}
""".format(
        name = arg_name, ctype = lua_ctypeof(arg_type))

def struct_lpush(arg_type):
    
    return """
    memcpy(lua_newuserdata(L, sizeof({ctype})), &retVal, sizeof({ctype}));
    
    set_meta(L, -1, "{ltype}");
""".format(ctype = arg_type[1], ltype = arg_type[2])

def class_lpush(arg_type):
    ctype = lua_ctypeof(arg_type)
    return """
    *reinterpret_cast<{ctype}*>(lua_newuserdata(L, sizeof({ctype}))) = retVal;
    set_meta(L, -1, "{meta}");
""".format(ctype = ctype, meta = arg_type[-1])

def string_lpush(arg_type):
    return """
    lua_pushstring(L, {});
    delete[] retVal;
""".format(arg_type[0])

arggets = {
    "string": lambda n, x: n + " = lua_tostring(L, -1);",
    "int": lambda n, x: n + " = lua_tointeger(L, -1);",
    "number": lambda n, x: n + " = lua_tonumber(L, -1);",
    "bool": lambda n, x: n + " = static_cast<bool>(lua_toboolean(L, -1));",
    "Class": class_lget,
    "Struct": struct_lget,
    "Delete": delete_lget,
}
    
argputs = {
    "string": string_lpush,
    "int": lambda x: "    lua_pushinteger(L, retVal);",
    "number": lambda x: "    lua_pushnumber(L, retVal);",
    "bool": lambda x: "    lua_pushboolean(L, static_cast<int>(retVal));",
    "Class": class_lpush,
    "Struct": struct_lpush,
}
 
argconvert = {
    "string": lambda x: "const char*",
    "int": lambda x: "lua_Integer",
    "number": lambda x: "lua_Number",
    "bool": lambda x: "bool",
    "Class": lambda x: x[1] + "*",
    "Struct": lambda x: x[1] + "*",
    "Delete": lambda x: x[1] + "*",
}

typeguards = {
    "string": "string",
    "bool": "boolean",
    "int": "number",
    "number": "number",
    "Class": "userdata",
    "Struct": "userdata",
    "Delete": "userdata",
}

luaforms = {
    "meta": lua_meta,
    "name": lua_name,
    "arg": lua_arg,
    "return": lua_return,
    "constructor": lua_class,
}

def lua_typeguard(arg_type):
    return typeguards[arg_type[0]]

def lua_ctypeof(arg_type):
    return argconvert[arg_type[0]](arg_type)

def lua_arggetter(arg_name, arg_type):
    return arggets[arg_type[0]](arg_name, arg_type)

def lua_argputter(arg_type):
    return argputs[arg_type[0]](arg_type)

def fn_name_get(name):
    return "_l_{}_{}".format(name, basename)

def raw_fn_name_get(name):
    return name

def write_fn(out, values):
    name = values["name"]
    out.write("\nstatic int {}(lua_State *L) {{\n".format(fn_name_get(name)))
    args = values.get("arg", [])
    # write variables
    for (arg_name, arg_type) in args:
        out.write("    {} {};\n".format(lua_ctypeof(arg_type), arg_name))

    # retrieve variables and guard for type
    for (arg_name, arg_type) in args[::-1]:
        guard = lua_typeguard(arg_type)
        arg_get = lua_arggetter(arg_name, arg_type)
        out.write("""
    if (!lua_is{guard}(L, -1)) {{
        printf("bad arg {fnname}.{name}\\n");
        return 0;
    }}
    {arg_get}
    lua_pop(L, 1);
""".format(guard=guard, arg_get=arg_get, fnname=name, name=arg_name))

    # call the function
    fn_name = values["fn_name"]
    returns = values.get("return", None)
    args_joined = ", ".join([n for (n, t) in args])
    out.write("\n    ")
    if returns != None:
        if returns[0] == "Struct":
            out.write("{} retVal = ".format(returns[1]))
        else:
            out.write("{} retVal = ".format(lua_ctypeof(returns)))
    out.write("{}({});".format(fn_name, args_joined))
    if returns != None:
        out.write(lua_argputter(returns))
    # return
    #out.write('\nprintf("calling {}\\n");\n'.format(fn_name))
    out.write("""
    return {};
}}\n""".format(0 if returns == None else 1))

with open(IN_FILEname, "r") as IN_FILE, open(out_filename + ".cpp", "w") as out_file, open(out_filename + ".h", "w") as out_header:
    # create the .cpp file
    contents = IN_FILE.read()
    out_file.write('#include "{}.h"\n'.format(basename))
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
            write_fn(out_file, values)
        name = values["name"]
        if "meta" in values:
            fns.append('{{"{}", {}}},'.format(name, values["fn_name"]))
        else:
            fns.append('{{"{}", {}}},'.format(name, fn_name_get(name)))
    if isClass:
        fns.append('{"__index", l_meta_indexer},')
    fns.append("{NULL, NULL}};")

    out_file.write("\nconst struct luaL_Reg {}_meta[] = {{\n    ".format(
        basename))
    out_file.write("\n    ".join(fns))
    out_file.write("\n")

    basename_upper = basename.upper()
    # create the .h file
    out_header.write("""
#ifndef _{}_
#define _{}_
#include "globals.h"
#include "{}.h"

extern const struct luaL_Reg {}_meta[];

#endif
    """.format(basename_upper, basename_upper, basename, basename))
    

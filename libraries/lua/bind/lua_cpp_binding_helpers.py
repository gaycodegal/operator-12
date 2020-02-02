import sys
import re
import os.path

docpattern = re.compile(r"""
/\*\* # start of doc
(?:[^\*]|\*(?!/))* # up to end of doc
[^\{]*\{ # collect the start of the function */
""", re.MULTILINE|re.DOTALL|re.VERBOSE)

guard = re.compile(r"^#(n?)guard ([A-Z_]+)")

# static void* <capture_this> (args){
fnnamepattern = re.compile(r"\w+\s*\(")

#@lua-(name) comments
luapattern = re.compile(r"@lua-([a-z]+)(.*)")

def type_split(x):
    x = x.strip().split(" ")
    if x[0] == "Class":
        assert len(x) >= 2, "{} must have a type".format(" ".join(x))
    return x


def lua_return(values, x):
    values["return"] = type_split(x)

isClass = False
def lua_class(values, x):
    global isClass
    isClass = True

def isClassG():
    return isClass
    
def lua_meta(values, x):
    values["meta"] = True

def lua_name(values, x):
    values["name"] = x.strip()

def lua_arg(values, x):
    spliti = x.index(":")
    x = [x.strip() for x in [x[:spliti], x[spliti + 1:]]]
    x[1] = type_split(x[1])
    assert len(x) == 2, "arg must be of the format 'name: type' {}".format(x)
    assert x[1][0] in argconvert, "{} must be in {}".format(x, argconvert)
    args = values.get("arg", [])
    args.append(x)
    values["arg"] = args

def struct_lget(arg_name, arg_type, i):
    return """
    {name} = reinterpret_cast<{ctype}*>(lua_touserdata(L, -{}));
""".format(
        i, name = arg_name, ctype = arg_type[1])

def class_lget(arg_name, arg_type, i):
    return """
    {name} = *reinterpret_cast<{ctype}*>(lua_touserdata(L, -{}));
    if ({name} == NULL) {{
        printf("could not retrieve {name} (null)\\n");
        return 0;
    }}
""".format(
        i, name = arg_name, ctype = lua_ctypeof(arg_type))

def delete_lget(arg_name, arg_type, i):
    return """
    {ctype}* _d{name} = reinterpret_cast<{ctype}*>(lua_touserdata(L, -{}));
    {name} = *_d{name};
    *_d{name} = NULL;
    if ({name} == NULL) {{
        printf("could not retrieve {name} (null)\\n");
        return 0;
    }}
""".format(
        i, name = arg_name, ctype = lua_ctypeof(arg_type))

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
    if (retVal == NULL) {
        lua_pushnil(L);
    } else {
        lua_pushstring(L, retVal);
        delete[] retVal;
    }
"""

def cxx_string_lpush(arg_type):
    return """
    lua_pushstring(L, retVal.c_str());
"""

arggets = {
    "string": lambda n, x, i: n + " = lua_tostring(L, -{});".format(i),
    "int": lambda n, x, i: n + " = lua_tointeger(L, -{});".format(i),
    "number": lambda n, x, i: n + " = lua_tonumber(L, -{});".format(i),
    "bool": lambda n, x, i: n + " = static_cast<bool>(lua_toboolean(L, -{}));".format(i),
    "Class": class_lget,
    "Struct": struct_lget,
    "Delete": delete_lget,
}
    
argputs = {
    "string": string_lpush,
    "String": cxx_string_lpush,
    "int": lambda x: "    lua_pushinteger(L, retVal);",
    "number": lambda x: "    lua_pushnumber(L, retVal);",
    "bool": lambda x: "    lua_pushboolean(L, static_cast<int>(retVal));",
    "Class": class_lpush,
    "Self": lambda x: "",
    "Struct": struct_lpush,
}
 
argconvert = {
    "string": lambda x: "const char*",
    "String": lambda x: "std::string",
    "int": lambda x: "lua_Integer",
    "number": lambda x: "lua_Number",
    "bool": lambda x: "bool",
    "Class": lambda x: x[1] + "*",
    "Self": lambda x: x[1] + "*",
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

def lua_arggetter(arg_name, arg_type, i):
    return arggets[arg_type[0]](arg_name, arg_type, i)

def lua_argputter(arg_type):
    return argputs[arg_type[0]](arg_type)

def fn_name_get(name, basename):
    return "_l_{}_{}".format(name, basename)

def raw_fn_name_get(name, basename):
    return name

def write_fn(out, values, basename):
    name = values["name"]
    out.write("\nstatic int {}(lua_State *L) {{\n".format(fn_name_get(name, basename)))
    args = values.get("arg", [])
    # write variables
    for (arg_name, arg_type) in args:
        out.write("    {} {};\n".format(lua_ctypeof(arg_type), arg_name))

    # retrieve variables and guard for type
    for (i, (arg_name, arg_type)) in enumerate(args[::-1]):
        guard = lua_typeguard(arg_type)
        arg_get = lua_arggetter(arg_name, arg_type, i + 1)
        out.write("""
    if (!lua_is{guard}(L, -{index})) {{
        printf("bad arg {fnname}.{name}\\n");
        return 0;
    }}
    {arg_get}
""".format(index=i+1, guard=guard, arg_get=arg_get, fnname=name, name=arg_name))

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

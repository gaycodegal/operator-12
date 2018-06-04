import sys
import json
gname = json.loads(sys.stdin.readline())
def createMethod(name, argnames, argtypes, luatypes, nret):
    metabuilt.append("{%s, l_%s%s},\n" % (json.dumps(name), gname, name))
    built = ["static int l_%s%s(lua_State *L) {\n" % (gname, name)]
    for n, t in zip(argnames, argtypes):
        built.append("%s %s;\n" % (t, n))
    i = 0
    for n, t, lua in zip(argnames[::-1], argtypes[::-1], luatypes[::-1]):
        lua2 = "userdata" if "userdata" in lua else lua
        built.append("""if (!lua_is%s(L, -1)) {
  lua_pop(L, %i);
  return 0;
}
%s = (%s)lua_to%s(L, -1);
lua_pop(L, 1);
""" % (lua, len(argnames) - i, n, t, lua2))
        i += 1
    built.append("""return %i;
}
""" % nret)
    return "".join(built)

metabuilt = ["static const struct luaL_Reg %smeta[] = {" % gname]

v = []
i = 1
for line in sys.stdin:
    i += 1
    try:
        v.append(json.loads(line))
        if len(v) == 5:
            print(createMethod(*v))
            v = []
    except Exception as e:
        print("error at line:", i)
        print(e)
        sys.exit(1)
metabuilt.append("{NULL, NULL}};")
print("".join(metabuilt))

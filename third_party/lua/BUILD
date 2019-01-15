licenses(["notice"]) # MIT license

lua_dir = "src/"
lua_hdrs = glob([lua_dir+"*.h"])
lua_no_include = ["lua.c", "luac.c"]
lua_srcs = lua_hdrs + glob([lua_dir+"*.c"], exclude=[lua_dir + x for x in lua_no_include])

cc_library(
    name = "lua",
    hdrs = lua_hdrs,
    srcs = lua_srcs,
    visibility = ["//visibility:public"],
)

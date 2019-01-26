licenses(["notice"]) # MIT license

lua_dir = "src/"
lua_hdrs = glob([lua_dir+"*.h"])
lua_lib_raw = "lapi.c lcode.c lctype.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c lundump.c lvm.c lzio.c lauxlib.c lbaselib.c lbitlib.c lcorolib.c ldblib.c liolib.c lmathlib.c loslib.c lstrlib.c ltablib.c lutf8lib.c loadlib.c linit.c".split(" ")
lua_lib_srcs = lua_hdrs + [lua_dir + x for x in lua_lib_raw]

cc_library(
    name = "lua-lib",
    hdrs = lua_hdrs,
    srcs = lua_lib_srcs,
    includes = [lua_dir],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "lua-lib-android",
    hdrs = lua_hdrs,
    srcs = lua_lib_srcs,
    includes = [lua_dir],
    copts=[
        "-include android-lua.h",
    ],
    deps = ["//extras:lua-android-include"],
    linkopts = ["-ldl -lm -landroid -llog"],
    visibility = ["//visibility:public"],
)

cc_binary(
    name = "lua",
    srcs = ["src/lua.c"],
    deps = [":lua-lib"],
    visibility = ["//visibility:private"],
)

# eventually should use luac in build rule
cc_binary(
    name = "luac",
    srcs = ["src/luac.c"],
    deps = [":lua-lib"],
    visibility = ["//visibility:private"],
)

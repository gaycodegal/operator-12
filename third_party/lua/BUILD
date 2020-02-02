load("//bzl:vars.bzl", "COPTS", "LINKOPTS")
licenses(["notice"]) # MIT license

lua_dir = "src/"
lua_hdrs = glob([lua_dir+"*.h"])
lua_lib_raw = "lapi.cpp lcode.cpp lctype.cpp ldebug.cpp ldo.cpp ldump.cpp lfunc.cpp lgc.cpp llex.cpp lmem.cpp lobject.cpp lopcodes.cpp lparser.cpp lstate.cpp lstring.cpp ltable.cpp ltm.cpp lundump.cpp lvm.cpp lzio.cpp lauxlib.cpp lbaselib.cpp lbitlib.cpp lcorolib.cpp ldblib.cpp liolib.cpp lmathlib.cpp loslib.cpp lstrlib.cpp ltablib.cpp lutf8lib.cpp loadlib.cpp linit.cpp".split(" ")
#lua_lib_raw = "lapi.cpp".split(" ")
#lua_hdrs = ["src/luaconf.h"]
lua_lib_srcs = lua_hdrs + [lua_dir + x for x in lua_lib_raw]

cc_library(
    name = "lua-lib",
    hdrs = lua_hdrs,
    srcs = lua_lib_srcs,
    includes = [lua_dir],
    copts = COPTS,
    linkopts = LINKOPTS,
    deps = [
        "//third_party/fixed",
    ],
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
    deps = [
        "//extras:lua-android-include",
        "//third_party/fixed",
    ],
    linkopts = ["-ldl -lm -landroid -llog"],
    visibility = ["//visibility:public"],
)

cc_binary(
    name = "lua",
    srcs = ["src/lua.cpp"],
    deps = [":lua-lib"],
    copts = COPTS,
    linkopts = LINKOPTS,
    visibility = ["//visibility:private"],
)

# eventually should use luac in build rule
cc_binary(
    name = "luac",
    srcs = ["src/luac.c"],
    deps = [":lua-lib"],
    visibility = ["//visibility:private"],
)

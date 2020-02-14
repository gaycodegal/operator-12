load("//bzl:vars.bzl", "COPTS", "LINKOPTS")
load("//libraries/lua/bind:bind.bzl", "lua_bind_cpp")

bound = ["lua_screen"]
bindings = [b.replace("lua", "bound") for b in bound]
excluded = [b + ".cpp" for b in bound]

cc_library(
    name = "bits",
    srcs = glob([
        "*.cpp",
    ], exclude = excluded) + [b + ".cpp" for b in bindings],
    hdrs = glob([
        "*.h",
    ]) + [b + ".h" for b in bindings],
    copts = COPTS,
    linkopts = LINKOPTS,
    deps = [
        "//libraries/sdl/include",
        "//libraries/lua/include",
        "//libraries/globals",
        "//libraries/lua/sdl",
        "//libraries/util/lua",
    ],
    includes = [""],
    visibility = ["//visibility:public"],
)

lua_bind_cpp(
    name = "bound_screen",
    src = "lua_screen.cpp",
)

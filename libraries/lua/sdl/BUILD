load("//bzl:vars.bzl", "COPTS", "LINKOPTS")
load("//libraries/lua/bind:bind.bzl", "lua_bind_cpp")

bindings = [b.replace("lua", "bound") for b in ["lua_surface"]]

cc_library(
    name = "sdl",
    srcs = glob([
        "*.cpp",
    ], exclude = ["lua_surface.cpp"]) + [b + ".cpp" for b in bindings],
    hdrs = glob([
        "*.h",
    ]) + [b + ".h" for b in bindings],
    copts = COPTS,
    linkopts = LINKOPTS,
    deps = [
        "//libraries/sdl/include",
        "//libraries/lua/include",
        "//libraries/globals",
        "//libraries/util/lua",
    ],
    includes = [""],
    visibility = ["//visibility:public"],
)

lua_bind_cpp(
    name = "bound_surface",
    src = "lua_surface.cpp",
)

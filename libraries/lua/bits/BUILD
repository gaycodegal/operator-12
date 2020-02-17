load("//bzl:vars.bzl", "COPTS", "LINKOPTS")
load("//libraries/lua/bind:bind.bzl", "lua_bind_cpp")

bound = ["lua_screen"]
bindings = [b.replace("lua", "bound") for b in bound]
excluded = [b + ".cc" for b in bound]

cc_library(
    name = "bits",
    srcs = glob([
        "*.cc",
    ], exclude = excluded) + [b + ".cc" for b in bindings],
    hdrs = glob([
        "*.hh",
    ]) + [b + ".hh" for b in bindings],
    copts = COPTS,
    linkopts = LINKOPTS,
    deps = [
        "//libraries/sdl/include",
        "//libraries/lua/include",
        "//libraries/globals",
        "//libraries/lua/sdl",
        "//libraries/util/lua",
        "//libraries/util",
    ],
    includes = [""],
    visibility = ["//visibility:public"],
)

lua_bind_cpp(
    name = "bound_screen",
    src = "lua_screen.cc",
)

lua_bind_cpp(
    name = "bound_bits_io",
    src = "lua_bits_io.cc",
)

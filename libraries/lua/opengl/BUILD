load("//bzl:vars.bzl", "COPTS", "LINKOPTS")
load("//libraries/lua/bind:bind.bzl", "lua_bind_cpp")

bindings = [src.replace("lua", "bound").replace(".cpp", "") for src in glob(["lua*.cpp"])]

cc_library(
    name = "opengl",
    srcs = glob([
        "*.cpp",
    ], exclude = glob(["lua*.cpp"])) + [b + ".cpp" for b in bindings],
    hdrs = glob([
        "*.h",
    ]) + [b + ".h" for b in bindings],
    copts = COPTS,
    linkopts = LINKOPTS,
    deps = [
        "//libraries/util/lua",
        "//libraries/sdl/include",
        "//libraries/globals",
        "//libraries/lua/include",
    ],
    includes = [""],
    visibility = ["//visibility:public"],
)

lua_bind_cpp(
    name = "bound_gl_static",
    src = "lua_gl_static.cpp",
)

lua_bind_cpp(
    name = "bound_float_array",
    src = "lua_float_array.cpp",
)

lua_bind_cpp(
    name = "bound_shader",
    src = "lua_shader.cpp",
)

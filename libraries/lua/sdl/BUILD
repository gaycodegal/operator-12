load("//bzl:vars.bzl", "COPTS", "LINKOPTS")
load("//libraries/lua/bind:bind.bzl", "lua_bind_cpp")

bound = ["lua_surface", "lua_ttf", "lua_texture", "lua_sprite", "lua_music"]
bindings = [b.replace("lua", "bound") for b in bound]
excluded = [b + ".cpp" for b in bound]

cc_library(
    name = "sdl",
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
        "//libraries/util/lua",
    ],
    includes = [""],
    visibility = ["//visibility:public"],
)

lua_bind_cpp(
    name = "bound_music",
    src = "lua_music.cpp",
)

lua_bind_cpp(
    name = "bound_texture",
    src = "lua_texture.cpp",
)

lua_bind_cpp(
    name = "bound_surface",
    src = "lua_surface.cpp",
)

lua_bind_cpp(
    name = "bound_sprite",
    src = "lua_sprite.cpp",
)

lua_bind_cpp(
    name = "bound_ttf",
    src = "lua_ttf.cpp",
)

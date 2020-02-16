load("//bzl:vars.bzl", "COPTS", "LINKOPTS")
load("//libraries/lua/bind:bind.bzl", "lua_bind_cpp")

bound = ["lua_surface", "lua_ttf", "lua_texture", "lua_sprite", "lua_music", "lua_static"]
bindings = [b.replace("lua", "bound") for b in bound]
excluded = [b + ".cc" for b in bound]

cc_library(
    name = "sdl",
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
        "//libraries/util/lua",
    ],
    includes = [""],
    visibility = ["//visibility:public"],
)

lua_bind_cpp(
    name = "bound_static",
    src = "lua_static.cc",
)

lua_bind_cpp(
    name = "bound_music",
    src = "lua_music.cc",
)

lua_bind_cpp(
    name = "bound_texture",
    src = "lua_texture.cc",
)

lua_bind_cpp(
    name = "bound_surface",
    src = "lua_surface.cc",
)

lua_bind_cpp(
    name = "bound_sprite",
    src = "lua_sprite.cc",
)

lua_bind_cpp(
    name = "bound_ttf",
    src = "lua_ttf.cc",
)

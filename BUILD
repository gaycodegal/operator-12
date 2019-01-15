lua_dir = "lua/src/"
lua_hdrs = glob([lua_dir+"*.h"])
lua_no_include = ["lua.c", "luac.c"]
lua_srcs = lua_hdrs + glob([lua_dir+"*.c"], exclude=[lua_dir + x for x in lua_no_include])

cc_library(
    name = "lua",
    hdrs = lua_hdrs,
    srcs = lua_srcs,
)

game_hdrs = glob([
    "headers/*.hpp",
])

game_srcs = lua_hdrs + game_hdrs + glob([
    "source/*.cpp"
])

game_includes = ["headers/"]

cc_binary(
    name="operator-12",
    srcs=game_srcs,
    deps=[":lua"],
    includes=game_includes,
    linkopts=["-lSDL2", "-lSDL2_image", "-lSDL2_ttf", "-lSDL_mixer", "-ldl", "-lm"]
)

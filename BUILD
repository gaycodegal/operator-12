game_hdrs = glob([
    "headers/*.hpp",
])

game_srcs = game_hdrs + glob([
    "source/*.cpp",
])

game_includes = ["headers/"]

cc_binary(
    name = "operator-12",
    srcs = game_srcs,
    deps = ["//third_party/lua:lua"],
    includes = game_includes,
    data = glob(["resources/**"]),
    linkopts = ["-lSDL2", "-lSDL2_image", "-lSDL2_ttf", "-lSDL_mixer", "-ldl", "-lm"],
)

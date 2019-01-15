cc_binary(
    name = "operator-12",
    srcs = glob([
        "source/*.cpp",
        "headers/*.hpp",
    ]),
    deps = ["//third_party/lua:lua-lib"],
    includes = ["headers/"],
    data = glob(["resources/**"]),
    linkopts = ["-lSDL2", "-lSDL2_image", "-lSDL2_ttf", "-lSDL_mixer", "-ldl", "-lm"],
)

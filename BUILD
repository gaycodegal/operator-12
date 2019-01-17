windows_deps = select({
    "@bazel_tools//src/conditions:windows": [
        "//third_party/sdl2",
        "//third_party/sdl2-mixer",
        "//third_party/sdl2-image",
        "//third_party/sdl2-ttf",
    ],
    "//conditions:default": [],
})

cc_binary(
    name = "operator-12",
    srcs = glob([
        "source/*.cpp",
        "headers/*.hpp",
    ]),
    deps = windows_deps + [
        "//third_party/lua:lua-lib",
    ],
    includes = [
	"headers/",
    ],
    data = glob(["resources/**"]),
    linkopts = ["-lSDL2", "-lSDL2_image", "-lSDL2_ttf", "-lSDL_mixer", "-ldl", "-lm"],
)

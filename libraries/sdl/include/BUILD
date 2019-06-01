DEPS = select({
    "@bazel_tools//src/conditions:windows": [
        "//libraries/std/include",
        "//third_party/SDL",
        "//third_party/SDL_mixer",
        "//third_party/SDL_image",
        "//third_party/SDL_ttf",
    ],
    "//conditions:default": [
        "//libraries/std/include",
    ],
})

COPTS = select({
    "@bazel_tools//src/conditions:darwin": [
        "-std=c++11",
         "-stdlib=libc++",
	 "-F/Library/Frameworks",
    ],
    "@bazel_tools//src/conditions:windows": [],
    "//conditions:default": [
        "-std=c++11",
    ],
})

LINKOPTS = select({
    "@bazel_tools//src/conditions:darwin": [
        "-F/Library/Frameworks",
        "-framework SDL2",
        "-framework SDL2_image",
        "-framework SDL2_ttf",
        "-framework SDL2_mixer",
        "-ldl",
        "-lm",
    ],
    "@bazel_tools//src/conditions:windows": [],
    "//wasm_toolchain:asmjs" : [
        "-s USE_SDL=2",
        "-s USE_SDL_TTF=2",
        "-s USE_SDL_IMAGE=2",
        "-s SDL2_IMAGE_FORMATS='[\"png\"]'",
        "-s ALLOW_MEMORY_GROWTH=1",
        "--preload-file resources/",
    ],
    "//conditions:default": [
        "-lSDL2",
        "-lSDL2_image",
        "-lSDL2_ttf",
        "-lSDL2_mixer",
        "-ldl",
        "-lm",
    ],
})

cc_library(
    name = "include",
    hdrs = glob([
        "*.h",
    ]),
    includes = [""],
    deps = DEPS,
    copts = COPTS,
    linkopts = LINKOPTS,
    visibility = ["//visibility:public"],
)

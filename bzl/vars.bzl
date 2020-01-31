COPTS_ASMJS = [
    "-DNO_MUSIC",
    "-std=c++11",
    "-s WASM=1",
    "-s USE_WEBGL2=1",
    "-s USE_SDL=2",
    "-s USE_SDL_TTF=2",
    "-s USE_SDL_IMAGE=2",
    "-s SDL2_IMAGE_FORMATS='[\"png\"]'",
    "-s ALLOW_MEMORY_GROWTH=1",
]

COPTS = select({
    "@bazel_tools//src/conditions:darwin": [
        "-std=c++11",
        "-stdlib=libc++",
	"-F/Library/Frameworks",
    ],
    "@bazel_tools//src/conditions:windows": [],
    "//wasm_toolchain:asmjs" : COPTS_ASMJS,
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
        "-lGLEW",
        "-lGL",
        "-ldl",
        "-lm",
    ],
    "@bazel_tools//src/conditions:windows": [],
    "//wasm_toolchain:asmjs" : [
        "-std=c++11",
        "-s WASM=1",
        "-s USE_WEBGL2=1",
        "-s USE_SDL=2",
        "-s USE_SDL_TTF=2",
        "-s USE_SDL_IMAGE=2",
        "-s SDL2_IMAGE_FORMATS='[\"png\"]'",
        "-s ALLOW_MEMORY_GROWTH=1",
    ],
    "//conditions:default": [
        "-lSDL2",
        "-lSDL2_image",
        "-lSDL2_ttf",
        "-lSDL2_mixer",
        "-lGLEW",
        "-lGL",
        "-ldl",
        "-lm",
    ],
})

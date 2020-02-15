load("//wasm_toolchain:rules_wasm.bzl", "wasm_binary")

sh_binary(
    name = "format",
    srcs = [
        "scripts/format.sh",
    ],
)

DEPS = [
    "//libraries/std/include",
    "//libraries/lua/include",
    "//libraries/lua/loader",
    "//libraries/sdl/include",
]

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

cc_binary(
    name = "main",
    srcs = glob([
        "cpp/*.h",
        "cpp/*.cpp",
    ]),
    deps = DEPS,
    data = glob(["resources/**"]),
    copts = COPTS,
    linkopts = LINKOPTS,
)

wasm_binary(
    name = "index.html",
    srcs = glob([
        "cpp/*.h",
        "cpp/*.cpp",
    ]),
    deps = DEPS,
    data = glob(["resources/**"]),
    copts = [
        "-std=c++11",
        "-s USE_SDL=2",
        "-s USE_SDL_TTF=2",
        "-s USE_SDL_IMAGE=2",
        "-s SDL2_IMAGE_FORMATS='[\"png\"]'",
        "-s ALLOW_MEMORY_GROWTH=1",
        "--preload-file resources/",
    ],
    linkopts = LINKOPTS,
)

TOP_CONTENT = [
    "//:main",
    "//third_party/SDL_ttf:extra_libs",
    "//third_party/SDL_mixer:extra_libs",
    "//third_party/SDL_image:extra_libs",
]
TOP_CONT_LOCS = " ".join(["$(locations %s)" % x for x in TOP_CONTENT])
genrule(
    name = "packaged",
    srcs = TOP_CONTENT,
    outs = ["packaged.zip"],
    cmd = "zip -qj $@ %s && zip -qur $@ resources/"
    % TOP_CONT_LOCS,
)

android_library(
    name = "android-resources",
    manifest = "//third_party/app-android/src/main:AndroidManifest.xml",
    assets = glob(["resources/**/*"]),
    assets_dir = "resources/",
    custom_package="com.temp.test",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "android",
    srcs = glob([
        "cpp/*.h",
        "cpp/*.cpp",
    ]),
    copts = ["-DANDROID"],
    deps = [
        "//third_party/lua:lua-lib-android",
        "//third_party/SDL",
        "//third_party/SDL_image",
        "//third_party/SDL_ttf",
        "//third_party/SDL_mixer",
    ],
    linkopts = ["-ldl -lm -landroid -llog"],
)

alias(
    name = "jni_library",
    actual = ":android",
    visibility = ["//visibility:public"],
)

alias(
    name = "jni-resources",
    actual = ":android-resources",
    visibility = ["//visibility:public"],
)

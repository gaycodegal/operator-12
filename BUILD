DEPS = select({
    "@bazel_tools//src/conditions:windows": [
        "//third_party/lua:lua-lib",
        "//third_party/SDL",
        "//third_party/SDL_mixer",
        "//third_party/SDL_image",
        "//third_party/SDL_ttf",
    ],
    "//conditions:default": [
        "//third_party/lua:lua-lib",
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
    "//conditions:default": [
        "-lSDL2",
        "-lSDL2_image",
        "-lSDL2_ttf",
        "-lSDL_mixer",
        "-ldl",
        "-lm",
    ],
})

cc_binary(
    name = "operator-12",
    srcs = glob([
        "headers/*.h",
        "source/*.cpp",
    ]),
    deps = DEPS,
    includes = [
	"headers/",
    ],
    data = glob(["resources/**"]),
    copts = COPTS,
    linkopts = LINKOPTS,
)

TOP_CONTENT = [
    "//:operator-12",
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
    name = "op12-android-resources",
    manifest = "//third_party/app-android/src/main:AndroidManifest.xml",
    assets = glob(["resources/**/*"]),
    assets_dir = "resources/",
    custom_package="com.temp.test",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "op12-android",
    srcs = glob([
        "source/*.cpp",
        "headers/*.h",
    ]),
    includes = [
	"headers/",
    ],
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
    actual = ":op12-android",
    visibility = ["//visibility:public"],
)

alias(
    name = "jni-resources",
    actual = ":op12-android-resources",
    visibility = ["//visibility:public"],
)

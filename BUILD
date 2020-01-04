load("//wasm_toolchain:rules_wasm.bzl", "wasm_binary")
load("//bzl:vars.bzl", "COPTS", "LINKOPTS", "COPTS_ASMJS")

DEPS = [
    "//libraries/std/include",
    "//libraries/lua/include",
    "//libraries/lua/loader",
    "//libraries/sdl/include",
]

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
    visibility = ["//visibility:public"],
)

wasm_binary(
    name = "main.html",
    srcs = glob([
        "cpp/*.h",
        "cpp/*.cpp",
    ]),
    deps = DEPS,
    data = glob(["resources/**"]),
    copts = COPTS_ASMJS + [
        "--preload-file resources/"
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
    actual = ":op12-android",
    visibility = ["//visibility:public"],
)

alias(
    name = "jni-resources",
    actual = ":op12-android-resources",
    visibility = ["//visibility:public"],
)

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

android_library(
    name = "jni-resources",
    manifest = "//third_party/app-android/src/main:AndroidManifest.xml",
    assets = glob(["resources/**/*"]),
    assets_dir = "resources/",
    custom_package="com.game.resources",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "op12-android",
    srcs = glob([
        "source/*.cpp",
        "headers/*.hpp",
    ]),
    includes = [
	"headers/",
    ],
    copts = ["-DANDROID"],
    deps = [
        "//third_party/lua:lua-lib",
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

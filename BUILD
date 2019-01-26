windows_deps = select({
    "@bazel_tools//src/conditions:windows": [
        "//third_party/SDL",
        "//third_party/SDL_mixer",
        "//third_party/SDL_image",
        "//third_party/SDL_ttf",
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
    name = "op12-android-resources",
    manifest = "//third_party/app-android/src/main:AndroidManifest.xml",
    assets = glob(["resources/**/*"]),
    assets_dir = "resources/",
    custom_package="com.temp.test",
    visibility = ["//visibility:public"],
)

android_library(
    name = "simple-resources",
    manifest = "//third_party/app-android/src/main:AndroidManifest.xml",
    assets = glob(["test/resources/**/*"]),
    assets_dir = "test/resources/",
    custom_package="com.temp.test",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "simple-android",
    srcs = glob([
        "test/*.cpp",
    ]),
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
    #actual = ":simple-android",
    visibility = ["//visibility:public"],
)

alias(
    name = "jni-resources",
    actual = ":op12-android-resources",
    #actual = ":simple-resources",
    visibility = ["//visibility:public"],
)

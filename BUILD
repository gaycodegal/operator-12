load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")

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
        "headers/*.hpp",
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

objc_library(
    name = "test-ios",
    #name = "operator-12-ios",
    #hdrs = glob([
    #]),
    srcs = glob([
        "headers/*.h",
        "source/*.cpp",
    ]),
    deps = [
        "//third_party/lua:lua-lib-objc",
        "//third_party/SDL:sdl2-ios",
        "//third_party/SDL_image:sdl2-image-ios",
        "//third_party/SDL_ttf:sdl2-ttf-ios",
        "//third_party/SDL_mixer:sdl2-mixer-ios",
    ],
    includes = [
	"headers/",
    ],
    structured_resources = glob(["resources/**"]),
    sdk_frameworks=["GameController", "Foundation", "UIKit", "OpenGLES", "QuartzCore", "CoreAudio", "AudioToolbox", "CoreGraphics", "CoreMotion", "AVFoundation", "ImageIO", "CoreServices"],
    copts = [
        "-D__IOS__",
        "-std=c++11",
        "-stdlib=libc++",
    ],
    visibility = ["//visibility:public"],
)

android_library(
    name = "op12-android-resources",
    manifest = "//third_party/app-android/src/main:AndroidManifest.xml",
    assets = glob(["resources/**/*"]),
    assets_dir = "resources/",
    custom_package="com.yourcompany.${PRODUCT_NAME:identifier}",
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

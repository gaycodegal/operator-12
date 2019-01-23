licenses(["notice"]) # MIT license

cc_binary(
    name = "libmain.so",
    srcs = glob(["*.c"]),
    visibility = ["//visibility:public"],
    linkshared=True,
)

android_library(
    name = "jni-resources",
    manifest = "AndroidManifest.xml",
    assets = glob(["resources/**/*"]),
    assets_dir = "resources/",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "main",
    srcs = glob(["*.cpp"]),
    visibility = ["//visibility:public"],
    data = ["hello_world.bmp"],
    deps = [
        "//third_party/sdl2/app-android/jni/SDL:SDL2_static",
        "//third_party/sdl2-image:SDL_image",
    ],
)

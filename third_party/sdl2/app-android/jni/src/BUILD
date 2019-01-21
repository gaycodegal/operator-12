licenses(["notice"]) # MIT license

cc_binary(
    name = "libmain.so",
    srcs = glob(["*.c"]),
    visibility = ["//visibility:public"],
    linkshared=True,
)

cc_library(
    name = "main",
    srcs = glob(["*.c"]),
    visibility = ["//visibility:public"],
    deps = [
        "//third_party/sdl2/app/jni/SDL:libSDL2.so",
        "//third_party/sdl2/app/jni/SDL:SDL2_static",
    ],
)

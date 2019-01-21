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

cc_library(
    name = "op12-android",
    srcs = ["test/simple_main.c"],
    deps = ["//third_party/sdl2/app/jni/SDL:SDL2_static"],
    linkopts = ["-static-libgcc -ldl -lm -lGLESv1_CM -lGLESv2 -llog -landroid"],
)

alias(
    name = "jni_library",
    actual = ":op12-android",
    visibility = ["//visibility:public"],
)

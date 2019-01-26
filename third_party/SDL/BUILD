licenses(["notice"]) # MIT license

ALIAS = select({
    "@bazel_tools//src/conditions:windows": ":sdl2-windows",
    "//conditions:default": ":sdl2-android",
})

alias(
    name = "SDL",
    actual = ALIAS,
    visibility = ["//visibility:public"],
)

SDL_HDRS = glob(["include/*.h"])

cc_library(
	name = "sdl2-windows",
	includes = ["include/"],
	deps = ["sdl2-dll"],
    visibility = ["//visibility:public"],
)

cc_import(
    name = "sdl2-dll",
    hdrs = glob(["include/*.h"]),
    interface_library = "lib/x64/SDL2.lib",
    shared_library = "lib/x64/SDL2.dll",
    visibility = ["//visibility:public"],
)

SDL_SRCS = SDL_HDRS + glob([
    "src/**/*.h",
    "src/*.c",
    "src/audio/*.c",
    "src/audio/android/*.c",
    "src/audio/dummy/*.c",
    "src/atomic/SDL_atomic.c",
    "src/atomic/SDL_spinlock.c",
    "src/core/android/*.c",
    "src/cpuinfo/*.c",
    "src/dynapi/*.c",
    "src/events/*.c",
    "src/file/*.c",
    "src/haptic/*.c",
    "src/haptic/android/*.c",
    "src/joystick/*.c",
    "src/joystick/android/*.c",
    "src/joystick/hidapi/*.c",
    "src/loadso/dlopen/*.c",
    "src/power/*.c",
    "src/power/android/*.c",
    "src/filesystem/android/*.c",
    "src/sensor/*.c",
    "src/sensor/android/*.c",
    "src/render/*.c",
    "src/render/*/*.c",
    "src/stdlib/*.c",
    "src/thread/*.c",
    "src/thread/pthread/*.c",
    "src/timer/*.c",
    "src/timer/unix/*.c",
    "src/video/*.c",
    "src/video/android/*.c",
    "src/video/yuv2rgb/*.c",
    "src/test/*.c",
])

SDL_COPTS = ["-DANDROID", "-DGL_GLEXT_PROTOTYPES"]
SDL_INCLUDES = ["include/"]
SDL_LINKOPTS = ["-ldl -lm -lGLESv1_CM -lGLESv2 -llog -landroid"]
SDL_DEPS = [":libhidapi.so"]

cc_binary(
    name = "libSDL2.so",
    srcs = SDL_SRCS,
    copts = SDL_COPTS,
    includes = SDL_INCLUDES,
    linkopts = SDL_LINKOPTS, 
    deps = SDL_DEPS,
    visibility = ["//visibility:public"],
    linkshared=True,
)


cc_library(
    name = "sdl2-android",
    srcs = SDL_SRCS,
    hdrs = SDL_HDRS,
    includes = SDL_INCLUDES,
    copts = SDL_COPTS,
    linkopts = SDL_LINKOPTS, 
    deps = [":hidapi_static"],
    visibility = ["//visibility:public"],
)

HIDAPI_HEADER = ["src/hidapi/hidapi/hidapi.h"]

cc_binary(
    name = "libhidapi.so",
    srcs = HIDAPI_HEADER + ["src/hidapi/android/hid.cpp"],
    includes = ["src/hidapi/hidapi/"],
    copts = ["-std=c++11"],
    linkopts = ["-llog"],
    linkshared=True,
)

cc_library(
    name = "hidapi_static",
    srcs = HIDAPI_HEADER + ["src/hidapi/android/hid.cpp"],
    includes = ["src/hidapi/hidapi/"],
    copts = ["-std=c++11"],
    linkopts = ["-llog"],
)

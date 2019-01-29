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

SDL_SRCS_ANDROID = SDL_HDRS + glob([
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

SDL_COPTS_ANDROID = ["-DANDROID", "-DGL_GLEXT_PROTOTYPES"]
SDL_INCLUDES = ["include/"]
SDL_LINKOPTS_ANDROID = ["-ldl -lm -lGLESv1_CM -lGLESv2 -llog -landroid"]
SDL_DEPS_ANDROID = [":libhidapi.so"]

cc_binary(
    name = "libSDL2.so",
    srcs = SDL_SRCS_ANDROID,
    copts = SDL_COPTS_ANDROID,
    includes = SDL_INCLUDES,
    linkopts = SDL_LINKOPTS_ANDROID, 
    deps = SDL_DEPS_ANDROID,
    visibility = ["//visibility:public"],
    linkshared=True,
)


cc_library(
    name = "sdl2-android",
    srcs = SDL_SRCS_ANDROID,
    hdrs = SDL_HDRS,
    includes = SDL_INCLUDES,
    copts = SDL_COPTS_ANDROID,
    linkopts = SDL_LINKOPTS_ANDROID, 
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

SDL_SRCS_IOS = glob([
    "src/**/*.h",
    "src/*.c",
    "src/audio/*.c",
    "src/audio/coreaudio/*.m",
    "src/audio/dummy/*.c",
    "src/atomic/SDL_atomic.c",
    "src/atomic/SDL_spinlock.c",
    "src/cpuinfo/*.c",
    "src/dynapi/*.c",
    "src/events/*.c",
    "src/file/*.c",
    "src/file/cocoa/*.m",
    "src/filesystem/*.m",
    "src/haptic/*.c",
    "src/haptic/dummy/*.c",
    "src/hidapi/ios/*.m",
    "src/joystick/*.c",
    "src/joystick/iphoneos/*.m",
    "src/joystick/hidapi/*.c",
    "src/loadso/dummy/*.c",
    "src/loadso/dlopen/*.c",
    "src/power/*.c",
    "src/power/uikit/*.m",
    "src/filesystem/android/*.c",
    "src/sensor/*.c",
    "src/sensor/coremotion/*.m",
    "src/sensor/dummy/*.c",
    "src/render/*.c",
    "src/render/metal/*.m",
    "src/render/opengles/*.c",
    "src/render/opengles2/*.c",
    "src/render/software/*.c",
    "src/stdlib/*.c",
    "src/thread/*.c",
    "src/thread/pthread/*.c",
    "src/timer/*.c",
    "src/timer/unix/*.c",
    "src/video/*.c",
    "src/video/uikit/*.m",
    "src/video/dummy/*.c",
    "src/video/yuv2rgb/*.c",
])

#print(SDL_SRCS_IOS)

objc_library(
    name = "sdl2-ios",
    srcs = SDL_SRCS_IOS,
    hdrs = SDL_HDRS,
    textual_hdrs=glob(["src/thread/generic/*.c",]),
    includes = SDL_INCLUDES,
    #copts = ["-DGL_GLEXT_PROTOTYPES"],
    visibility = ["//visibility:public"],
)

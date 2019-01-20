licenses(["notice"]) # MIT license

SDL_HDRS = glob(["include/*.h"])

cc_library(
	name = "sdl2",
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

cc_library(
    name = "sdl2-android",
    srcs = SDL_HDRS + glob([
        "src/**/*.h",
	"src/*.c",
	"src/audio/*.c",
	"src/audio/android/*.c",
	"src/audio/dummy/*.c",
	"src/atomic/SDL_atomic.c.arm",
	"src/atomic/SDL_spinlock.c.arm",
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
    ]),
    copts = ["-DGL_GLEXT_PROTOTYPES"],
    includes = ["include/"],
    linkopts = ["-static-libgcc -ldl -lGLESv1_CM -lGLESv2 -llog -landroid"], 
    deps = [":hidapi"],
    visibility = ["//visibility:public"],
)
HIDAPI_HEADER = ["src/hidapi/hidapi/hidapi.h"]

cc_library(
    name = "hidapi",
    srcs = HIDAPI_HEADER + ["src/hidapi/android/hid.cpp"],
    includes = ["src/hidapi/hidapi/"],
    copts = ["-std=c++11"],
    linkopts = ["-llog"],
)

licenses(["notice"]) # MIT license

ALIAS = select({
    "@bazel_tools//src/conditions:windows": ":sdl2-mixer-windows",
    "//conditions:default": ":sdl2-mixer-android",
})

alias(
    name = "SDL_mixer",
    actual = ALIAS,
    visibility = ["//visibility:public"],
)

load("//bzl:condition-include.bzl", "make_cc_options", "conditional_cc_options_add")

filegroup(
    name = "extra_libs",
    srcs = [
        "lib/x64/libogg-0.dll",
        "lib/x64/libvorbis-0.dll",
        "lib/x64/libvorbisfile-3.dll",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
	name = "sdl2-mixer-windows",
	includes = ["include/"],
	deps = ["sdl2-mixer-dll"],
    visibility = ["//visibility:public"],
)

cc_import(
    name = "sdl2-mixer-dll",
    hdrs = glob(["include/*.h"]),
    interface_library = "lib/x64/SDL2_mixer.lib",
    shared_library = "lib/x64/SDL2_mixer.dll",
    visibility = ["//visibility:public"],
)

options_sdl_mixer = make_cc_options(
    copts = ["-DLOAD_BMP", "-DLOAD_GIF", "-DLOAD_LBM", "-DLOAD_PCX", "-DLOAD_PNM", "-DLOAD_SVG", "-DLOAD_TGA", "-DLOAD_XCF", "-DLOAD_XPM", "-DLOAD_XV"],
    deps = ["//third_party/SDL"],
)

SUPPORT_OGG = True

options_sdl_mixer = conditional_cc_options_add(
    SUPPORT_OGG,
    options_sdl_mixer,
    copts = [
        "-DMUSIC_OGG",
        "-DOGG_USE_TREMOR",
        "-DOGG_HEADER=\"<ivorbisfile.h>\"",
    ],
    deps = [
        "//third_party/SDL_mixer/external/libogg-1.3.2:ogg",
        "//third_party/SDL_mixer/external/libvorbisidec-1.2.1:vorbisidec",
    ],
)

cc_library(
    name = "sdl2-mixer-android",
    includes = [""], #necessary to export SDL_mixer.h
    hdrs = glob(["*.h"]),
    srcs = glob(["*.c"], exclude = ["playmus.c", "playwave.c"]),
    copts = options_sdl_mixer["copts"],
    linkopts = options_sdl_mixer["linkopts"],
    deps = options_sdl_mixer["deps"],
    visibility = ["//visibility:public"],    
)

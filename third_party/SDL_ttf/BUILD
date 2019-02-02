licenses(["notice"]) # MIT license

ALIAS = select({
    "@bazel_tools//src/conditions:windows": ":sdl2-ttf-windows",
    "//conditions:default": ":sdl2-ttf-android",
})

alias(
    name = "SDL_ttf",
    actual = ALIAS,
    visibility = ["//visibility:public"],
)

load(":freebuilder.bzl", "freetype_libs")

#zlib1 already included by SDL_png
filegroup(
    name = "extra_libs",
    srcs = [
        "lib/x64/libfreetype-6.dll",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "sdl2-ttf-windows",
    includes = ["include/"],
    deps = ["sdl2-ttf-dll"],
    visibility = ["//visibility:public"],
)

cc_import(
    name = "sdl2-ttf-dll",
    hdrs = glob(["include/*.h"]),
    interface_library = "lib/x64/SDL2_ttf.lib",
    shared_library = "lib/x64/SDL2_ttf.dll",
    visibility = ["//visibility:public"],
)

FREETYPE_LIBRARY_PATH = "external/freetype-2.4.12"

LIBS = [x.split("/") for x in [
    "autofit/autofit",
    "base/ftbase",
    "base/ftbbox",
    "base/ftbdf",
    "base/ftbitmap",
    "base/ftcid",
    "base/ftdebug",
    "base/ftfstype",
    "base/ftgasp",
    "base/ftglyph",
    "base/ftgxval",
    "base/ftinit",
    "base/ftlcdfil",
    "base/ftmm",
    "base/ftotval",
    "base/ftpatent",
    "base/ftpfr",
    "base/ftstroke",
    "base/ftsynth",
    "base/ftsystem",
    "base/fttype1",
    "base/ftwinfnt",
    "base/ftxf86",
    "bdf/bdf",
    "bzip2/ftbzip2",
    "cache/ftcache",
    "cff/cff",
    "cid/type1cid",
    "gzip/ftgzip",
    "lzw/ftlzw",
    "pcf/pcf",
    "pfr/pfr",
    "psaux/psaux",
    "pshinter/pshinter",
    "psnames/psmodule",
    "raster/raster",
    "sfnt/sfnt",
    "smooth/smooth",
    "tools/apinames",
    "truetype/truetype",
    "type1/type1",
    "type42/type42",
    "winfonts/winfnt",
]]

# I apologize for this freetype compilation horror
# but it wouldn't build otherwise
freetype_libs(
    FREETYPE_LIBRARY_PATH,
    LIBS
)

cc_library(
    name = "freetype-headers",
    hdrs = glob([FREETYPE_LIBRARY_PATH + "/include/**/*.h"]),
    includes = [FREETYPE_LIBRARY_PATH + "/include/"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "freetype",
    deps = [
        ":freetype-headers",
    ] + [":" + x[1] for x in LIBS],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "sdl2-ttf-android",
    hdrs = ["SDL_ttf.h"],
    srcs = ["SDL_ttf.c"],
    copts = ["-DFT2_BUILD_LIBRARY"],
    includes = [""], # for SDL_ttf.h
    deps = ["//third_party/SDL", ":freetype"],
    visibility = ["//visibility:public"],
)

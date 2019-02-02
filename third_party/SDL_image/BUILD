licenses(["notice"]) # MIT license

ALIAS = select({
    "@bazel_tools//src/conditions:windows": ":sdl2-image-windows",
    "//conditions:default": ":sdl2-image-android",
})

alias(
    name = "SDL_image",
    actual = ALIAS,
    visibility = ["//visibility:public"],
)

load("//bzl:condition-include.bzl", "make_cc_options", "conditional_cc_options_add")

filegroup(
    name = "extra_libs",
    srcs = [
        "lib/x64/zlib1.dll",
        "lib/x64/libpng16-16.dll",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "sdl2-image-windows",
    includes = ["include/"],
    deps = ["sdl2-image-dll"],
    visibility = ["//visibility:public"],
)

cc_import(
    name = "sdl2-image-dll",
    hdrs = glob(["include/*.h"]),
    interface_library = "lib/x64/SDL2_image.lib",
    shared_library = "lib/x64/SDL2_image.dll",
    visibility = ["//visibility:public"],
)

# for android (compiling SDL_image from source)
# it would be desireable to specify SUPPORT_JPG/_PNG/_WEBP
# via the command line. Probably would implement
# by creating a custom rule then accessing ctx.env
# thus allowing:
#     SUPPORT_PNG=True bazel build ...

options_sdl_image = make_cc_options(
    copts = ["-DLOAD_BMP", "-DLOAD_GIF", "-DLOAD_LBM", "-DLOAD_PCX", "-DLOAD_PNM", "-DLOAD_SVG", "-DLOAD_TGA", "-DLOAD_XCF", "-DLOAD_XPM", "-DLOAD_XV"],
    deps = ["//third_party/SDL"],
)

SUPPORT_PNG = True

options_sdl_image = conditional_cc_options_add(
    SUPPORT_PNG,
    options_sdl_image,
    copts = ["-DLOAD_PNG"],
    linkopts = ["-lz"],
    deps = ["//third_party/SDL_image/external/libpng-1.6.32:png"],
)

cc_library(
    name = "sdl2-image-android",
    includes = [""], #necessary to export SDL_image.h
    hdrs = glob(["*.h"]),
    srcs = [
        "IMG.c",
        "IMG_bmp.c",
        "IMG_gif.c",
        "IMG_jpg.c",
        "IMG_lbm.c",
        "IMG_pcx.c",
        "IMG_png.c",
        "IMG_pnm.c",
        "IMG_svg.c",
        "IMG_tga.c",
        "IMG_tif.c",
        "IMG_webp.c",
        "IMG_WIC.c",
        "IMG_xcf.c",
        "IMG_xpm.c", # was supposed to be arm only
        "IMG_xv.c",
        "IMG_xxx.c",
    ],
    copts = options_sdl_image["copts"],
    linkopts = options_sdl_image["linkopts"],
    deps = options_sdl_image["deps"],
    visibility = ["//visibility:public"],    
)

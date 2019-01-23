licenses(["notice"]) # MIT license

cc_library(
    name = "sdl2-image",
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

SDL_Image_COPTS = ["-DLOAD_BMP", "-DLOAD_GIF", "-DLOAD_LBM", "-DLOAD_PCX", "-DLOAD_PNM", "-DLOAD_SVG", "-DLOAD_TGA", "-DLOAD_XCF", "-DLOAD_XPM", "-DLOAD_XV"]
SDL_Image_DEPS = ["//third_party/sdl2/app-android/jni/SDL:SDL2_static"]
SDL_Image_LINKOPTS = []

#SUPPORT_PNG = False
#if SUPPORT_PNG:
#    SDL_Image_COPTS += ["-DLOAD_PNG"]
#    SDL_Image_DEPS += ["external/libpng-1.6.32:libpng"]
#    SDL_Image_LINKOPTS += ["-lz"]

cc_library(
    name = "SDL_image",
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
    copts = SDL_Image_COPTS,
    linkopts = SDL_Image_LINKOPTS,
    deps = SDL_Image_DEPS,
    visibility = ["//visibility:public"],    
)

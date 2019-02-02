licenses(["notice"]) # libpng license

PNG_HDRS = glob(["*.h"])
cc_library(
    name = "png",
    includes = [""], #necessary to export png.h
    hdrs = PNG_HDRS,
    srcs = PNG_HDRS + ["png.c", "pngerror.c", "pngget.c", "pngmem.c", "pngpread.c", "pngread.c", "pngrio.c", "pngrtran.c", "pngrutil.c", "pngset.c", "pngtrans.c", "pngwio.c", "pngwrite.c", "pngwtran.c", "pngwutil.c"],    
    visibility = ["//visibility:public"],    
)

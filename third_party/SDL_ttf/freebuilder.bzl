def freetype_libs(FREETYPE_LIBRARY_PATH, LIBS):
    for folder, name in LIBS:
        freetype_lib(FREETYPE_LIBRARY_PATH + "/src/" + folder + "/", name)

def freetype_lib(LIB_PATH, NAME):
    native.cc_library(
        name = NAME,
        hdrs = native.glob([LIB_PATH + "*.h"]),
        textual_hdrs = native.glob(["*.c"], exclude = [LIB_PATH + NAME + ".c"]),
        srcs = [LIB_PATH + NAME + ".c"],
        includes = [""],
        copts = ["-DFT2_BUILD_LIBRARY"],
        deps = [":freetype-headers"],
        visibility = ["//visibility:public"],
    )

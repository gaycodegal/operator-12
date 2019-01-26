licenses(["notice"]) # BSD license

config_setting(
    name = "arm_build",
    values = {"cpu": "arm"},
)

COPTS = select({
    ":arm_build": [
        "-D_ARM_ASSEM_"
    ],
    "//conditions:default": [],
})

# wouldn't run without these
ARM_ONLY_SRCS = select({
    "//conditions:default": [
        "mdct.c",
        "window.c",
        "floor1.c",
        "floor0.c",
        "vorbisfile.c",
        "sharedbook.c",
    ],
})

cc_library(
    name = "vorbisidec",
    includes = [""],
    hdrs = glob(["*.h"]),
    srcs = ARM_ONLY_SRCS + [
        "block.c",
        "synthesis.c",
        "info.c",
        "res012.c",
        "mapping0.c",
        "registry.c",
        "codebook.c",
    ],
    copts = COPTS,
    visibility = ["//visibility:public"],
    deps = [
        "//third_party/SDL_mixer/external/libogg-1.3.2:ogg",
    ],
)

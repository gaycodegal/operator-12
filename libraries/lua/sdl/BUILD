load("//bzl:vars.bzl", "COPTS", "LINKOPTS")

cc_library(
    name = "sdl",
    srcs = glob([
        "*.cpp",
    ]),
    hdrs = glob([
        "*.h",
    ]),
    copts = COPTS,
    linkopts = LINKOPTS,
    deps = [
        "//libraries/sdl/include",
        "//libraries/lua/include",
        "//libraries/globals",
        "//libraries/util/lua",
    ],
    includes = [""],
    visibility = ["//visibility:public"],
)

load("//bzl:vars.bzl", "COPTS", "LINKOPTS")

cc_library(
    name = "map",
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
        "//libraries/lua/sdl",
        "//libraries/globals",
        "//libraries/util/lua",
    ],
    includes = [""],
    visibility = ["//visibility:public"],
)

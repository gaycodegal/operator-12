load("//bzl:vars.bzl", "COPTS", "LINKOPTS")

cc_library(
    name = "loader",
    srcs = glob([
        "*.cpp",
    ]),
    hdrs = glob([
        "*.h",
    ]),
    copts = COPTS,
    linkopts = LINKOPTS,
    deps = [
        "//libraries/lua/include",
        "//libraries/lua/map",
        "//libraries/lua/sdl",
        "//libraries/lua/bits",
        "//libraries/util/lua",
    ],
    includes = [""],
    visibility = ["//visibility:public"],
)

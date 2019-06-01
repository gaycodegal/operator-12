load("//bzl:vars.bzl", "COPTS", "LINKOPTS")

cc_library(
    name = "lua",
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
        "//libraries/util/files",
    ],
    includes = [""],
    visibility = ["//visibility:public"],
)

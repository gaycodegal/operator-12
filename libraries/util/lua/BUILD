load("//bzl:vars.bzl", "COPTS", "LINKOPTS")

cc_library(
    name = "lua",
    srcs = glob([
        "*.cc",
    ]),
    hdrs = glob([
        "*.hh",
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

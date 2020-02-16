load("//bzl:vars.bzl", "COPTS", "LINKOPTS")

cc_library(
    name = "files",
    srcs = glob([
        "*.cc",
    ]),
    hdrs = glob([
        "*.hh",
    ]),
    copts = COPTS,
    linkopts = LINKOPTS,
    deps = [
        "//libraries/sdl/include",
    ],
    includes = [""],
    visibility = ["//visibility:public"],
)

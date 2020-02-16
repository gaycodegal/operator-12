COPTS = select({
    "@bazel_tools//src/conditions:darwin": [
        "-std=c++11",
         "-stdlib=libc++",
	 "-F/Library/Frameworks",
    ],
    "@bazel_tools//src/conditions:windows": [],
    "//conditions:default": [
        "-std=c++11",
    ],
})

LINKOPTS = select({
    "@bazel_tools//src/conditions:darwin": [
        "-F/Library/Frameworks",
        "-ldl",
        "-lm",
    ],
    "@bazel_tools//src/conditions:windows": [],
    "//wasm_toolchain:asmjs" : [
    ],
    "//conditions:default": [
        "-ldl",
        "-lm",
    ],
})

cc_library(
    name = "include",
    hdrs = glob([
        "*.hh",
    ]),
    deps = [
        "//third_party/lua:lua-lib",
        "//libraries/std/include",
    ],
    includes = [""],
    copts = COPTS,
    linkopts = LINKOPTS,
    visibility = ["//visibility:public"],
)

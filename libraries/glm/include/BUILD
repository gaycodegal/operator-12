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
        "*.h",
    ]),
    deps = [
        "//third_party/glm",
        "//third_party/glm:gtc_matrix_transform",
        "//third_party/glm:gtc_type_ptr",
        "//third_party/glm:gtx_string_cast",
    ],
    includes = [""],
    copts = COPTS,
    linkopts = LINKOPTS,
    visibility = ["//visibility:public"],
)

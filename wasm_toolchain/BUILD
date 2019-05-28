package(default_visibility = ['//visibility:public'])

config_setting(
    name = "asmjs",
    values = {"cpu": "asmjs"},
)

cc_toolchain_suite(
    name = "emscripten",
    toolchains = {
        "asmjs": ":asmjs_toolchain",
        "asmjs|emscripten": ":asmjs_toolchain",
    },
)

filegroup(name = "empty")

filegroup(
    name = "emscripten_toolchain",
    srcs = glob(["emscripten_toolchain/**/*"]),
)

filegroup(
    name = "emscripten_clang",
    srcs = glob(["emscripten_clang/**/*"]),
)

filegroup(
    name = "emscripten_cache_content",
    srcs = glob(["emscripten_cache/**/*"]),
)

filegroup(
    name = "all",
    srcs = [
        "emcc.sh",
        "emar.sh",
        ":emscripten_toolchain",
        ":emscripten_clang",
        ":emscripten_cache_content",
    ],
)

cc_toolchain(
    name = "asmjs_toolchain",
    toolchain_identifier = "asmjs-toolchain",
    all_files = ":all",
    compiler_files = ":all",
    cpu = "asmjs",
    dwp_files = ":empty",
    dynamic_runtime_libs = [":empty"],
    linker_files = ":all",
    objcopy_files = ":empty",
    static_runtime_libs = [":empty"],
    strip_files = ":empty",
    supports_param_files = 0,
)

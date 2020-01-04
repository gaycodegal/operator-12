load(":bind.bzl", "lua_bind_cpp")

exports_files(
    ["bind.bzl"],
    visibility = ["//visibility:public"],
)

py_binary(
    name = "gen-lua-cpp-binding",
    python_version = "PY3",
    srcs = ["gen-lua-cpp-binding.py"],
    visibility = ["//visibility:public"],
)

lua_bind_cpp(
    name = "test",
    src = "test-src.cpp",
)

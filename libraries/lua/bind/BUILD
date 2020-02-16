load(":bind.bzl", "lua_bind_cpp")

exports_files(
    ["bind.bzl"],
    visibility = ["//visibility:public"],
)

py_binary(
    name = "gen_lua_cpp_binding",
    python_version = "PY3",
    srcs = ["gen_lua_cpp_binding.py", "lua_cpp_binding_helpers.py"],
    visibility = ["//visibility:public"],
)

lua_bind_cpp(
    name = "test",
    src = "test-src.cc",
)

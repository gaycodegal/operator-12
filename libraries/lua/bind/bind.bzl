def lua_bind_cpp(name, src):
    native.genrule(
        name = name,
        cmd = "$(location //libraries/lua/bind:gen_lua_cpp_binding) $(location {}) $(@D) {}".format(src, name),
        srcs = [src],
        outs = [name + ".cpp", name + ".h"],
        tools = ["//libraries/lua/bind:gen_lua_cpp_binding"],
    )



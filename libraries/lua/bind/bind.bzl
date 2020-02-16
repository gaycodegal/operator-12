def lua_bind_cpp(name, src):
    native.genrule(
        name = name,
        cmd = "$(location //libraries/lua/bind:gen_lua_cpp_binding) $(location {}) $(@D) {}".format(src, name),
        srcs = [src],
        outs = [name + ".cc", name + ".hh"],
        tools = ["//libraries/lua/bind:gen_lua_cpp_binding"],
    )



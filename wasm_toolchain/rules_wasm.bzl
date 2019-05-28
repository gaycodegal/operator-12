POSTFIXES = [".wasm", ".js", ".html"]

def wasm_binary(
        name = "main.o",
        srcs = [],
        deps = [],
        includes = [],
        data = [],
        copts = [],
        linkopts = []):
    # only give them as much as they asked for
    extension = "." + name.split(".")[-1]
    basename = name[:-len(extension)]
    postfixes = POSTFIXES[:POSTFIXES.index(extension) + 1]
    fullnames = [basename + postfix for postfix in postfixes]
    o_name = basename + ".o"
    native.cc_binary(
        name = o_name,
        srcs = srcs,
        deps = deps,
        includes = includes,
        data = data,
        copts = copts,
        linkopts = linkopts,
    )
    native.genrule(
        name = "_" + name,
        srcs = data + [o_name],
        outs = fullnames,
        cmd = "wasm_toolchain/em_gen.sh \"$(location :" + o_name + ")\" -o \"$(@D)/" + name +"\" " + " ".join(copts), 
    )

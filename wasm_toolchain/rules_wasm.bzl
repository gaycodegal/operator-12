POSTFIXES = [".wasm", ".js", ".html"]

def wasm_binary(
        name = "main.o",
        data = [],
        copts = [],
        **kwargs):
    """Generates the rule(s) for creating the .html, .js, .wasm, or .o
    desired for asmjs compilation. 

    If you only want a .o, you can just use cc_binary. Also generates
    .data files, but .data is not a valid extension for wasm_binary
    rule names. 

    For instance a name of "my-test.html" with preloaded data
    would generate "my-test.html", "my-test.js", "my-test.wasm",
    and "my-test.data". The actual rule generated would be
    named "_my-test.html" because bazel doesn't like when files and rules
    have the same name even though this is what all the other *_binary
    rules do"""
    extension = "." + name.split(".")[-1]
    basename = name[:-len(extension)]
    
    # only give them as much as they asked for
    postfixes = POSTFIXES[:POSTFIXES.index(extension) + 1]
    fullnames = [basename + postfix for postfix in postfixes]
    o_name = basename + ".o"

    #check if .data file will be generated
    for copt in copts:
        if copt.startswith("--preload"):
            fullnames.append(basename + ".data")
            break

    # compile the name.o
    native.cc_binary(
        name = o_name,
        data = data,
        copts = copts,
        **kwargs)

    # if all they want is a .o do no more
    if extension == ".o":
        return

    # generate .html, .js, .wasm, and .data as applicable.
    native.genrule(
        name = name + ".all",
        srcs = data + [o_name],
        outs = fullnames,
        cmd = "wasm_toolchain/em_gen.sh \"$(location :" + o_name + ")\" -o \"$(@D)/" + name +"\" " + " ".join(copts), 
    )

def _impl(repository_ctx):
    # shenanigans to get the wasm_toolchain to copy
    p = str(repository_ctx.path(Label("//wasm_toolchain:emar.sh")))
    p = p[:-p.rindex("/")]
    repository_ctx.symlink(p, "wasm_toolchain")

    emtoolchain = repository_ctx.os.environ.get("EMSCRIPTEN_TOOLCHAIN")
    emcache = repository_ctx.os.environ.get("EMSCRIPTEN_CACHE")
    emclang = repository_ctx.os.environ.get("EMSCRIPTEN_CLANG")

    # ensure we don't fail if symlinks exist
    repository_ctx.delete("wasm_toolchain/emscripten_toolchain")
    repository_ctx.delete("wasm_toolchain/emscripten_cache")
    repository_ctx.delete("wasm_toolchain/emscripten_clang")

    # create the symlinks needed by wasm_toolchain
    repository_ctx.symlink(emtoolchain, "wasm_toolchain/emscripten_toolchain")
    repository_ctx.symlink(emcache, "wasm_toolchain/emscripten_cache")
    repository_ctx.symlink(emclang, "wasm_toolchain/emscripten_clang")

    # build the required ports
    embuilder = repository_ctx.path("wasm_toolchain/emscripten_toolchain/embuilder.py")
    args = ["python", embuilder, "build"]
    args.extend(repository_ctx.attr.ports)
    repository_ctx.execute(args, quiet=False)

emscripten_port_repo = repository_rule(
    implementation=_impl,
    local=True,
    configure=True,
    attrs={'ports': attr.string_list(mandatory=True)})

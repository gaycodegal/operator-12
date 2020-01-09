# Bazel

Install bazel on linux set up for C++ development.


# Library Installation

Custom Libraries you'll need

- [glm-0.9.9.6](https://github.com/g-truc/glm/tags)
- Lua 5.3.4
  - Installation instructions available at [www.lua.org](https://www.lua.org/download.html)
  - Should be located in `third_party/lua` such that `third_party/lua/src` is the lua `src/` directory. You don't particularly need the `docs` directory, but it's usually useful when developing in lua to have the docs handy.
  - You don't need command-line lua

You'll also need `emscripten` to compile C++ code.

You'll need the following environment variables set

    export EMSCRIPTEN_TOOLCHAIN="/path/to/emsdk/emscripten/1.38.31"
    export EMSCRIPTEN_CACHE="/path/to/.emscripten_cache"
    export EMSCRIPTEN_CLANG="/path/to/emsdk/clang/e1.38.31_64bit"

You'll need to have emscripten build the neccessary ports so run

    bazel sync --configure


# Compilation

    bazel build --config asmjs //:main.html
	

# Running

    bazel run --config asmjs //:main.html
	
You then should visit http://localhost:8080/main.html to visit the game.


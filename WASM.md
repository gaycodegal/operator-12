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

You'll need to have emscripten build the neccessary ports so run

    bazel sync --configure


# Compilation

    bazel build //:operator-12 --spawn_strategy=standalone
	

# Running

    bazel run //:operator-12
	
You can also specify which lua file to run as the main. For instance `bazel run //:operator-12 surface-tests` will run the surface tests lua file as the main lua file.


# Bazel

Install bazel on Windows set up for C++ development. Make sure to follow all the other steps carefully such as installing a proper version of Visual Studio etc.


# Library Installation

Custom Libraries you'll need from libsdl.org listed below. For all of the SDL libraries make sure to move the `include` and `lib` folder into the corresponding `third_party` sub-directory. The BUILD files for SDL are currently set to target x64 (64-bit) but you can easily modify the build files to support x86 if that is your desire.

- SDL2-Dev-VC
- SDL2-Image-Dev-VC
- SDL2-TTF-Dev-VC
- SDL-Mixer-Dev-VC
- Lua 5.3.4
  - Installation instructions available at [www.lua.org](https://www.lua.org/download.html)
  - Should be located in `third_party/lua` such that `third_party/lua/src` is the lua `src/` directory. You don't particularly need the `docs` directory, but it's usually useful when developing in lua to have the docs handy.
  - You don't need command-line lua


# Compilation

    bazel build //:operator-12 --spawn_strategy=standalone
	

# Running

While Bazel will build the operator-12.exe for you, it will not move files into the .runfiles directory. It will also not move all the .dlls needed from their third_party location to their required location. I will eventually create a build rule to create a tar/zip file containing all the relevant files required to run the game.

# Bazel

Install bazel on Mac OS set up for C++ development. Make sure to install Xcode & whatever else it asks for, including accepting the Xcode license agreements.


# Library Installation

Custom Libraries you'll need from libsdl.org listed below. Install the SDL2 frameworks in `/Library/Frameworks`. Be sure to get the development libraries (hosted on libsdl as `.dmg`s).

- SDL2-Dev
- SDL2-Image-Dev
- SDL2-TTF-Dev
- SDL2-Mixer-Dev
- Lua 5.3.4
  - Installation instructions available at [www.lua.org](https://www.lua.org/download.html)
  - Should be located in `third_party/lua` such that `third_party/lua/src` is the lua `src/` directory. You don't particularly need the `docs` directory, but it's usually useful when developing in lua to have the docs handy.
  - You don't need command-line lua


# Compilation

    bazel build //:operator-12 --spawn_strategy=standalone
	

# Running

    bazel run //:operator-12
	
You can also specify which lua file to run as the main. For instance `bazel run //:operator-12 surface-tests` will run the surface tests lua file as the main lua file.


# Caveats

Creates an executable, but not a full packaged app. Probably due to components being missing like a info.plist file.

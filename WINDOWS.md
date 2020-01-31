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

    bazel build //:main --spawn_strategy=standalone
	

# Running

Bazel on windows doesn't automatically bring together all the files you need and instead writes a MANIFEST file. Additionally, I found it hard to get all the DLLs in the right place for building. Thus there's a genrule `//:packaged` that creates a zip file with all the necessary files in it. To create this run:

	bazel build //:packaged --spawn_strategy=standalone

Then simply extract the zip and run the `main.exe` program within.

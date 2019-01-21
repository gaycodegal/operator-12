licenses(["notice"]) # MIT license

SDL_HDRS = glob(["include/*.h"])

cc_library(
	name = "sdl2",
	includes = ["include/"],
	deps = ["sdl2-dll"],
    visibility = ["//visibility:public"],
)

cc_import(
    name = "sdl2-dll",
    hdrs = glob(["include/*.h"]),
    interface_library = "lib/x64/SDL2.lib",
    shared_library = "lib/x64/SDL2.dll",
    visibility = ["//visibility:public"],
)

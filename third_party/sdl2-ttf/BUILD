licenses(["notice"]) # MIT license

cc_library(
	name = "sdl2-ttf",
	includes = ["include/"],
	deps = ["sdl2-ttf-dll"],
    visibility = ["//visibility:public"],
)

cc_import(
    name = "sdl2-ttf-dll",
    hdrs = glob(["include/*.h"]),
    interface_library = "lib/x64/SDL2_ttf.lib",
    shared_library = "lib/x64/SDL2_ttf.dll",
    visibility = ["//visibility:public"],
)

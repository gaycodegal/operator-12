licenses(["notice"]) # MIT license

cc_library(
	name = "sdl2-mixer",
	includes = ["include/"],
	deps = ["sdl2-mixer-dll"],
    visibility = ["//visibility:public"],
)

cc_import(
    name = "sdl2-mixer-dll",
    hdrs = glob(["include/*.h"]),
    interface_library = "lib/x64/SDL2_mixer.lib",
    shared_library = "lib/x64/SDL2_mixer.dll",
    visibility = ["//visibility:public"],
)

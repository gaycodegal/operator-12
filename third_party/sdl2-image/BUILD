licenses(["notice"]) # MIT license

cc_library(
	name = "sdl2-image",
	includes = ["include/"],
	deps = ["sdl2-image-dll"],
    visibility = ["//visibility:public"],
)

cc_import(
    name = "sdl2-image-dll",
    hdrs = glob(["include/*.h"]),
    interface_library = "lib/x64/SDL2_image.lib",
    shared_library = "lib/x64/SDL2_image.dll",
    visibility = ["//visibility:public"],
)

android_sdk_repository(
    name = "androidsdk",
)
android_ndk_repository(
    name = "androidndk",
    api_level=19,
)
workspace(
    name = "opengl_wasm",
)

load("//bzl:emscripten-repo.bzl", "emscripten_port_repo")
emscripten_port_repo(name="emscripten_ports", ports=["libc++_noexcept", "freetype", "pthreads_stub", "zlib", "libc++abi", "compiler-rt", "gl", "sdl2", "libc", "libc-wasm", "gl-webgl2",  "sdl2-image",  "sdl2-image-png", "libc-extras", "dlmalloc", "libpng", "sdl2-ttf"])

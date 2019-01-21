licenses(["notice"]) # MIT license
#load("@gmaven_rules//:defs.bzl", "gmaven_artifact")
android_binary(
    name = "app",
    manifest = "AndroidManifest.xml",
    resource_files = glob(["res/**/*"]),
    srcs = glob([
        "java/**/*.java",
    ]),
    #assets=["//third_party/sdl2/app-android/jni/src:jni-resources"],
    #assets_dir="resources/",
    deps = [
        "//third_party/sdl2/app-android/jni/src:jni-resources",
        "//third_party/sdl2/app-android/jni/src:main",
    ],
)

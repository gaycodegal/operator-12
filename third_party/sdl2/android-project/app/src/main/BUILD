licenses(["notice"]) # MIT license
#load("@gmaven_rules//:defs.bzl", "gmaven_artifact")

android_binary(
    name = "app",
    manifest = "AndroidManifest.xml",
    resource_files = glob(["res/**/*"]),
    srcs = glob([
        "java/org/libsdl/app/*.java",
    ]),
    deps = [
        "//:jni_library",
    ],
)

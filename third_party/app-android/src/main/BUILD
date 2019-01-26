licenses(["notice"]) # MIT license

exports_files(
    ["AndroidManifest.xml"],
)

android_binary(
    name = "app",
    manifest = "AndroidManifest.xml",
    resource_files = glob(["res/**/*"]),
    srcs = glob([
        "java/**/*.java",
    ]),
    deps = [
        "//:jni-resources",
        "//:jni_library",
    ],
)

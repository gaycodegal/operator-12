load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")

ios_application(
    name = "app-ios",
    bundle_id = "com.temp.testing",
    families = [
        "iphone",
        "ipad",
    ],
    infoplists = ["Info.plist"],
    visibility = ["//visibility:public"],
    deps = ["//:test-ios"],
)

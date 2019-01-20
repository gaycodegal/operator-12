# Changes

Had to switch to linux - Android compilation does not work very well on windows with regard to linking, android studio plugins.
Had to install an older version of NDK due to being unsupported by latest bazel

    wget https://dl.google.com/android/repository/android-ndk-r18-linux-x86_64.zip

Turned off `SDL_DYNAMIC_API` in SDL_dynapi.h - couldn't figure out how to properly make dynapi work with Bazel on Android.

# Build

    bazel build //third_party/sdl2/android-project/app/src/main:app --fat_apk_cpu=x86


# Changes

Had to switch to linux - Android compilation does not work very well on windows with regard to linking, android studio plugins.
Had to install an older version of NDK due to being unsupported by latest bazel

    wget https://dl.google.com/android/repository/android-ndk-r18-linux-x86_64.zip

Removed the .arm in the compile commands - the SDL2 make files were ignoring this directive (.arm means only compile on arm platforms. However, SDL would compile these sources on all platforms. Bazel, meanwhile, would respect this and then the required functions would not be included in the final .so)

Changed //third_party/sdl2/app-android/src/main/java/org/libsdl/app/SDLActivity.java to only load `libapp.so`.

app-android folder is the corresponding app folder that SDL2 generates on build. Not quite helpful; will reconfigure the project later.

# Build

    bazel build //third_party/sdl2/android-project/app/src/main:app --fat_apk_cpu=x86

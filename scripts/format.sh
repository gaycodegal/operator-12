cd "$BUILD_WORKING_DIRECTORY"
clang-format -i $(find libraries/ -iname '*.cpp')
clang-format -i $(find libraries/ -iname '*.h')
clang-format -i $(find cpp/ -iname '*.cpp')
clang-format -i $(find cpp/ -iname '*.h')

cd "$BUILD_WORKING_DIRECTORY"
clang-format -i $(find libraries/ -iname '*.cc')
clang-format -i $(find libraries/ -iname '*.hh')
clang-format -i $(find cpp/ -iname '*.cc')
clang-format -i $(find cpp/ -iname '*.hh')

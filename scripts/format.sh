cd "$BUILD_WORKING_DIRECTORY"
clang-format -i $(find engine/ -iname '*.cc')
clang-format -i $(find engine/ -iname '*.hh')

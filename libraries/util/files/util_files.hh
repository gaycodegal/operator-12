#pragma once

#include "sdl_include.hh"
#include <string>

/**
   reads in the text content of a file.
   allocates and returns a c string.
 */
std::string fileRead(const char* fname, bool& success);


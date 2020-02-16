#ifndef _UTIL_FILES_H_
#define _UTIL_FILES_H_

#include "sdl_include.hh"

/**
   reads in the text content of a file.
   allocates and returns a c string.
 */
char *fileRead(const char *fname, Sint64 &size);

#endif

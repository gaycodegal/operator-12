#ifndef _LUA_FLOAT_ARRAY_H_
#define _LUA_FLOAT_ARRAY_H_

#include "sdl_include.h"
#include "lua_include.h"
#include "util_lua.h"

/**
   A sized GLfloat array;
 */
struct FloatArray {
  GLfloat* data;
  GLsizeiptr size;
};

#endif

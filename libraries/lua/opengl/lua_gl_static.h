#ifndef _LUA_GL_STATIC_H_
#define _LUA_GL_STATIC_H_

#include "sdl_include.h"
#include "lua_include.h"
#include "util_lua.h"

/**
   A sized void array;
 */
struct VoidArray {
  void* data;
  GLsizeiptr length;
};

#endif

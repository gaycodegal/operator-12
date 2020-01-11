#pragma once

#include "sdl_include.h"
#include "glm_include.h"
#include "lua_include.h"
#include "util_lua.h"

/**
   A sized void array;
 */
struct VoidArray {
  void* data;
  GLsizeiptr length;
};

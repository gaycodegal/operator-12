#include "main.h"

/**
   @lua-name new
   @lua-arg vert: string
   @lua-arg frag: string
   @lua-return Class Shader
 */
static void* l_shader_new(char* vert, char* frag) {
  return NULL;
}

/**
   @lua-name use
   @lua-arg self: Class Shader
 */
static void l_shader_use(lua_State *L) {
  return 0;
}

static const struct luaL_Reg shader_meta[] = {
  {"new", l_shader_new},
  {"use", l_shader_use},
  {NULL, NULL}};

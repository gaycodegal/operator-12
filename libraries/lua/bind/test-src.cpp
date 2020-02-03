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
   @lua-metas
   @lua-name use
 */
static int l_shader_use(lua_State *L) {
  return 0;
}

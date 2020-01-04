#include "lua_shader.h"

/**
   @lua-constructor
   @lua-name new
   @lua-arg vert: string
   @lua-arg frag: string
   @lua-return Class Shader
 */
static Shader* l_shader_new(const char* vert, const char* frag) {
  return new Shader(vert, frag);
}

/**
   @lua-name use
   @lua-arg self: Class Shader
 */
static void l_shader_use(Shader *self) {
  self->useProgram();
}

/**
   @lua-name destroy
   @lua-arg self: Delete Shader
 */
static void l_shader_delete(Shader *self) {
  delete self;
}

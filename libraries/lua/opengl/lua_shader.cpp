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
  glUseProgram(self->program());
}

/**
   @lua-name getUniformLocation
   @lua-arg self: Class Shader
   @lua-arg name: string
   @lua-return int
 */
static lua_Integer shader_get_uniform_location(Shader *self, const char* name) {
  return glGetUniformLocation(self->program(), name);
}

/**
   @lua-name getAttribLocation
   @lua-arg self: Class Shader
   @lua-arg name: string
   @lua-return int
 */
static lua_Integer shader_get_attrib_location(Shader *self, const char* name) {
  return glGetAttribLocation(self->program(), name);
}

/**
   @lua-name destroy
   @lua-arg self: Delete Shader
 */
static void l_shader_delete(Shader *self) {
  delete self;
}

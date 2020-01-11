#include "lua_glm_static.h"

/**
   @lua-constructor
   @lua-name new
   @lua-return Class glm::mat4 Mat4
 */
static glm::mat4* mat4_new() {
  return new glm::mat4(1.0f);
}

/**
   @lua-name rotate
   @lua-arg self: Class glm::mat4
   @lua-arg radians: number
   @lua-arg axis: Class glm::vec3
   @lua-return Class glm::mat4 Mat4
 */
static glm::mat4* mat4_rotate(glm::mat4* self, lua_Number radians, glm::vec3* axis) {
  GLfloat rads = radians;
  glm::mat4* mat = new glm::mat4();
  *mat = glm::rotate(*self, rads, *axis);
  return mat;
}

/**
   @lua-name scale
   @lua-arg self: Class glm::mat4
   @lua-arg v: Class glm::vec3
   @lua-return Class glm::mat4 Mat4
 */
static glm::mat4* mat4_scale(glm::mat4* self, glm::vec3* v) {
  glm::mat4* mat = new glm::mat4();
  *mat = glm::scale(*self, *v);
  return mat;
}

/**
   @lua-name translate
   @lua-arg self: Class glm::mat4
   @lua-arg v: Class glm::vec3
   @lua-return Class glm::mat4 Mat4
 */
static glm::mat4* mat4_translate(glm::mat4* self, glm::vec3* v) {
  glm::mat4* mat = new glm::mat4();
  *mat = glm::translate(*self, *v);
  return mat;
}

/**
   @lua-name __tostring
   @lua-arg self: Class glm::mat4
   @lua-return String
 */
static std::string mat4_tostring(glm::mat4* self) {
  return glm::to_string(*self);
}


/**
   @lua-name __gc
   @lua-arg self: Delete glm::mat4
 */
static void mat4_destroy(glm::mat4* self) {
  delete self;
}

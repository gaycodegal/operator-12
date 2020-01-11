#include "lua_glm_static.h"

/**
   @lua-constructor
   @lua-name new
   @lua-arg x: number
   @lua-arg y: number
   @lua-arg z: number
   @lua-return Class glm::vec3 Vec3
 */
static glm::vec3* vec3_new(lua_Number x, lua_Number y, lua_Number z) {
  return new glm::vec3(x, y, z);
}

/**
   @lua-name lookAtLH
   @lua-arg eye: Class glm::vec3
   @lua-arg center: Class glm::vec3
   @lua-arg up: Class glm::vec3
   @lua-return Class glm::mat4 Mat4
 */
static glm::mat4* lookAtLH(glm::vec3* eye, glm::vec3* center, glm::vec3* up) {
  glm::mat4* mat = new glm::mat4();
  *mat = glm::lookAtLH(*eye, *center, *up);
  return mat;
}

/**
   @lua-name lookAtRH
   @lua-arg eye: Class glm::vec3
   @lua-arg center: Class glm::vec3
   @lua-arg up: Class glm::vec3
   @lua-return Class glm::mat4 Mat4
 */
static glm::mat4* lookAtRH(glm::vec3* eye, glm::vec3* center, glm::vec3* up) {
  glm::mat4* mat = new glm::mat4();
  *mat = glm::lookAtRH(*eye, *center, *up);
  return mat;
}

/**
   @lua-name __tostring
   @lua-arg self: Class glm::vec3
   @lua-return String
 */
static std::string vec3_tostring(glm::vec3* self) {
  return glm::to_string(*self);
}

/**
   @lua-name __gc
   @lua-arg self: Delete glm::vec3
 */
static void mat4_destroy(glm::vec3* self) {
  delete self;
}

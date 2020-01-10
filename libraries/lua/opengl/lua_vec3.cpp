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

#include "lua_glm_static.h"

/**
   @lua-name radians
   @lua-arg degrees: number
   @lua-return number
 */
static lua_Number radians(lua_Number degrees) {
  return glm::radians(degrees);
}

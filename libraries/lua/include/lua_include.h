#ifndef _LUA_INCLUDE_H_
#define _LUA_INCLUDE_H_

#include "std_include.h"

// needs extern because of linking
extern "C" {
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
};

/**
   used for creating lists of classes mapped to names
 */
struct luaClassList {
  const char *name;
  const struct luaL_Reg *meta;
};

#endif

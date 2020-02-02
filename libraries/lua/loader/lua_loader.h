#ifndef _LUA_LOADER_H_
#define _LUA_LOADER_H_

#include "lua_include.h"
#include "lua_map.h"
#include "lua_music.h"
#include "bound_sprite.h"
#include "lua_static.h"
#include "bound_surface.h"
#include "bound_texture.h"
#include "bound_ttf.h"

/**
   loads the sprite library into lua
 */
int luaopen_gamelibs(lua_State *L);

#endif

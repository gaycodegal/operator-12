#ifndef _LUA_LOADER_H_
#define _LUA_LOADER_H_

#include "bound_music.hh"
#include "bound_screen.hh"
#include "bound_sprite.hh"
#include "bound_static.hh"
#include "bound_surface.hh"
#include "bound_texture.hh"
#include "bound_ttf.hh"
#include "lua_include.hh"
#include "lua_map.hh"

/**
   loads the sprite library into lua
 */
int luaopen_gamelibs(lua_State *L);

#endif

#ifndef _MAIN_HPP_
#define _MAIN_HPP_
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_mixer.h>
#include <SDL2/SDL_ttf.h>
// needs extern because of linking
#include <unistd.h>
extern "C" {
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
};
#include "lua_helpers.hpp"
#include "lua_sprites.hpp"
#include "sprite.hpp"
#include <stdio.h>

/**
   used for creating lists of classes mapped to names
 */
struct luaClassList {
  const char *name;
  const struct luaL_Reg *meta;
};

// Screen dimension constants
extern const int SCREEN_WIDTH;
extern const int SCREEN_HEIGHT;

// global SDL2 variables
extern SDL_Window *window;
extern SDL_Surface *screenSurface;
extern SDL_Renderer *globalRenderer;
extern bool quit;
#endif

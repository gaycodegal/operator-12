#ifndef _MAIN_HPP_
#define _MAIN_HPP_
#ifdef _WIN32

#include <SDL.h>
#include <SDL_image.h>
#include <SDL_mixer.h>
#include <SDL_ttf.h>
#include <Windows.h>

#elif ANDROID

#include <SDL.h>
#include <SDL_image.h>
#include <SDL_mixer.h>
#include <SDL_ttf.h>
#include <android/log.h>
#include <jni.h>
#include <stdlib.h>
#include <unistd.h>
#define printf(...)                                                            \
  __android_log_print(ANDROID_LOG_DEBUG, "PRINTF", __VA_ARGS__)
#elif __EMSCRIPTEN__

#include <SDL.h>
#include <SDL_image.h>
#include <SDL_ttf.h>
#include <emscripten.h>
#include <unistd.h>

#else

#include <SDL2/SDL_mixer.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
#include <unistd.h>

#endif
// needs extern because of linking

extern "C" {
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
};
#include "lua_helpers.hpp"
#include "lua_sprites.hpp"
#include "sprite.hpp"
#include <chrono>
#include <stdio.h>
#include <string>
/**
   used for creating lists of classes mapped to names
 */
struct luaClassList {
  const char *name;
  const struct luaL_Reg *meta;
};

// Screen dimension constants
extern int SCREEN_WIDTH;
extern int SCREEN_HEIGHT;
// global SDL2 variables
extern SDL_Window *window;
extern SDL_Surface *screenSurface;
extern SDL_Renderer *globalRenderer;
extern TTF_Font *gFont;

extern bool quit;
extern int framedelay;
#endif

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
#elif __APPLE__

#include <SDL2/SDL.h>
#include <SDL2_image/SDL_image.h>
#include <SDL2_mixer/SDL_mixer.h>
#include <SDL2_ttf/SDL_ttf.h>
#include <unistd.h>

#elif __EMSCRIPTEN__

#include <SDL.h>
#include <SDL_image.h>
#include <SDL_ttf.h>
#include <emscripten.h>
#include <unistd.h>

#else

//#include <SDL/SDL_mixer.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_mixer.h>
#include <SDL2/SDL_ttf.h>
#include <unistd.h>

#endif
// needs extern because of linking

extern "C" {
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
};
#include <chrono>
#include <stdio.h>
#include <string>

#include "drawable.h"
#include "lua_helpers.h"
#include "lua_texture.h"
#include "lua_static.h"
#include "lua_sprites.h"
#include "map.h"
#include "sprite.h"
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

// set true to exit program at end of loop
extern bool quit;
// delay between this and the next frame
extern int framedelay;
#endif

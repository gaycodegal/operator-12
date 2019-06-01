#include "lua_static.h"

/**
   triggers shutdown on end of loop
 */
static int l_static_quit(lua_State *L) {
  quit = true;
  return 0;
}

/**
   Reads a file using SDL's internal read system

   Lua's read system only works on certain systems.
 */
static int l_static_readfile(lua_State *L) {
  char *name;
  if (!lua_isstring(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  name = (char *)lua_tostring(L, -1);
  lua_pop(L, 1);
  Sint64 size;
  char *s = fileRead(name, size);
  if (s == NULL) {
    return 0;
  }
  lua_pushlstring(L, s, (size_t)size);
  delete[] s;
  return 1;
}

/**
   pauses execution for some milliseconds immediately
 */
static int l_static_wait(lua_State *L) {
  int t;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  t = lua_tointeger(L, -1);
  lua_pop(L, 1);
  SDL_Delay(t);
  return 0;
}

/**
   sets time to delay after frame is complete
 */
static int l_static_framedelay(lua_State *L) {
  int t;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  t = lua_tointeger(L, -1);
  lua_pop(L, 1);
  framedelay = t;
  return 0;
}

/**
   Sets the global clip rect of the renderer
 */
static int l_static_setRenderClip(lua_State *L) {
  int x;
  int y;
  int w;
  int h;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  h = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  w = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  y = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  x = lua_tointeger(L, -1);
  lua_pop(L, 1);
  SDL_Rect rect;
  rect.x = x;
  rect.y = y;
  rect.w = w;
  rect.h = h;
  SDL_RenderSetClipRect(globalRenderer, &rect);
  return 0;
}

/**
   gets the global render clip rect
 */
static int l_static_getRenderClip(lua_State *L) {
  SDL_Rect rect;
  SDL_RenderGetClipRect(globalRenderer, &rect);
  lua_pushinteger(L, rect.x);
  lua_pushinteger(L, rect.y);
  lua_pushinteger(L, rect.w);
  lua_pushinteger(L, rect.h);
  return 4;
}

/**
   Sets the texture to be the render target
 */
static int l_static_setRenderTarget(lua_State *L) {
  SDL_Texture *texture;
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  texture = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_SetRenderTarget(globalRenderer, texture);
  return 0;
}

/**
   Sets the render target back to the screen
 */
static int l_static_unsetRenderTarget(lua_State *L) {
  SDL_SetRenderTarget(globalRenderer, NULL);
  return 0;
}

/**
   clears renderer
 */
static int l_static_renderClear(lua_State *L) {
  SDL_SetRenderDrawColor(globalRenderer, 0x00, 0x00, 0x00, 0x00);
  SDL_Rect rect;
  rect.x = 0;
  rect.y = 0;
  rect.w = SCREEN_WIDTH;
  rect.h = SCREEN_HEIGHT;
  SDL_RenderFillRect(globalRenderer, &rect);
  return 0;
}

/**
   Sets the render blend mode
 */
static int l_static_renderBlendmode(lua_State *L) {
  SDL_BlendMode mode;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  mode = static_cast<SDL_BlendMode>(static_cast<int>(lua_tonumber(L, -1)));
  lua_pop(L, 1);
  SDL_SetRenderDrawBlendMode(globalRenderer, mode);
  return 0;
}

const struct luaL_Reg static_meta[] = {
    {"quit", l_static_quit},
    {"wait", l_static_wait},
    {"readfile", l_static_readfile},
    {"framedelay", l_static_framedelay},
    {"setRenderClip", l_static_setRenderClip},
    {"getRenderClip", l_static_getRenderClip},
    {"setRenderTarget", l_static_setRenderTarget},
    {"unsetRenderTarget", l_static_unsetRenderTarget},
    {"renderClear", l_static_renderClear},
    {"renderBlendmode", l_static_renderBlendmode},
    {NULL, NULL}};

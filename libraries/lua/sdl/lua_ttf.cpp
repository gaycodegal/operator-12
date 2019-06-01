#include "lua_ttf.h"

/**
   creates a surface with text rendered to it
 */
static int l_ttf_surface(lua_State *L) {
  char *text;
  int r;
  int g;
  int b;
  int a;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 5);
    return 0;
  }
  a = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  b = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  g = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  r = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isstring(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  text = (char *)lua_tostring(L, -1);
  lua_pop(L, 1);
  SDL_Color c;
  c.r = r;
  c.b = b;
  c.g = g;
  c.a = a;
  SDL_Surface *textSurface = TTF_RenderText_Solid(gFont, text, c);
  lua_pushlightuserdata(L, (void *)textSurface);
  return 1;
}

/**
   gets the size required to render text
 */
static int l_ttf_size(lua_State *L) {
  char *text;
  if (!lua_isstring(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  text = (char *)lua_tostring(L, -1);
  lua_pop(L, 1);
  int w, h;
  if (TTF_SizeText(gFont, text, &w, &h) < 0) {
    printf("Error sizing font %s\n", TTF_GetError());
    return 0;
  }
  lua_pushnumber(L, w);
  lua_pushnumber(L, h);
  return 2;
}

const struct luaL_Reg ttf_meta[] = {
    {"surface", l_ttf_surface}, {"size", l_ttf_size}, {NULL, NULL}};

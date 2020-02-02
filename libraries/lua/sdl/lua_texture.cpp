#include "lua_texture.h"

/**
   Create a new texture

   @lua-meta
   @lua-name new
 */
static int l_texture_new(lua_State *L) {
  // printLuaStack(L, "new_tex");
  char *path;
  int w, h;
  if (!lua_isstring(L, -1)) {
    lua_pop(L, 1);
    lua_pushnil(L);
    return 1;
  }
  path = (char *)lua_tostring(L, -1);
  lua_pop(L, 1);
  lua_pushlightuserdata(L, (void *)loadTexture(path, w, h));
  lua_pushnumber(L, w);
  lua_pushnumber(L, h);
  return 3;
}

/**
   destroy a texture

   @lua-meta
   @lua-name destroy
*/
static int l_texture_destroy(lua_State *L) {
  SDL_Texture *tex;
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  tex = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_DestroyTexture(tex);
  return 0;
}

/**
   Creates a new texture that is capable of being a render target

   @lua-meta
   @lua-name newTarget
 */
static int l_texture_newTarget(lua_State *L) {
  int width;
  int height;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  height = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  width = lua_tointeger(L, -1);
  lua_pop(L, 1);

  Uint32 pixformat = SDL_PIXELFORMAT_RGBA8888;
  SDL_Texture *texture = SDL_CreateTexture(
      globalRenderer, pixformat, SDL_TEXTUREACCESS_TARGET, width, height);
  lua_pushlightuserdata(L, (void *)texture);
  return 1;
}

/**
   Sets the RGB mask of a texure

   @lua-meta
   @lua-name setRGBMask
 */
static int l_texture_setRGBMask(lua_State *L) {
  SDL_Texture *texture;
  Uint8 r;
  Uint8 g;
  Uint8 b;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  b = (Uint8)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  g = (Uint8)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  r = (Uint8)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  texture = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_SetTextureColorMod(texture, r, g, b);
  return 0;
}

/**
   Sets the alpha mask of a texture

   @lua-meta
   @lua-name setAMask
 */
static int l_texture_setAMask(lua_State *L) {
  SDL_Texture *texture;
  Uint8 a;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  a = (Uint8)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  texture = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  if (SDL_SetTextureAlphaMod(texture, a) < 0) {
    printf("Alpha Mod Err %s\n", SDL_GetError());
  }
  return 0;
}

/**
   Copies a texture onto the global renderer

   @lua-meta
   @lua-name renderCopy
 */
static int l_texture_renderCopy(lua_State *L) {
  SDL_Texture *texture;
  int sx;
  int sy;
  int sw;
  int sh;
  int dx;
  int dy;
  int dw;
  int dh;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 9);
    return 0;
  }
  dh = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 8);
    return 0;
  }
  dw = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 7);
    return 0;
  }
  dy = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 6);
    return 0;
  }
  dx = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 5);
    return 0;
  }
  sh = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  sw = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  sy = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  sx = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  texture = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_Rect dest;
  dest.x = dx;
  dest.y = dy;
  dest.w = dw;
  dest.h = dh;
  SDL_Rect source;
  source.x = sx;
  source.y = sy;
  source.w = sw;
  source.h = sh;
  SDL_RenderCopy(globalRenderer, texture, &source, &dest);
  return 0;
}

/**
   Sets the blend mode of a texture

   @lua-meta
   @lua-name blendmode
 */
static int l_texture_blendmode(lua_State *L) {
  SDL_Texture *texture;
  SDL_BlendMode mode;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  mode = static_cast<SDL_BlendMode>(static_cast<int>(lua_tonumber(L, -1)));
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  texture = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_SetTextureBlendMode(texture, mode);
  return 0;
}

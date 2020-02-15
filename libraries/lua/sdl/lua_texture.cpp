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
  SDL_Texture *tex = loadTexture(path, w, h);
  *reinterpret_cast<SDL_Texture **>(lua_newuserdata(L, sizeof(SDL_Texture *))) =
      tex;
  set_meta(L, -1, "Texture");
  lua_pushnumber(L, w);
  lua_pushnumber(L, h);
  return 3;
}

/**
   destroy a texture

   @lua-name destroy
   @lua-arg self: Delete SDL_Texture
*/
static void texture_destroy(SDL_Texture *self) { SDL_DestroyTexture(self); }

/**
   Creates a new texture that is capable of being a render target

   @lua-constructor
   @lua-name newTarget
   @lua-arg width: int
   @lua-arg height: int
   @lua-return Class SDL_Texture Texture
 */
static SDL_Texture *texture_newTarget(lua_Integer width, lua_Integer height) {
  Uint32 pixformat = SDL_PIXELFORMAT_RGBA8888;
  return SDL_CreateTexture(globalRenderer, pixformat, SDL_TEXTUREACCESS_TARGET,
                           width, height);
}

/**
   Sets the RGB mask of a texure

   @lua-name setRGBMask
   @lua-arg self: Class SDL_Texture
   @lua-arg r: int
   @lua-arg g: int
   @lua-arg b: int
 */
static void l_texture_setRGBMask(SDL_Texture *self, lua_Integer r,
                                 lua_Integer g, lua_Integer b) {
  SDL_SetTextureColorMod(self, r, g, b);
}

/**
   Sets the alpha mask of a texture

   @lua-name setAMask
   @lua-arg self: Class SDL_Texture
   @lua-arg a: int
 */
static void l_texture_setAMask(SDL_Texture *self, lua_Integer a) {
  if (SDL_SetTextureAlphaMod(self, a) < 0) {
    printf("Alpha Mod Err %s\n", SDL_GetError());
  }
}

/**
   Copies a texture onto the global renderer

   @lua-name renderCopy
   @lua-arg self: Class SDL_Texture
   @lua-arg sx: int
   @lua-arg sy: int
   @lua-arg sw: int
   @lua-arg sh: int
   @lua-arg dx: int
   @lua-arg dy: int
   @lua-arg dw: int
   @lua-arg dh: int
 */
static void l_texture_renderCopy(SDL_Texture *self, lua_Integer sx,
                                 lua_Integer sy, lua_Integer sw, lua_Integer sh,
                                 lua_Integer dx, lua_Integer dy, lua_Integer dw,
                                 lua_Integer dh) {
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
  SDL_RenderCopy(globalRenderer, self, &source, &dest);
}

/**
   Sets the blend mode of a texture

   @lua-name blendmode
   @lua-arg self: Class SDL_Texture
   @lua-arg mode: int
 */
static void l_texture_blendmode(SDL_Texture *self, lua_Integer mode) {
  SDL_BlendMode bmode = static_cast<SDL_BlendMode>(mode);
  SDL_SetTextureBlendMode(self, bmode);
}

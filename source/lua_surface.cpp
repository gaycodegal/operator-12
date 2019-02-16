#include "lua_surface.h"

/**
   creates new surface from image source
 */
static int l_surface_new(lua_State *L) {
  char *source;
  if (!lua_isstring(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  source = (char *)lua_tostring(L, -1);
  lua_pop(L, 1);
  SDL_Surface *loadedSurface = IMG_Load(source);
  if (loadedSurface == NULL) {
    printf("Unable to load image %s! SDL_image Error: %s\n", source,
           IMG_GetError());
    lua_pushnil(L);
  } else {
    lua_pushlightuserdata(L, (void *)loadedSurface);
  }
  return 1;
}

/**
   creates new blank surface
 */
static int l_surface_newBlank(lua_State *L) {
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
  Uint32 rmask, gmask, bmask, amask;

/* SDL interprets each pixel as a 32-bit number, so our masks must depend
       on the endianness (byte order) of the machine */
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
  rmask = 0xff000000;
  gmask = 0x00ff0000;
  bmask = 0x0000ff00;
  amask = 0x000000ff;
#else
  rmask = 0x000000ff;
  gmask = 0x0000ff00;
  bmask = 0x00ff0000;
  amask = 0xff000000;
#endif
  SDL_Surface *s =
      SDL_CreateRGBSurface(0, width, height, 32, rmask, gmask, bmask, amask);
  lua_pushlightuserdata(L, (void *)s);
  return 1;
}

/**
   sets a surface's blendmode
 */
static int l_surface_blendmode(lua_State *L) {
  SDL_Surface *surface;
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
  surface = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_SetSurfaceBlendMode(surface, mode);
  return 0;
}

/**
   Fill a rect portion of the surface
 */
static int l_surface_fill(lua_State *L) {
  SDL_Surface *surface;
  int x;
  int y;
  int width;
  int height;
  int r;
  int g;
  int b;
  int a;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 9);
    return 0;
  }
  a = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 8);
    return 0;
  }
  b = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 7);
    return 0;
  }
  g = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 6);
    return 0;
  }
  r = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 5);
    return 0;
  }
  height = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  width = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  y = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  x = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  surface = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_Rect rect;
  rect.x = x;
  rect.y = y;
  rect.w = width;
  rect.h = height;
  SDL_FillRect(surface, &rect, SDL_MapRGBA(surface->format, r, g, b, a));
  return 0;
}

/**
   Get the surface's dimensions
 */
static int l_surface_size(lua_State *L) {
  SDL_Surface *surface;
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  surface = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  lua_pushnumber(L, surface->w);
  lua_pushnumber(L, surface->h);
  return 2;
}

/**
   Blit one surcace onto another
 */
static int l_surface_blit(lua_State *L) {
  SDL_Surface *dst;
  SDL_Surface *src;
  int x;
  int y;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  y = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  x = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  src = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  dst = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_Rect stretchRect;
  stretchRect.x = x;
  stretchRect.y = y;
  stretchRect.w = src->w;
  stretchRect.h = src->h;
  if (SDL_BlitScaled(src, NULL, dst, &stretchRect) < 0) {
    printf("Unable to blit! SDL Error: %s\n", SDL_GetError());
  }
  return 0;
}

/**
   Create a texture from the surface
 */
static int l_surface_textureFrom(lua_State *L) {
  SDL_Surface *surface;
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  surface = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  // Create texture from surface pixels
  SDL_Texture *newTexture =
      SDL_CreateTextureFromSurface(globalRenderer, surface);
  if (newTexture == NULL) {
    printf("Unable to create texture from surface! SDL Error: %s\n",
           SDL_GetError());
    return 0;
  }
  lua_pushlightuserdata(L, (void *)newTexture);
  return 1;
}

/**
   blit the surface with full control over the rects
 */
static int l_surface_blitScale(lua_State *L) {
  SDL_Surface *dst;
  SDL_Surface *src;
  int sx;
  int sy;
  int sw;
  int sh;
  int dx;
  int dy;
  int dw;
  int dh;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 10);
    return 0;
  }
  dh = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 9);
    return 0;
  }
  dw = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 8);
    return 0;
  }
  dy = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 7);
    return 0;
  }
  dx = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 6);
    return 0;
  }
  sh = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 5);
    return 0;
  }
  sw = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  sy = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  sx = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  src = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  dst = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_Rect stretchRect;
  stretchRect.x = dx;
  stretchRect.y = dy;
  stretchRect.w = dw;
  stretchRect.h = dh;
  SDL_Rect sourceRect;
  sourceRect.x = sx;
  sourceRect.y = sy;
  sourceRect.w = sw;
  sourceRect.h = sh;
  if (SDL_BlitScaled(src, &sourceRect, dst, &stretchRect) < 0) {
    printf("Unable to blit! SDL Error: %s\n", SDL_GetError());
  }
  return 0;
}

/**
   destroy a surface
 */
static int l_surface_destroy(lua_State *L) {
  SDL_Surface *surface;
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  surface = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_FreeSurface(surface);
  return 0;
}

static const struct luaL_Reg surface_meta[] = {
    {"new", l_surface_new},
    {"newBlank", l_surface_newBlank},
    {"blendmode", l_surface_blendmode},
    {"fill", l_surface_fill},
    {"size", l_surface_size},
    {"blit", l_surface_blit},
    {"textureFrom", l_surface_textureFrom},
    {"blitScale", l_surface_blitScale},
    {"destroy", l_surface_destroy},
    {NULL, NULL}};

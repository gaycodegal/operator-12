#include "lua_surface.hh"

/**
   creates new surface from image source

   @lua-constructor
   @lua-name new
   @lua-arg source: string
   @lua-return Class SDL_Surface Surface
 */
static SDL_Surface *surface_new(const char *source) {
  SDL_Surface *loadedSurface = IMG_Load(source);
  if (loadedSurface == NULL) {
    printf("Unable to load image %s! SDL_image Error: %s\n", source,
           IMG_GetError());
  }
  return loadedSurface;
}

/**
   creates new blank surface

   @lua-constructor
   @lua-name newBlank
   @lua-arg width: int
   @lua-arg height: int
   @lua-return Class SDL_Surface Surface
 */
inline SDL_Surface *surface_newBlank(lua_Integer width, lua_Integer height) {
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
  return SDL_CreateRGBSurface(0, width, height, 32, rmask, gmask, bmask, amask);
}

/**
   sets a surface's blendmode

   @lua-name blendmode
   @lua-arg self: Class SDL_Surface
   @lua-arg mode: int
 */
static void surface_blendmode(SDL_Surface *self, lua_Integer mode) {
  SDL_SetSurfaceBlendMode(self, static_cast<SDL_BlendMode>(mode));
}

/**
   Fill a rect portion of the surface

   @lua-name fill
   @lua-arg self: Class SDL_Surface
   @lua-arg x: int
   @lua-arg y: int
   @lua-arg width: int
   @lua-arg height: int
   @lua-arg r: int
   @lua-arg g: int
   @lua-arg b: int
   @lua-arg a: int
 */
static void surface_fill(SDL_Surface *self, lua_Integer x, lua_Integer y,
                         lua_Integer width, lua_Integer height, lua_Integer r,
                         lua_Integer g, lua_Integer b, lua_Integer a) {
  SDL_Rect rect;
  rect.x = x;
  rect.y = y;
  rect.w = width;
  rect.h = height;
  SDL_FillRect(self, &rect, SDL_MapRGBA(self->format, r, g, b, a));
}

/**
   Get the surface's dimensions

   @lua-meta
   @lua-name size
 */
static int surface_size(lua_State *L) {
  SDL_Surface *surface;
  if (!lua_isuserdata(L, -1)) {
    return 0;
  }
  surface = *reinterpret_cast<SDL_Surface **>(lua_touserdata(L, -1));
  lua_pop(L, 1);

  if (surface == NULL) {
    return 0;
  }

  lua_pushinteger(L, surface->w);
  lua_pushinteger(L, surface->h);
  return 2;
}

/**
   Blit one surcace onto another

   @lua-name blit
   @lua-arg dst: Class SDL_Surface
   @lua-arg src: Class SDL_Surface
   @lua-arg x: int
   @lua-arg y: int
 */
static void surface_blit(SDL_Surface *dst, SDL_Surface *src, lua_Integer x,
                         lua_Integer y) {
  SDL_Rect stretchRect;
  stretchRect.x = x;
  stretchRect.y = y;
  stretchRect.w = src->w;
  stretchRect.h = src->h;
  if (SDL_BlitScaled(src, NULL, dst, &stretchRect) < 0) {
    printf("Unable to blit! SDL Error: %s\n", SDL_GetError());
  }
}

/**
   Create a texture from the surface

   @lua-name textureFrom
   @lua-arg self: Class SDL_Surface
   @lua-return Class SDL_Texture Texture
 */
static SDL_Texture *surface_textureFrom(SDL_Surface *self) {
  // Create texture from surface pixels
  SDL_Texture *newTexture = SDL_CreateTextureFromSurface(globalRenderer, self);
  if (newTexture == NULL) {
    printf("Unable to create texture from surface! SDL Error: %s\n",
           SDL_GetError());
  }
  return newTexture;
}

/**
   blit the surface with full control over the rects

   @lua-name blitScale
   @lua-arg dst: Class SDL_Surface
   @lua-arg src: Class SDL_Surface
   @lua-arg sx: int
   @lua-arg sy: int
   @lua-arg sw: int
   @lua-arg sh: int
   @lua-arg dx: int
   @lua-arg dy: int
   @lua-arg dw: int
   @lua-arg dh: int
 */
static void l_surface_blitScale(SDL_Surface *dst, SDL_Surface *src,
                                lua_Integer sx, lua_Integer sy, lua_Integer sw,
                                lua_Integer sh, lua_Integer dx, lua_Integer dy,
                                lua_Integer dw, lua_Integer dh) {
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
}

/**
   destroy a surface

   @lua-name destroy
   @lua-arg self: Delete SDL_Surface
 */
inline void surface_destroy(SDL_Surface *self) { SDL_FreeSurface(self); }

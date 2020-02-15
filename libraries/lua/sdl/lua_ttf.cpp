#include "lua_ttf.h"

/**
   creates a surface with text rendered to it

   @lua-name surface
   @lua-arg text: string
   @lua-arg r: int
   @lua-arg g: int
   @lua-arg b: int
   @lua-arg a: int
   @lua-return Class SDL_Surface Surface
*/
static SDL_Surface *ttf_surface(const char *text, int r, int g, int b, int a) {
  SDL_Color c;
  c.r = r;
  c.b = b;
  c.g = g;
  c.a = a;
  return TTF_RenderText_Solid(gFont, text, c);
}

/**
   gets the size required to render text

   @lua-meta
   @lua-name size
 */
static int ttf_size(lua_State *L) {
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

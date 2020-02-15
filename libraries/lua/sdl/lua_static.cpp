#include "lua_static.h"

/**
   triggers shutdown on end of loop

   @lua-name quit
 */
static void l_static_quit() { quit = true; }

/**
   Reads a file using SDL's internal read system

   Lua's read system only works on certain systems.

   @lua-meta
   @lua-name readfile
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

   @lua-name wait
   @lua-arg millis: int
 */
static void l_static_wait(lua_Integer millis) { SDL_Delay(millis); }

/**
   sets time to delay after frame is complete

   @lua-name framedelay
   @lua-arg millis: int
 */
static void l_static_framedelay(lua_Integer millis) { framedelay = millis; }

/**
   Sets the global clip rect of the renderer

   @lua-name setRenderClip
   @lua-arg x: int
   @lua-arg y: int
   @lua-arg w: int
   @lua-arg h: int
 */
static void l_static_setRenderClip(lua_Integer x, lua_Integer y, lua_Integer w,
                                   lua_Integer h) {
  SDL_Rect rect;
  rect.x = x;
  rect.y = y;
  rect.w = w;
  rect.h = h;
  SDL_RenderSetClipRect(globalRenderer, &rect);
}

/**
   gets the global render clip rect

   @lua-meta
   @lua-name getRenderClip
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

   @lua-name setRenderTarget
   @lua-arg texture: Class SDL_Texture
 */
static void l_static_setRenderTarget(SDL_Texture *texture) {
  SDL_SetRenderTarget(globalRenderer, texture);
}

/**
   Sets the render target back to the screen

   @lua-name unsetRenderTarget
 */
static void l_static_unsetRenderTarget() {
  SDL_SetRenderTarget(globalRenderer, NULL);
}

/**
   clears renderer

   @lua-name renderClear
 */
static void l_static_renderClear() {
  SDL_SetRenderDrawColor(globalRenderer, 0x00, 0x00, 0x00, 0x00);
  SDL_Rect rect;
  rect.x = 0;
  rect.y = 0;
  rect.w = SCREEN_WIDTH;
  rect.h = SCREEN_HEIGHT;
  SDL_RenderFillRect(globalRenderer, &rect);
}

/**
   Sets the render blend mode

   @lua-name renderBlendmode
   @lua-arg mode: int
 */
static void l_static_renderBlendmode(lua_Integer mode) {
  SDL_BlendMode bmode = static_cast<SDL_BlendMode>(mode);
  SDL_SetRenderDrawBlendMode(globalRenderer, bmode);
}

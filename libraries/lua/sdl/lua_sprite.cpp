#include "lua_sprite.h"

/**
   creates new surface from image source

   @lua-constructor
   @lua-name new
   @lua-arg tex: Class SDL_Texture
   @lua-arg x: int
   @lua-arg y: int
   @lua-arg w: int
   @lua-arg h: int
   @lua-arg sx: int
   @lua-arg sy: int
   @lua-return Class Sprite
 */
static Sprite* new_sprite(SDL_Texture* tex, lua_Integer x, lua_Integer y, lua_Integer w, lua_Integer h, lua_Integer sx, lua_Integer sy) {
  Sprite* s = new Sprite();
  s->init(tex, x, y, w, h, sx, sy);
  return s;
}

/**
   draw a sprite

   @lua-name draw
   @lua-arg self: Class Sprite
   @lua-arg x: int
   @lua-arg y: int
 */
static int l_draw_sprite(Sprite* self, lua_Integer x, lua_Integer y) {
  self->draw(x, y);
}

/**
   free a sprite

   @lua-name destroy
   @lua-arg self: Delete Sprite
 */
static int l_free_sprite(Sprite* self) {
  delete self;
}

/**
   move a sprite

   @lua-name move
   @lua-arg self: Class Sprite
   @lua-arg x: int
   @lua-arg y: int
 */
static void l_move_sprite(Sprite* self, lua_Integer x, lua_Integer y) {
  self->move(x, y);
}

/**
   get a sprite's size

   @lua-meta
   @lua-name size
 */
static int l_size_sprite(lua_State *L) {
  // printLuaStack(L, "size_sprite");
  int w, h;
  Sprite *s;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  h = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  w = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  s = *reinterpret_cast<Sprite **>(lua_touserdata(L, -1));
  if (s == NULL) {
    return 0;
  }
  lua_pop(L, 1);
  s->size(w, h);
  return 1;
}

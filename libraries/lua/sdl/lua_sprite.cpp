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
   set a sprite's size

   @lua-name size
   @lua-arg self: Class Sprite
   @lua-arg w: int
   @lua-arg h: int
 */
static void l_size_sprite(Sprite* self, lua_Integer w, lua_Integer h) {
  // printLuaStack(L, "size_sprite");
  self->size(w, h);
}

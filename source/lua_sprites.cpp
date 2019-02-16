#include "lua_sprites.h"

static int l_draw_sprite(lua_State *L) {
  Sprite *s;
  int x, y;
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

  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  s = *(Sprite **)lua_touserdata(L, -1);
  lua_pop(L, 1);
  s->draw(x, y);
  return 0;
}

static int l_free_sprite(lua_State *L) {
  Sprite *s;
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  s = *(Sprite **)lua_touserdata(L, -1);
  lua_pop(L, 1);
  delete s;
  return 0;
}

static int l_move_sprite(lua_State *L) {
  // printLuaStack(L, "move_sprite");
  int x, y;
  Sprite *s;
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
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  s = *reinterpret_cast<Sprite **>(lua_touserdata(L, -1));
  lua_pop(L, 1);
  s->move(x, y);
  return 0;
}

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
  lua_pop(L, 1);
  s->size(w, h);
  return 1;
}

static int l_new_sprite(lua_State *L) {
  // printLuaStack(L, "new_sprite");
  int x, y, w, h, sx, sy;
  SDL_Texture *tex;
  Sprite *s;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 7);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  sy = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 6);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  sx = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 5);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  h = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  w = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  y = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }

  x = lua_tointeger(L, -1);
  lua_pop(L, 1);

  // printf("here %s\n", lua_typename(L, lua_type(L, -1)));
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }

  // printf("(x %i, y %i, w %i, h %i) sx %i, sy%i\n", x,y,w,h,sx,sy);
  tex = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  s = new Sprite();
  *reinterpret_cast<Sprite **>(lua_newuserdata(L, sizeof(Sprite *))) = s;

  s->init(tex, x, y, w, h, sx, sy);
  /*for(int l = 0; l < sizeof(Sprite); l++){
    printf("c: %i/%ld v: %i\n", l, sizeof(Sprite), *(c++));
    }*/
  // s->draw();
  set_meta(L, -1, "Sprite");
  return 1;
}

const struct luaL_Reg spritemeta[] = {{"new", l_new_sprite},
                                             {"draw", l_draw_sprite},
                                             {"destroy", l_free_sprite},
                                             {"move", l_move_sprite},
                                             {"size", l_size_sprite},
                                             {"__index", l_meta_indexer},
                                             {NULL, NULL}};

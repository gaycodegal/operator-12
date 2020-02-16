#include "lua_map.hh"

static int l_map_new(lua_State *L) {
  if (!lua_istable(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }

  TiledMap *map = new TiledMap(L);
  *reinterpret_cast<TiledMap **>(lua_newuserdata(L, sizeof(TiledMap *))) = map;
  set_meta(L, -1, "TiledMap");
  return 1;
}

static int l_map_destroy(lua_State *L) {
  TiledMap *self;
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  self = *(TiledMap **)lua_touserdata(L, -1);
  lua_pop(L, 1);
  delete self;
  return 0;
}

static int l_map_move(lua_State *L) {
  TiledMap *self;
  int x;
  int y;
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
  self = *(TiledMap **)lua_touserdata(L, -1);
  lua_pop(L, 1);

  self->move(x, y);
  return 0;
}

static int l_map_draw(lua_State *L) {
  TiledMap *self;
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  self = *(TiledMap **)lua_touserdata(L, -1);
  lua_pop(L, 1);

  self->draw(0, 0);
  return 0;
}

static const struct luaL_Reg map_meta[] = {{"new", l_map_new},
                                           {"destroy", l_map_destroy},
                                           {"move", l_map_move},
                                           {"draw", l_map_draw},
                                           {NULL, NULL}};

static const struct luaClassList game[] = {{"TiledMap", map_meta},
                                           {NULL, NULL}};

int luaopen_map(lua_State *L) {
  struct luaClassList *ptr = (struct luaClassList *)game;
  while (ptr->name != NULL) {
    lua_newtable(L);
    luaL_setfuncs(L, ptr->meta, 0);
    lua_setfield(L, -2, ptr->name);
    ++ptr;
  }
  return 1;
}

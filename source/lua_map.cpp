#include "main.hpp"

static int l_map_new(lua_State *L) {
  if (!lua_istable(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }

  lua_pop(L, 1);

  TiledMap *map = new TiledMap(L);
  *reinterpret_cast<TiledMap **>(lua_newuserdata(L, sizeof(TiledMap *))) = map;
  set_meta(L, -1, "TiledMap");
  return 1;
}
static const struct luaL_Reg map_meta[] = {{"new", l_map_new}, {NULL, NULL}};

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

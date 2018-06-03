#include "lua_sprites.hpp"

static int l_free_texture(lua_State *L) {
  SDL_Texture *tex;
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  tex = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_DestroyTexture(tex);
  return 0;
}

static int l_draw_sprite(lua_State *L) {
  Sprite *s;
  int x, y;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  y = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);

  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  x = (int)lua_tonumber(L, -1);
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

static int l_new_texture(lua_State *L) {
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
  lua_pushlightuserdata(L, (void *)loadTexture(path, w, h));
  lua_pushnumber(L, w);
  lua_pushnumber(L, h);
  return 3;
}

static int l_static_wait(lua_State *L) {
  // printLuaStack(L, "static_wait");
  int t;
  Sprite *s;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  t = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  SDL_Delay(t);
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
  y = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  x = (int)lua_tonumber(L, -1);
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
  h = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  w = (int)lua_tonumber(L, -1);
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

static int l_quit(lua_State *L) {
  quit = true;
  return 0;
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
  sy = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 6);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  sx = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 5);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  h = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  w = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  y = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }

  x = (int)lua_tonumber(L, -1);
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

static const struct luaL_Reg spritemeta[] = {{"new", l_new_sprite},
                                             {"draw", l_draw_sprite},
                                             {"destroy", l_free_sprite},
                                             {"move", l_move_sprite},
                                             {"size", l_size_sprite},
                                             {"__index", l_meta_indexer},
                                             {NULL, NULL}};

static const struct luaL_Reg texturemeta[] = {
    {"new", l_new_texture}, {"destroy", l_free_texture}, {NULL, NULL}};

static const struct luaL_Reg staticmeta[] = {
    {"wait", l_static_wait}, {"quit", l_quit}, {NULL, NULL}};

static const struct luaClassList game[] = {{"Texture", texturemeta},
                                           {"Sprite", spritemeta},
                                           {"static", staticmeta},
                                           {NULL, NULL}};

struct luaConstInt {
  const char *name;
  const int val;
};

static const struct luaConstInt globints[] = {{"SCREEN_WIDTH", SCREEN_WIDTH},
                                              {"SCREEN_HEIGHT", SCREEN_HEIGHT},
                                              {"KEY_UP", SDLK_UP},
                                              {"KEY_DOWN", SDLK_DOWN},
                                              {"KEY_LEFT", SDLK_LEFT},
                                              {"KEY_RIGHT", SDLK_RIGHT},
                                              {"KEY_ESCAPE", SDLK_ESCAPE},
                                              {NULL, 0}};

int luaopen_sprites(lua_State *L) {
  int count = 0;
  lua_newtable(L);
  struct luaClassList *ptr = (struct luaClassList *)game;
  while (ptr->name != NULL) {
    ++count;
    lua_newtable(L);
    luaL_setfuncs(L, ptr->meta, 0);
    lua_setfield(L, -2, ptr->name);
    ++ptr;
  }
  struct luaConstInt *pint = (struct luaConstInt *)globints;
  while (pint->name != NULL) {
    lua_pushnumber(L, pint->val);
    lua_setfield(L, -2, pint->name);
    ++pint;
  }
  return 1;
}

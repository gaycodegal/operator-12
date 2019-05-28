#include "lua_helpers.h"

int getLen(lua_State *L, int i) {
  lua_len(L, i);
  int result = lua_tointeger(L, -1);
  lua_pop(L, 1);
  return result;
}

void getTable(lua_State *L, const char *named) {
  lua_pushstring(L, named);
  lua_gettable(L, -2);
}

void getTableAtIndex(lua_State *L, int i) {
  lua_pushinteger(L, i);
  lua_gettable(L, -2);
}

int getInt(lua_State *L, const char *named) {
  lua_pushstring(L, named);
  lua_gettable(L, -2);
  int result = lua_tointeger(L, -1);
  lua_pop(L, 1);
  return result;
}

std::string getString(lua_State *L, const char *named) {
  lua_pushstring(L, named);
  lua_gettable(L, -2);
  std::string result = std::string(lua_tostring(L, -1));
  lua_pop(L, 1);
  return result;
}

void set_meta(lua_State *L, int ind, const char *name) {
  lua_getglobal(L, "Game");
  lua_getfield(L, -1, name);
  lua_setmetatable(L, ind - 2);
  lua_pop(L, 1);
}

void printLuaStack(lua_State *L, const char *name) {
  int args = lua_gettop(L);
  size_t s;
  printf("top at(%s): %i\n", name, args);
  for (int i = 0; i < args; ++i) {
    printf("arg %i %s\n", i, luaL_tolstring(L, -args + i, &s));
    lua_pop(L, 1);
  }
}

int l_meta_indexer(lua_State *L) {
  // printLuaStack(L, "meta_index");
  lua_getmetatable(L, -2);
  // table
  // str
  // meta
  lua_replace(L, -3);
  // meta
  // str
  lua_gettable(L, -2);
  // meta
  // val
  lua_replace(L, -2);
  // val
  return 1;
}

void callLuaVoid(lua_State *L, const char *name) {
  lua_getglobal(L, name); /* function to be called */
  if (lua_pcall(L, 0, 0, 0) != 0)
    printf("we messed up calling:%s error:%s\n", name, lua_tostring(L, -1));
}

void callLuaVoidArgv(lua_State *L, const char *name, int argc, char **argv) {
  lua_getglobal(L, name); /* function to be called */
  lua_pushnumber(L, argc);
  lua_createtable(L, argc, 0);
  for (int i = 0; i < argc; ++i) {
    lua_pushstring(L, argv[i]);
    lua_rawseti(L, -2, i + 1);
  }
  if (lua_pcall(L, 2, 0, 0) != 0)
    printf("we messed up calling:%s error:%s\n", name, lua_tostring(L, -1));
}

void callErr(lua_State *L, const char *name, int nargs) {
  if (lua_pcall(L, nargs, 0, 0) != 0)
    printf("we messed up calling:%s error:%s\n", name, lua_tostring(L, -1));
}

int globalTypeExists(lua_State *L, int type, const char *name) {
  int toptype;
  lua_getglobal(L, name);
  toptype = lua_type(L, -1);
  lua_pop(L, 1);
  return toptype == type;
}

char *fileRead(const char *fname, Sint64 &size) {
  SDL_RWops *io = SDL_RWFromFile(fname, "rb");
  if (io == NULL) {
    printf("No such file %s\n", fname);
    return NULL;
  }
  size = SDL_RWsize(io);
  if (size == -1) {
    SDL_RWclose(io);
    return NULL;
  }
  char *c = new char[size + 1];
  SDL_RWread(io, c, size, 1);
  SDL_RWclose(io);
  c[size] = 0;
  return c;
}

int loadLuaFile(lua_State *L, const char *fname, int nresults) {
  Sint64 s;
  char *file = fileRead(fname, s);
  if (file == NULL) {
    return 0;
  }
  if (luaL_loadstring(L, file)) {
    printf("failed to load %s with error:%s\n", fname, lua_tostring(L, -1));
    delete[] file;
    return 0;
  }
  delete[] file;
  if (lua_pcall(L, 0, nresults, 0)) {
    /* PRIMING RUN. FORGET THIS AND YOU'RE TOAST */
    printf("failed to call %s with error:%s\n", fname, lua_tostring(L, -1));
    return 0;
  }
  return 1;
}

struct luaConstInt {
  const char *name;
  const int val;
};

int luaopen_gamelibs(lua_State *L) {
  static const struct luaClassList game[] = {
#ifndef NO_MUSIC
      {"Music", music_meta},
#endif
      {"Texture", texture_meta}, {"Sprite", spritemeta},
      {"static", static_meta},   {"Surface", surface_meta},
      {"TTF", ttf_meta},         {NULL, NULL}};

  static const struct luaConstInt globints[] = {
      {"SCREEN_WIDTH", SCREEN_WIDTH},
      {"SCREEN_HEIGHT", SCREEN_HEIGHT},
      {"KEY_UP", SDLK_UP},
      {"KEY_DOWN", SDLK_DOWN},
      {"KEY_LEFT", SDLK_LEFT},
      {"KEY_RIGHT", SDLK_RIGHT},
      {"KEY_ESCAPE", SDLK_ESCAPE},
      {"KEY_a", SDLK_a},
      {"KEY_b", SDLK_b},
      {"KEY_c", SDLK_c},
      {"KEY_d", SDLK_d},
      {"KEY_e", SDLK_e},
      {"KEY_f", SDLK_f},
      {"KEY_g", SDLK_g},
      {"KEY_h", SDLK_h},
      {"KEY_i", SDLK_i},
      {"KEY_j", SDLK_j},
      {"KEY_k", SDLK_k},
      {"KEY_l", SDLK_l},
      {"KEY_m", SDLK_m},
      {"KEY_n", SDLK_n},
      {"KEY_o", SDLK_o},
      {"KEY_p", SDLK_p},
      {"KEY_q", SDLK_q},
      {"KEY_r", SDLK_r},
      {"KEY_s", SDLK_s},
      {"KEY_t", SDLK_t},
      {"KEY_u", SDLK_u},
      {"KEY_v", SDLK_v},
      {"KEY_w", SDLK_w},
      {"KEY_x", SDLK_x},
      {"KEY_y", SDLK_y},
      {"KEY_z", SDLK_z},
      {"KEY_0", SDLK_0},
      {"KEY_1", SDLK_1},
      {"KEY_2", SDLK_2},
      {"KEY_3", SDLK_3},
      {"KEY_4", SDLK_4},
      {"KEY_5", SDLK_5},
      {"KEY_6", SDLK_6},
      {"KEY_7", SDLK_7},
      {"KEY_8", SDLK_8},
      {"KEY_9", SDLK_9},
      {"KEY_QUOTE", SDLK_QUOTE},
      {"KEY_QUOTEDBL", SDLK_QUOTEDBL},
      {"KEY_SLASH", SDLK_SLASH},
      {"KEY_BACKSLASH", SDLK_BACKSLASH},
      {"KEY_COMMA", SDLK_COMMA},
      {"KEY_PERIOD", SDLK_PERIOD},
      {"KEY_EQUALS", SDLK_EQUALS},
      {"KEY_SEMICOLON", SDLK_SEMICOLON},
      {"KEY_COLON", SDLK_COLON},
      {"KEY_BACKSPACE", SDLK_BACKSPACE},
      {"KEY_QUESTION", SDLK_QUESTION},
      {"KEY_GREATER", SDLK_GREATER},
      {"KEY_LESS", SDLK_LESS},
      {"KEY_RIGHTPAREN", SDLK_RIGHTPAREN},
      {"KEY_LEFTPAREN", SDLK_LEFTPAREN},
      {"KEY_UNDERSCORE", SDLK_UNDERSCORE},
      {"KEY_PERCENT", SDLK_PERCENT},
      {"KEY_MINUS", SDLK_MINUS},
      {"KEY_PLUS", SDLK_PLUS},
      {"KEY_HASH", SDLK_HASH},
      {"KEY_EXCLAIM", SDLK_EXCLAIM},
      {"KEY_AT", SDLK_AT},
      {"KEY_CARET", SDLK_CARET},
      {"KEY_AMPERSAND", SDLK_AMPERSAND},
      {"KEY_ASTERISK", SDLK_ASTERISK},
      {"KEY_LEFTBRACE", SDLK_KP_LEFTBRACE},
      {"KEY_RIGHTBRACE", SDLK_KP_RIGHTBRACE},
      {"KEY_RIGHTBRACKET", SDLK_RIGHTBRACKET},
      {"KEY_LEFTBRACKET", SDLK_LEFTBRACKET},
      {"KEY_RALT", SDLK_RALT},
      {"KEY_LALT", SDLK_LALT},
      {"KEY_LCTRL", SDLK_LCTRL},
      {"KEY_RCTRL", SDLK_RCTRL},
      {"KEY_RSHIFT", SDLK_RSHIFT},
      {"KEY_LSHIFT", SDLK_LSHIFT},
      {"KEY_TICK", SDLK_BACKQUOTE},
      {"KEY_ENTER", SDLK_RETURN},
      {"KEY_ENTER2", SDLK_RETURN2},
      {"KEY_SPACE", SDLK_SPACE},
      {"BLENDMODE_NONE", SDL_BLENDMODE_NONE},
      {"BLENDMODE_BLEND", SDL_BLENDMODE_BLEND},
      {"BLENDMODE_ADD", SDL_BLENDMODE_ADD},
      {"BLENDMODE_MOD", SDL_BLENDMODE_MOD},
      {NULL, 0}};

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

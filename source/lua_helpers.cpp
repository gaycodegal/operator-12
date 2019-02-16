#include "lua_helpers.h"

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

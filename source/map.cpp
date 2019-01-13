#include "map.hpp"

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

TiledTexture::TiledTexture(lua_State *L) {
  imageName = getString(L, "image");
  tileWidth = getInt(L, "tilewidth");
  tileHeight = getInt(L, "tileheight");
  cols = getInt(L, "columns");
  imageWidth = getInt(L, "imagewidth");
  imageHeight = getInt(L, "imageheight");
  count = getInt(L, "tilecount");

  //
}

TiledTexture::~TiledTexture() {}

TiledMap::TiledMap(lua_State *L) {
  getTable(L, "tilesets");
  nTilesets = getLen(L, -1);
  tilesets = new TiledTexture *[nTilesets];
  for (int i = 0; i < nTilesets; ++i) {
    getTableAtIndex(L, i);
    tilesets[i] = new TiledTexture(L);
    lua_pop(L, 1);
  }
  lua_pop(L, 1);
}

TiledMap::~TiledMap() {
  for (int i = 0; i < nTilesets; ++i) {
    delete tilesets[i];
  }
  delete[] tilesets;
}

void TiledMap::draw(int x, int y) {}

void TiledMap::move(int x, int y) {
  this->x += x;
  this->y += y;
}

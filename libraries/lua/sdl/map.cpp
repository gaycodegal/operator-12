#include "map.h"

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
}

TiledTexture::~TiledTexture() {}

TiledMap::TiledMap(lua_State *L) {
  // Init Props
  tileWidth = getInt(L, "tilewidth");
  tileHeight = getInt(L, "tileheight");
  width = getInt(L, "width");
  height = getInt(L, "height");

  // Init tilesets
  getTable(L, "tilesets");
  nTilesets = getLen(L, -1);
  tilesets = new TiledTexture *[nTilesets];
  for (int i = 0; i < nTilesets; ++i) {
    getTableAtIndex(L, i + 1);
    tilesets[i] = new TiledTexture(L);
    lua_pop(L, 1);
  }
  lua_pop(L, 1);

  // Init array
  int nTiles = width * height;
  tiles = new int[width * height];

  getTable(L, "layers");
  getTableAtIndex(L, 1);
  getTable(L, "data");

  for (int i = 0; i < nTiles; ++i) {
    lua_rawgeti(L, -1, i + 1);
    tiles[i] = lua_tointeger(L, -1);
    lua_pop(L, 1);
  }

  lua_pop(L, 3);
}

int TiledMap::drawTile(int x, int y, int tx, int ty) {
  //int tile = getTile(x, y);
  return 0;
}

int TiledMap::getTile(int x, int y) { return tiles[toIndex(x, y)]; }

int TiledMap::positionValid(int x, int y) {
  return x > 0 && x < width && y > 0 && y < height;
}

int TiledMap::toIndex(int x, int y) { return x + y * width; }

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

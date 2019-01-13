#ifndef _MAP_HPP_
#define _MAP_HPP_
#include "main.hpp"

class TiledTexture {
private:
  std::string imageName;
  SDL_Texture *texture;
  int tileWidth;
  int tileHeight;
  int imageWidth;
  int imageHeight;
  int count;
  int cols;

public:
  TiledTexture(lua_State *L);
  ~TiledTexture();
  void draw(int n, int x, int y);
  int getCount();
};

class TiledMap : public Drawable {
private:
  SDL_Texture *texture;
  int nTilesets;
  TiledTexture **tilesets;

  int x, y;

public:
  TiledMap(lua_State *L);
  ~TiledMap();
  void draw(int x, int y);
  void move(int x, int y);
};

#endif

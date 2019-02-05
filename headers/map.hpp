#ifndef _MAP_HPP_
#define _MAP_HPP_
#include "main.hpp"

class TiledTexture {
private:
  std::string imageName;
  SDL_Texture *texture;
  int tileWidth, tileHeight;
  int imageWidth, imageHeight;
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
  int tileWidth, tileHeight;
  int width, height;

  int *tiles;
public:
  TiledMap(lua_State *L);
  ~TiledMap();

  void draw(int x, int y);
  void move(int x, int y);

  int drawTile(int x, int y, int tx, int ty);
  int getTile(int x, int y);
  int positionValid(int x, int y);
  int toIndex(int x, int y);
};

#endif

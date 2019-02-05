#ifndef _SPRITE_HPP_
#define _SPRITE_HPP_
#include "main.hpp"
SDL_Texture *loadTexture(const char *path, int &w, int &h);

/**
   The a sprite that contains all info necessary to draw itself
 */
class Sprite : public Drawable {
private:
  SDL_Rect dest;
  SDL_Rect source;
  SDL_Texture *texture;

public:
  void init(SDL_Texture *tex, int x, int y, int w, int h, int sx, int sy);
  void size(int w, int h);
  void move(int x, int y);
  void draw(int x, int y);
};

#endif

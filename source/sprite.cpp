#include "sprite.h"

SDL_Texture *loadTexture(const char *path, int &w, int &h) {
  // The final texture
  SDL_Texture *newTexture = NULL;

  // Load image at specified path
  SDL_Surface *loadedSurface = IMG_Load(path);
  // printf("size %i, %i\n", , );
  w = loadedSurface->w;
  h = loadedSurface->h;

  if (loadedSurface == NULL) {
    printf("Unable to load image %s! SDL_image Error: %s\n", path,
           IMG_GetError());
  } else {
    // Create texture from surface pixels
    newTexture = SDL_CreateTextureFromSurface(globalRenderer, loadedSurface);
    if (newTexture == NULL) {
      printf("Unable to create texture from %s! SDL Error: %s\n", path,
             SDL_GetError());
    }

    // Get rid of old loaded surface
    SDL_FreeSurface(loadedSurface);
  }

  return newTexture;
}

void Sprite::move(int x, int y) {
  this->dest.x = x;
  this->dest.y = y;
}

void Sprite::size(int w, int h) {
  this->dest.w = w;
  this->dest.h = h;
}

void Sprite::init(SDL_Texture *tex, int x, int y, int w, int h, int sx,
                  int sy) {
  texture = tex;
  this->dest.x = x;
  this->dest.y = y;
  this->dest.w = w;
  this->dest.h = h;

  this->source.x = sx;
  this->source.y = sy;
  this->source.w = w;
  this->source.h = h;
}

void Sprite::draw(int x, int y) {
  int ox = this->dest.x, oy = this->dest.y;
  this->dest.x += x;
  this->dest.y += y;
  SDL_RenderCopy(globalRenderer, texture, &source, &dest);
  this->dest.x = ox;
  this->dest.y = oy;
}

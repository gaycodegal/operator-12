#include "sprite.hpp"
SDL_Texture* loadTexture( const char *path )
{
  //The final texture
  SDL_Texture* newTexture = NULL;

  //Load image at specified path
  SDL_Surface* loadedSurface = IMG_Load( path );
  if( loadedSurface == NULL )
    {
      printf( "Unable to load image %s! SDL_image Error: %s\n", path, IMG_GetError() );
    }
  else
    {
      //Create texture from surface pixels
      newTexture = SDL_CreateTextureFromSurface( globalRenderer, loadedSurface );
      if( newTexture == NULL )
	{
	  printf( "Unable to create texture from %s! SDL Error: %s\n", path, SDL_GetError() );
	}

      //Get rid of old loaded surface
      SDL_FreeSurface( loadedSurface );
    }

  return newTexture;
}

void Sprite::move(int x, int y){
  this->dest.x = x;
  this->dest.y = y;
}

void Sprite::size(int w, int h){
  this->dest.w = w;
  this->dest.h = h;
}

void Sprite::init(SDL_Texture *tex, int x, int y, int w, int h){
  texture = tex;
  this->dest.x = x;
  this->dest.y = y;
  this->dest.w = w;
  this->dest.h = h;
  
  this->source.x = 0;
  this->source.y = 0;
  this->source.w = w;
  this->source.h = h;
}

void Sprite::draw(){
  SDL_RenderCopy( globalRenderer, texture, &source, &dest );
}

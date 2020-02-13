#include "lua_screen.h"

int screen_data[128 * 128];
Uint32 colors[16];
SDL_Surface *bitsSurface;

void initBits() {
  bitsSurface = surface_newBlank(128, 128);
  //make pink
  SDL_Rect rect;
  rect.x = 0;
  rect.y = 0;
  rect.w = bitsSurface->w;
  rect.h = bitsSurface->h;
  SDL_FillRect(bitsSurface, &rect, SDL_MapRGBA(bitsSurface->format, 255, 128, 128, 255));

  colors[0] = make_pixel(0, 0, 0);
  colors[1] = make_pixel(29, 43, 83);
  colors[2] = make_pixel(126, 37, 83);
  colors[3] = make_pixel(0, 135, 81);
  colors[4] = make_pixel(171, 82, 54);
  colors[5] = make_pixel(95, 87, 79);
  colors[6] = make_pixel(194, 195, 199);
  colors[7] = make_pixel(255, 241, 232);
  colors[8] = make_pixel(255, 0, 77);
  colors[9] = make_pixel(255, 163, 0);
  colors[10] = make_pixel(255, 236, 39);
  colors[11] = make_pixel(0, 228, 54);
  colors[12] = make_pixel(41, 173, 255);
  colors[13] = make_pixel(41, 173, 255);
  colors[14] = make_pixel(255, 119, 168);
  colors[15] = make_pixel(255, 204, 170);
  set_pixel(bitsSurface, 5, 5, colors[14]);
}

Uint32 make_pixel(Uint8 r, Uint8 g, Uint8 b) {
  Uint32 pixel = 0;
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
    pixel |= r << 24;
    pixel |= g << 16;      
    pixel |= b << 8;
    pixel |= 0xFF;
#else
    pixel |= b << 16;
    pixel |= g << 8;      
    pixel |= r;
    pixel |= 0xFF000000;
#endif
  return pixel;
}

void set_pixel(SDL_Surface *surface, int x, int y, Uint32 pixel) {
  int bpp = surface->format->BytesPerPixel;
  /* Here p is the address to the pixel we want to set */
  Uint8 *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bpp;
  
  switch(bpp) {
  case 1:
    *p = pixel;
    break;
  case 2:
    *(Uint16 *)p = pixel;
    break;
  case 3:
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
    p[0] = (pixel >> 16) & 0xff;
    p[1] = (pixel >> 8) & 0xff;
    p[2] = pixel & 0xff;
#else
    p[0] = pixel & 0xff;
    p[1] = (pixel >> 8) & 0xff;
    p[2] = (pixel >> 16) & 0xff;
#endif
    break;
  case 4:
    *(Uint32 *)p = pixel;
    break;
  }
}

void destroyBits() {
  surface_destroy(bitsSurface);
}

/**
   @lua-name flip
 */
void bits_renderPresent() {
  SDL_Rect stretchRect;
  int min;
  if (SCREEN_WIDTH < SCREEN_HEIGHT) {
    min = SCREEN_WIDTH;
  } else {
    min = SCREEN_HEIGHT;
  }
  stretchRect.x = (SCREEN_WIDTH - min) / 2;
  stretchRect.y = (SCREEN_HEIGHT - min) / 2;
  stretchRect.w = min;
  stretchRect.h = min;

  //printf("hi\n");
  if (SDL_BlitScaled(bitsSurface, NULL, screenSurface, &stretchRect) < 0) {
    printf("Unable to blit! SDL Error: %s\n", SDL_GetError());
  }
  if (SDL_UpdateWindowSurface(window) < 0) {
    printf("Unable to blit! SDL Error: %s\n", SDL_GetError());
  }
}

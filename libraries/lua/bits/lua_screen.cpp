#include "lua_screen.h"

int screen_data[128 * 128];
Uint32 colors[16];
SDL_Surface *bitsSurface;
int last_color;
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
  last_color = colors[7];
  draw_circle(bitsSurface, 64, 64, 8, colors[1]);
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

/**
   @lua-name pset
   @lua-arg x: int
   @lua-arg y: int
   @lua-arg color: int = last_color
 */
static void pset(lua_Integer x, lua_Integer y, lua_Integer c) {
  set_pixel(bitsSurface, x, y, colors[c]);
}

/**
   @lua-name circ
   @lua-arg x: int
   @lua-arg y: int
   @lua-arg r: int
   @lua-arg color: int = last_color
 */
static void circ(lua_Integer x, lua_Integer y, lua_Integer r, lua_Integer c) {
  draw_circle(bitsSurface, x, y, r, colors[c]);
}


void draw_circle(SDL_Surface* surface, int center_x, int center_y, int radius, Uint32 color) {
   const int diameter = (radius * 2);

   int x = (radius - 1);
   int y = 0;
   int tx = 1;
   int ty = 1;
   int error = (tx - diameter);

   while (x >= y) {
      //  Each of the following renders an octant of the circle
      set_pixel(surface, center_x + x, center_y - y, color);
      set_pixel(surface, center_x + x, center_y + y, color);
      set_pixel(surface, center_x - x, center_y - y, color);
      set_pixel(surface, center_x - x, center_y + y, color);
      set_pixel(surface, center_x + y, center_y - x, color);
      set_pixel(surface, center_x + y, center_y + x, color);
      set_pixel(surface, center_x - y, center_y - x, color);
      set_pixel(surface, center_x - y, center_y + x, color);

      if (error <= 0) {
         ++y;
         error += ty;
         ty += 2;
      }

      if (error > 0) {
         --x;
         tx += 2;
         error += (tx - diameter);
      }
   }
}

void draw_rect(SDL_Surface* surface, int x0, int y0, int x1, int y1, Uint32 color) {
  for(int yi = y0; yi <= y1; ++yi) {
    if (yi == y0 || yi == y1) {
      for(int xi = x0; xi <= x1; ++xi) {
	set_pixel(surface, xi, yi, color);
      }
    } else {
      set_pixel(surface, x0, yi, color);
      set_pixel(surface, x1, yi, color);
    }
  }
}

void fill_rect(SDL_Surface* surface, int x0, int y0, int x1, int y1, Uint32 color) {
  for(int xi = x0; xi <= x1; ++xi) {
    for(int yi = y0; yi <= y1; ++yi) {
      set_pixel(surface, xi, yi, color);
    }
  }
}


void set_pixel(SDL_Surface *surface, int x, int y, Uint32 color) {
  int bpp = surface->format->BytesPerPixel;
  /* Here p is the address to the pixel we want to set */
  Uint8 *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bpp;
  
  switch(bpp) {
  case 1:
    *p = color;
    break;
  case 2:
    *(Uint16 *)p = color;
    break;
  case 3:
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
    p[0] = (color >> 16) & 0xff;
    p[1] = (color >> 8) & 0xff;
    p[2] = color & 0xff;
#else
    p[0] = color & 0xff;
    p[1] = (color >> 8) & 0xff;
    p[2] = (color >> 16) & 0xff;
#endif
    break;
  case 4:
    *(Uint32 *)p = color;
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

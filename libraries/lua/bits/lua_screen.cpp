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
  colors[0] = SDL_MapRGBA(bitsSurface->format, 0, 0, 0, 255);
  colors[1] = SDL_MapRGBA(bitsSurface->format, 29, 43, 83, 255);
  colors[2] = SDL_MapRGBA(bitsSurface->format, 126, 37, 83, 255);
  colors[3] = SDL_MapRGBA(bitsSurface->format, 0, 135, 81, 255);
  colors[4] = SDL_MapRGBA(bitsSurface->format, 171, 82, 54, 255);
  colors[5] = SDL_MapRGBA(bitsSurface->format, 95, 87, 79, 255);
  colors[6] = SDL_MapRGBA(bitsSurface->format, 194, 195, 199, 255);
  colors[7] = SDL_MapRGBA(bitsSurface->format, 255, 241, 232, 255);
  colors[8] = SDL_MapRGBA(bitsSurface->format, 255, 0, 77, 255);
  colors[9] = SDL_MapRGBA(bitsSurface->format, 255, 163, 0, 255);
  colors[10] = SDL_MapRGBA(bitsSurface->format, 255, 236, 39, 255);
  colors[11] = SDL_MapRGBA(bitsSurface->format, 0, 228, 54, 255);
  colors[12] = SDL_MapRGBA(bitsSurface->format, 41, 173, 255, 255);
  colors[13] = SDL_MapRGBA(bitsSurface->format, 41, 173, 255, 255);
  colors[14] = SDL_MapRGBA(bitsSurface->format, 255, 119, 168, 255);
  colors[15] = SDL_MapRGBA(bitsSurface->format, 255, 204, 170, 255);
  last_color = colors[7];
  SDL_FillRect(bitsSurface, &rect, colors[14]);
}

inline void set_last_color(lua_Integer c) {
  if(c >= 0 && c <= 15) {
    last_color = c;
  }
}

inline void draw_vert_line(SDL_Surface* surface, int x, int y0, int y1, Uint32 color) {
  for(int yi = y0; yi <= y1; ++yi) {
    set_pixel(surface, x, yi, color);
  }
}

inline void draw_horz_line(SDL_Surface* surface, int x0, int x1, int y, Uint32 color) {
  for(int xi = x0; xi <= x1; ++xi) {
    set_pixel(surface, xi, y, color);
  }
}

/**
   @lua-name pset
   @lua-arg x: int
   @lua-arg y: int
   @lua-arg color: int = last_color
 */
static void pset(const lua_Integer x, const lua_Integer y, const lua_Integer c) {
  set_last_color(c);
  set_pixel(bitsSurface, x, y, colors[last_color]);
}

/**
   @lua-name circ
   @lua-arg x: int
   @lua-arg y: int
   @lua-arg r: int
   @lua-arg color: int = last_color
 */
static void circ(const lua_Integer x, const lua_Integer y, const lua_Integer r, const lua_Integer c) {
  set_last_color(c);
  draw_circle(bitsSurface, x, y, r, colors[last_color]);
}

/**
   @lua-name circfill
   @lua-arg x: int
   @lua-arg y: int
   @lua-arg r: int
   @lua-arg color: int = last_color
 */
static void circfill(const lua_Integer x, const lua_Integer y, const lua_Integer r, const lua_Integer c) {
  set_last_color(c);
  fill_circle(bitsSurface, x, y, r, colors[last_color]);
}

/**
   @lua-name line
   @lua-arg x0: int
   @lua-arg y0: int
   @lua-arg x1: int
   @lua-arg y1: int
   @lua-arg color: int = last_color
 */
static void line(const lua_Integer x0, const lua_Integer y0, const lua_Integer x1, const lua_Integer y1, const lua_Integer c) {
  set_last_color(c);
  draw_line(bitsSurface, x0,y0,x1,y1, colors[last_color]);
}

/**
   @lua-name rect
   @lua-arg x0: int
   @lua-arg y0: int
   @lua-arg x1: int
   @lua-arg y1: int
   @lua-arg color: int = last_color
 */
static void rect(const lua_Integer x0, const lua_Integer y0, const lua_Integer x1, const lua_Integer y1, const lua_Integer c) {
  set_last_color(c);
  draw_rect(bitsSurface, x0,y0,x1,y1, colors[last_color]);
}

/**
   @lua-name rectfill
   @lua-arg x0: int
   @lua-arg y0: int
   @lua-arg x1: int
   @lua-arg y1: int
   @lua-arg color: int = last_color
 */
static void rectfill(const lua_Integer x0, const lua_Integer y0, const lua_Integer x1, const lua_Integer y1, const lua_Integer c) {
  set_last_color(c);
  fill_rect(bitsSurface, x0,y0,x1,y1, colors[last_color]);
}

void draw_line(SDL_Surface* surface, int x0, int y0, int x1, int y1, Uint32 color) {
  int dx = abs(x1-x0);
  int sx = x0 < x1 ? 1 : -1;
  int dy = -abs(y1-y0);
  int sy = y0 < y1 ? 1 : -1;
  int error_xy = dx + dy;
  if (dx == 0) {
    draw_vert_line(surface, x0, std::min(y0, y1), std::max(y0, y1), color);
  }
  if (dx == 0) {
    draw_vert_line(surface, std::min(x0, x1), std::max(x0, x1), y0, color);
  }
  while (true) {   /* loop */
    set_pixel(surface, x0, y0, color);
    if (x0 == x1 && y0 == y1) {
      break;
    }
    int e2 = 2 * error_xy;
    if (e2 >= dy) { 
      error_xy += dy; // error now > 0
      x0 += sx;
    }
    if (e2 <= dx) { 
      error_xy += dx; // error now < 0
      y0 += sy;
    }
  }
}

void draw_circle(SDL_Surface* surface, int center_x, int center_y, int radius, Uint32 color) {
   const int diameter = radius * 2;

   int x = radius - 1;
   int y = 0;
   int tx = 1;
   int ty = 1;
   int error = tx - diameter;

   while (x >= y) {
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
         error += tx - diameter;
      }
   }
}

void fill_circle(SDL_Surface* surface, int center_x, int center_y, int radius, Uint32 color) {
   const int diameter = radius * 2;

   int x = radius - 1;
   int y = 0;
   int tx = 1;
   int ty = 1;
   int error = tx - diameter;

   while (x >= y) {
     draw_vert_line(surface, center_x + x, center_y - y, center_y + y, color);

     draw_vert_line(surface, center_x - x, center_y - y, center_y + y, color);

     draw_vert_line(surface, center_x + y, center_y - x, center_y + x, color);

     draw_vert_line(surface, center_x - y, center_y - x, center_y + x, color);
      
      if (error <= 0) {
         ++y;
         error += ty;
         ty += 2;
      }

      if (error > 0) {
         --x;
         tx += 2;
         error += tx - diameter;
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
    min = (SCREEN_WIDTH / 128) * 128;
  } else {
    min = (SCREEN_HEIGHT / 128) * 128;
  }
  stretchRect.x = (SCREEN_WIDTH - min) / 2;
  stretchRect.y = (SCREEN_HEIGHT - min) / 2;
  stretchRect.w = min;
  stretchRect.h = min;

  if (SDL_BlitScaled(bitsSurface, NULL, screenSurface, &stretchRect) < 0) {
    printf("Unable to blit! SDL Error: %s\n", SDL_GetError());
  }
  if (SDL_UpdateWindowSurface(window) < 0) {
    printf("Unable to blit! SDL Error: %s\n", SDL_GetError());
  }
}

#include "bits_globals.hh"
#include "lua_surface.hh"

Uint32 make_pixel(Uint8 r, Uint8 g, Uint8 b);
void set_pixel(SDL_Surface* surface, int x, int y, Uint32 pixel);
void draw_circle(SDL_Surface* surface, int32_t center_x, int32_t center_y,
                 int32_t radius, Uint32 color);
void fill_circle(SDL_Surface* surface, int32_t center_x, int32_t center_y,
                 int32_t radius, Uint32 color);
void draw_rect(SDL_Surface* surface, int x0, int y0, int x1, int y1,
               Uint32 color);
void draw_line(SDL_Surface* surface, int x0, int y0, int x1, int y1,
               Uint32 color);
void fill_rect(SDL_Surface* surface, int x0, int y0, int x1, int y1,
               Uint32 color);
void initBits();

void destroyBits();
void bits_renderPresent();

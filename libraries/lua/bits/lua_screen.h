#include "globals.h"
#include "lua_surface.h"

Uint32 make_pixel(Uint8 r, Uint8 g, Uint8 b);
void set_pixel(SDL_Surface *surface, int x, int y, Uint32 pixel);
void initBits();

void destroyBits();
void bits_renderPresent();

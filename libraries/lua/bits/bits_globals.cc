#include "bits_globals.hh"

Uint8 memory[0x10000];
Uint8* screen_data = memory + 0x6000;
Uint32 colors[16];
SDL_Surface* bitsSurface;
int last_color;

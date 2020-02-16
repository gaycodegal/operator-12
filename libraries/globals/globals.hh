#ifndef _GLOBALS_H_
#define _GLOBALS_H_

#include "sdl_include.hh"

// Screen dimension constants
extern int SCREEN_WIDTH;
extern int SCREEN_HEIGHT;
// global SDL2 variables
extern SDL_Window *window;
extern SDL_Surface *screenSurface;
extern SDL_Renderer *globalRenderer;
extern TTF_Font *gFont;

// set true to exit program at end of loop
extern bool quit;
// delay between this and the next frame
extern int framedelay;

extern int screen_data[128 * 128];

#endif

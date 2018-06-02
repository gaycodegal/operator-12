#include "main.hpp"
#define SDL_ACTIVE
const int SCREEN_WIDTH = 640;
const int SCREEN_HEIGHT = 480;
SDL_Window *window;
SDL_Surface *screenSurface;
SDL_Renderer *globalRenderer;

int start() {
  if (SDL_Init(SDL_INIT_VIDEO) < 0) {
    printf("SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
    return 1;
  }
  /* initialize TTF */
  if (TTF_Init() == -1) {
    printf("Could not initialize SDLTTF SDL_Error: %s\n", SDL_GetError());
    return 1;
  }
  Uint32 initopts = SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL;

  window = SDL_CreateWindow(
      "Game Engine V0", 0, 0,
      /*SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED*/ SCREEN_WIDTH,
      SCREEN_HEIGHT, initopts);
  if (window == NULL) {
    printf("Window could not be created! SDL_Error: %s\n", SDL_GetError());
    return 1;
  }
  globalRenderer = SDL_CreateRenderer(window, -1, 0);
  if (!globalRenderer) {
    printf("Could not create renderer SDL_Error: %s\n", SDL_GetError());
    return 1;
  }
  return 0;
}

int end() {
  if (window != NULL)
    SDL_DestroyWindow(window);
  SDL_Quit();
  return 0;
}

bool quit = false;

void mouseHelper(lua_State *L, int type, const char *event, bool fn_exists) {
  int x, y;
  SDL_GetMouseState(&x, &y);
  if (fn_exists) {
    lua_getglobal(L, event);
    lua_pushnumber(L, x);
    lua_pushnumber(L, y);
    callErr(L, event, 2);
  }
}

int main(int argc, char *args[]) {
  lua_State *L;
  quit = false;
  chdir("resources");
#ifdef SDL_ACTIVE
  if (start() != 0) {
    end();
    return 1;
  }
#endif
  L = luaL_newstate();
  luaL_openlibs(L);
  luaL_requiref(L, LUA_LIBNAME, luaopen_sprites, 1);

  // screenSurface = SDL_GetWindowSurface( window );

  // SDL_FillRect( screenSurface, NULL, SDL_MapRGB( screenSurface->format, 0xFF,
  // 0xFF, 0xFF ) );
  if (!loadLuaFile(L, "load.lua")) {
    end();
    return 1;
  }
  if (globalTypeExists(L, LUA_TFUNCTION, "Start"))
    callLuaVoid(L, "Start");
  int updateExists = globalTypeExists(L, LUA_TFUNCTION, "Update");
  int keydownExists = globalTypeExists(L, LUA_TFUNCTION, "KeyDown");
  int keyupExists = globalTypeExists(L, LUA_TFUNCTION, "KeyUp");
  int mousedownExists = globalTypeExists(L, LUA_TFUNCTION, "MouseDown");
  int mousemoveExists = globalTypeExists(L, LUA_TFUNCTION, "MouseMove");
  int mouseupExists = globalTypeExists(L, LUA_TFUNCTION, "MouseUp");

  SDL_Event e;
  // While application is running
  if (updateExists) {
    while (!quit) {
      // Handle events on queue
      while (SDL_PollEvent(&e) != 0) {
        // User requests quit
        if (e.type == SDL_QUIT) {
          quit = true;
        } // User presses a key
        else if (keydownExists && e.type == SDL_KEYDOWN) {
          lua_getglobal(L, "KeyDown");
          lua_pushnumber(L, e.key.keysym.sym);
          callErr(L, "KeyDown", 1);
        } else if (keyupExists && e.type == SDL_KEYUP) {
          lua_getglobal(L, "KeyUp");
          lua_pushnumber(L, e.key.keysym.sym);
          callErr(L, "KeyUp", 1);
        } else if (e.type == SDL_MOUSEMOTION || e.type == SDL_MOUSEBUTTONDOWN ||
                   e.type == SDL_MOUSEBUTTONUP) {
          // Get mouse position
          switch (e.type) {
          case SDL_MOUSEBUTTONDOWN:
            mouseHelper(L, e.type, "MouseDown", mousedownExists);
            break;
          case SDL_MOUSEMOTION:
            mouseHelper(L, e.type, "MouseMove", mousemoveExists);
            break;
          case SDL_MOUSEBUTTONUP:
            mouseHelper(L, e.type, "MouseUp", mouseupExists);
            break;
          }
        }
      }

      SDL_RenderClear(globalRenderer);
      if (updateExists)
        callLuaVoid(L, "Update");
      SDL_RenderPresent(globalRenderer);
    }
  }
  if (globalTypeExists(L, LUA_TFUNCTION, "End"))
    callLuaVoid(L, "End");
  lua_close(L);
  end();
  return 0;
}

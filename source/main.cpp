#include "main.hpp"
#define SDL_ACTIVE
const int SCREEN_WIDTH = 640;
const int SCREEN_HEIGHT = 480;
SDL_Window *window;
SDL_Surface *screenSurface;
SDL_Renderer *globalRenderer;
TTF_Font *gFont = NULL;
int start() {
  if (SDL_Init(SDL_INIT_VIDEO) < 0) {
    printf("SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
    return 1;
  }
  /* initialize TTF */
  if (TTF_Init() == -1) {
    printf("Could not initialize SDL_TTF SDL_Error: %s\n", SDL_GetError());
    return 1;
  }

  /*if (Mix_OpenAudio(22050, MIX_DEFAULT_FORMAT, 2, 4096) == -1) {
    printf("Could not initialize SDL_MIXER SDL_Error: %s\n", SDL_GetError());
    return 1;
    }*/

  Uint32 initopts = SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE;

  window = SDL_CreateWindow("Game Engine V0", SDL_WINDOWPOS_CENTERED,
                            SDL_WINDOWPOS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT,
                            initopts);
  if (window == NULL) {
    printf("Window could not be created! SDL_Error: %s\n", SDL_GetError());
    return 1;
  }
  globalRenderer = SDL_CreateRenderer(window, -1, 0);
  if (!globalRenderer) {
    printf("Could not create renderer SDL_Error: %s\n", SDL_GetError());
    return 1;
  }
  gFont = TTF_OpenFont("fonts/mozart.ttf", 28);
  if (gFont == NULL) {
    printf("Failed to load lazy font! SDL_ttf Error: %s\n", TTF_GetError());
    return 1;
  }
  SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "0");
  return 0;
}

int end() {
  if (window != NULL)
    SDL_DestroyWindow(window);
  if (gFont != NULL)
    TTF_CloseFont(gFont);
  gFont = NULL;
  //Mix_CloseAudio();
  TTF_Quit();
  IMG_Quit();
  SDL_Quit();
  return 0;
}

bool quit = false;
int framedelay = 1000 / 60;

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

static inline long getMS() {
  return std::chrono::duration_cast<std::chrono::milliseconds>(
             std::chrono::system_clock::now().time_since_epoch())
      .count();
}

lua_State *L;
long lastTick;
int updateExists;
int keydownExists;
int keyupExists;
int mousedownExists;
int mousemoveExists;
int mouseupExists;
SDL_Event e;
void one_iter(){
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
    } else if (e.type == SDL_WINDOWEVENT &&
	       e.window.event == SDL_WINDOWEVENT_RESIZED) {
      lua_getglobal(L, "Resize");
      lua_pushnumber(L, e.window.data1);
      lua_pushnumber(L, e.window.data2);
      callErr(L, "Resize", 2);
    }
  }

  SDL_RenderClear(globalRenderer);
  long nowTick = getMS();
  long delta = (nowTick - lastTick);
  long tdelta = delta;
  if (delta <= 0) {
    delta = 0;
  }
  if (updateExists) {
    lua_getglobal(L, "Update");
    lua_pushnumber(L, delta / 1000.0f);
    lua_pushnumber(L, tdelta);
    callErr(L, "Update", 2);
  }
  lastTick = nowTick;
  SDL_RenderPresent(globalRenderer);
  if (!quit)
    SDL_WaitEventTimeout(NULL, framedelay);
}

#ifndef ANDROID
#undef main
#endif

int main(int argc, char **argv){
  quit = false;
#ifdef _WIN32
  SetCurrentDirectory("resources");
#elif ANDROID
  //already in resources
#else
  chdir("resources");
#endif
  
#ifdef SDL_ACTIVE
  if (start() != 0) {
    end();
    return 1;
  }
#endif
  L = luaL_newstate();
  luaL_openlibs(L);
  luaL_requiref(L, LUA_LIBNAME, luaopen_sprites, 1);
#ifdef ANDROID

  if (!loadLuaFile(L, "android.lua")) {
    end();
    return 1;
  }

#else

  if (argc < 2) {
    if (!loadLuaFile(L, "load.lua")) {
      end();
      return 1;
    }
  } else {
    if (!loadLuaFile(L, (std::string(argv[1]) + ".lua").c_str())) {
      end();
      return 1;
    }
  }
#endif

  
  
  lastTick = getMS();
  if (globalTypeExists(L, LUA_TFUNCTION, "Start"))
    callLuaVoidArgv(L, "Start", argc - 1, argv + 1);
  updateExists = globalTypeExists(L, LUA_TFUNCTION, "Update");
  keydownExists = globalTypeExists(L, LUA_TFUNCTION, "KeyDown");
   keyupExists = globalTypeExists(L, LUA_TFUNCTION, "KeyUp");
   mousedownExists = globalTypeExists(L, LUA_TFUNCTION, "MouseDown");
   mousemoveExists = globalTypeExists(L, LUA_TFUNCTION, "MouseMove");
   mouseupExists = globalTypeExists(L, LUA_TFUNCTION, "MouseUp");
  // While application is running
#ifdef __EMSCRIPTEN__
   // void emscripten_set_main_loop(em_callback_func func, int fps, int simulate_infinite_loop);
   emscripten_set_main_loop(one_iter, 60, 1);
#else
      
   printf("before quit: %d update: %d\n", quit, updateExists);
  if (updateExists) {
    while (!quit) {
      
      one_iter();
    }
  }
  if (globalTypeExists(L, LUA_TFUNCTION, "End"))
    callLuaVoid(L, "End");
  lua_close(L);

  end();
#endif
  return 0;
}

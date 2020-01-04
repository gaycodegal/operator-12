#include "main.h"
int SCREEN_WIDTH = 640;
int SCREEN_HEIGHT = 480;
SDL_Window *window;
SDL_Surface *screenSurface;
SDL_Renderer *globalRenderer;
TTF_Font *gFont = NULL;
bool doInitSDL = false;
SDL_GLContext mainContext;

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
#ifdef ANDROID
  SDL_DisplayMode displayMode;
  if (SDL_GetCurrentDisplayMode(0, &displayMode) == 0) {
    SCREEN_WIDTH = displayMode.w;
    SCREEN_HEIGHT = displayMode.h;
  }
  initopts |= SDL_WINDOW_FULLSCREEN;
#endif
  
  setOpenGLAttributes();
  window = SDL_CreateWindow("Game Engine V0", SDL_WINDOWPOS_CENTERED,
                            SDL_WINDOWPOS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT,
                            initopts);
  if (window == NULL) {
    printf("Window could not be created! SDL_Error: %s\n", SDL_GetError());
    return 1;
  }

  mainContext = SDL_GL_CreateContext(window);
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
  postWindowGLStuff();

  return 0;
}

bool postWindowGLStuff() {

  // Sync buffer swap with monitor's vertical refresh
  SDL_GL_SetSwapInterval(1);

  // allow the useful stuff
  glewExperimental = GL_TRUE; 
  glewInit();

  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  return true;
}

bool setOpenGLAttributes() {
  //EGL_CONTEXT_CLIENT_VERSION must be set for WASM to be happy
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0);

  // Turn on double buffering with a 24bit Z buffer.
  // May be 16 or 32 for other systems
  SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

  return true;
}

int end() {
  if (!doInitSDL)
    return 0;
  if (window != NULL)
    SDL_DestroyWindow(window);
  if (gFont != NULL)
    TTF_CloseFont(gFont);
  gFont = NULL;

  // Mix_CloseAudio();
  TTF_Quit();
  IMG_Quit();
  SDL_Quit();
  return 0;
}

int quit = 0;
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

void mouseWheelHelper(lua_State *L, int dx, int dy, const char *event,
                      bool fn_exists) {
  int x, y;
  SDL_GetMouseState(&x, &y);
  if (fn_exists) {
    lua_getglobal(L, event);
    lua_pushnumber(L, x);
    lua_pushnumber(L, y);
    lua_pushnumber(L, dx);
    lua_pushnumber(L, dy);
    callErr(L, event, 4);
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
int mousewheelExists;
int mousescrollExists;
SDL_Event e;
void one_iter() {
  // Handle events on queue
  while (SDL_PollEvent(&e) != 0) {
    // User requests quit
    if (e.type == SDL_QUIT) {
      quit = 1;
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
    } else if (e.type == SDL_MOUSEWHEEL) {
      mouseWheelHelper(L, e.wheel.x, e.wheel.y, "MouseWheel", mousewheelExists);
    } else if (e.type == SDL_WINDOWEVENT &&
               e.window.event == SDL_WINDOWEVENT_RESIZED) {
      lua_getglobal(L, "Resize");
      lua_pushnumber(L, e.window.data1);
      lua_pushnumber(L, e.window.data2);
      callErr(L, "Resize", 2);
    }
  }

  glClear(GL_COLOR_BUFFER_BIT);
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
  SDL_GL_SwapWindow(window);
  if (!quit)
    SDL_WaitEventTimeout(NULL, framedelay);
}

std::string openConfig(const char *path) {
  std::string ret = "load.lua";
  L = luaL_newstate();
  luaL_openlibs(L);

  if (path == NULL) {
    if (!loadLuaFile(L, "config.lua", 1)) {
      return NULL;
    }
  } else {
    if (!loadLuaFile(L, (std::string(path) + "/config.lua").c_str(), 1)) {
      return NULL;
    }
  }

  lua_getfield(L, -1, "load");
  ret = std::string(lua_tostring(L, -1));
  lua_pop(L, 1);
  lua_getfield(L, -1, "doInitSDL");
  doInitSDL = lua_toboolean(L, -1);
  lua_pop(L, 1);

  lua_close(L);
  return ret;
}

#ifndef ANDROID
#undef main
#endif

int main(int argc, char **argv) {
  quit = 0;
#ifdef _WIN32
  SetCurrentDirectory("resources");
#elif ANDROID
// already in resources
#else
  chdir("resources");
#endif

  std::string path;
  if (argc < 2) {
    path = openConfig(NULL);
  } else {
    path = openConfig(argv[1]);
  }

  if (doInitSDL) {
    if (start() != 0) {
      end();
      return 1;
    }
  }

  L = luaL_newstate();
  luaL_openlibs(L);
  luaL_requiref(L, LUA_LIBNAME, luaopen_gamelibs, 1);

#ifdef ANDROID
  if (!loadLuaFile(L, "android.lua", 0)) {
    end();
    return 1;
  }
#else
  if (!loadLuaFile(L, path.c_str(), 0)) {
    end();
    return 1;
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
  mousewheelExists = globalTypeExists(L, LUA_TFUNCTION, "MouseWheel");
// While application is running
#ifdef __EMSCRIPTEN__
  // void emscripten_set_main_loop(em_callback_func func, int fps, int
  // simulate_infinite_loop);
  emscripten_set_main_loop(one_iter, 60, 1);
#else

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
  if (quit < 0) {
    return -quit;
  }
  return 0;
}

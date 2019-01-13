#include "lua_sprites.hpp"
/*
static int l_music_new(lua_State *L) {
  char *source;
  if (!lua_isstring(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  source = (char *)lua_tostring(L, -1);
  lua_pop(L, 1);
  Mix_Music *music;
  music = Mix_LoadMUS(source);
  if (!music) {
    lua_pushnil(L);
    lua_pushstring(L, (Mix_GetError()));
    return 2;
  }

  *reinterpret_cast<Mix_Music **>(lua_newuserdata(L, sizeof(Mix_Music *))) =
      music;
  set_meta(L, -1, "Music");
  return 1;
}

static int l_music_play(lua_State *L) {
  Mix_Music *music;
  int times;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  times = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  music = *(Mix_Music **)lua_touserdata(L, -1);
  lua_pop(L, 1);
  if (music == NULL) {
    return 0;
  }
  if (Mix_PlayMusic(music, times) == -1) {
    lua_pushstring(L, (Mix_GetError()));
    return 2;
  }
  return 0;
}

static int l_music_setPosition(lua_State *L) {
  Mix_Music *music;
  double position;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  position = (double)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  lua_pop(L, 1);
  if (Mix_SetMusicPosition(position) == -1) {
    lua_pushstring(L, (Mix_GetError()));
    return 1;
  }
  return 0;
}

static int l_music_pause(lua_State *L) {
  Mix_Music **music;
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  lua_pop(L, 1);
  Mix_PauseMusic();
  return 0;
}

static int l_music_resume(lua_State *L) {
  Mix_Music **music;
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  lua_pop(L, 1);
  Mix_ResumeMusic();
  return 0;
}

static int l_music_destroy(lua_State *L) {
  Mix_Music **music;
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  music = (Mix_Music **)lua_touserdata(L, -1);
  lua_pop(L, 1);
  if (music == NULL) {
    return 0;
  }
  Mix_FreeMusic(*music);
  *music = NULL;
  return 0;
}

static const struct luaL_Reg music_meta[] = {
    {"new", l_music_new},
    {"play", l_music_play},
    {"setPosition", l_music_setPosition},
    {"pause", l_music_pause},
    {"resume", l_music_resume},
    {"destroy", l_music_destroy},
    {"__index", l_meta_indexer},
    {NULL, NULL}};
*/
static int l_texture_new(lua_State *L) {
  // printLuaStack(L, "new_tex");
  char *path;
  int w, h;
  if (!lua_isstring(L, -1)) {
    lua_pop(L, 1);
    lua_pushnil(L);
    return 1;
  }
  path = (char *)lua_tostring(L, -1);
  lua_pop(L, 1);
  lua_pushlightuserdata(L, (void *)loadTexture(path, w, h));
  lua_pushnumber(L, w);
  lua_pushnumber(L, h);
  return 3;
}

static int l_texture_destroy(lua_State *L) {
  SDL_Texture *tex;
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  tex = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_DestroyTexture(tex);
  return 0;
}

static int l_texture_newTarget(lua_State *L) {
  int width;
  int height;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  height = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  width = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);

  Uint32 pixformat = SDL_PIXELFORMAT_RGBA8888;
  SDL_Texture *texture = SDL_CreateTexture(
      globalRenderer, pixformat, SDL_TEXTUREACCESS_TARGET, width, height);
  lua_pushlightuserdata(L, (void *)texture);
  return 1;
}

static int l_texture_setRGBMask(lua_State *L) {
  SDL_Texture *texture;
  Uint8 r;
  Uint8 g;
  Uint8 b;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  b = (Uint8)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  g = (Uint8)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  r = (Uint8)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  texture = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_SetTextureColorMod(texture, r, g, b);
  return 0;
}

static int l_texture_setAMask(lua_State *L) {
  SDL_Texture *texture;
  Uint8 a;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  a = (Uint8)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  texture = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  if (SDL_SetTextureAlphaMod(texture, a) < 0) {
    printf("Alpha Mod Err %s\n", SDL_GetError());
  }
  return 0;
}

static int l_texture_renderCopy(lua_State *L) {
  SDL_Texture *texture;
  int sx;
  int sy;
  int sw;
  int sh;
  int dx;
  int dy;
  int dw;
  int dh;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 9);
    return 0;
  }
  dh = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 8);
    return 0;
  }
  dw = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 7);
    return 0;
  }
  dy = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 6);
    return 0;
  }
  dx = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 5);
    return 0;
  }
  sh = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  sw = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  sy = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  sx = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  texture = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_Rect dest;
  dest.x = dx;
  dest.y = dy;
  dest.w = dw;
  dest.h = dh;
  SDL_Rect source;
  source.x = sx;
  source.y = sy;
  source.w = sw;
  source.h = sh;
  SDL_RenderCopy(globalRenderer, texture, &source, &dest);
  return 0;
}

static int l_texture_blendmode(lua_State *L) {
  SDL_Texture *texture;
  SDL_BlendMode mode;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  mode = static_cast<SDL_BlendMode>(static_cast<int>(lua_tonumber(L, -1)));
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  texture = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_SetTextureBlendMode(texture, mode);
  return 0;
}

static const struct luaL_Reg texture_meta[] = {
    {"new", l_texture_new},
    {"destroy", l_texture_destroy},
    {"newTarget", l_texture_newTarget},
    {"setRGBMask", l_texture_setRGBMask},
    {"setAMask", l_texture_setAMask},
    {"renderCopy", l_texture_renderCopy},
    {"blendmode", l_texture_blendmode},
    {NULL, NULL}};

static int l_draw_sprite(lua_State *L) {
  Sprite *s;
  int x, y;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  y = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);

  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  x = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);

  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  s = *(Sprite **)lua_touserdata(L, -1);
  lua_pop(L, 1);
  s->draw(x, y);
  return 0;
}

static int l_free_sprite(lua_State *L) {
  Sprite *s;
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  s = *(Sprite **)lua_touserdata(L, -1);
  lua_pop(L, 1);
  delete s;
  return 0;
}

static int l_static_quit(lua_State *L) {
  quit = true;
  return 0;
}

static int l_static_wait(lua_State *L) {
  int t;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  t = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  SDL_Delay(t);
  return 0;
}

static int l_static_framedelay(lua_State *L) {
  int t;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  t = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  framedelay = t;
  return 0;
}

static int l_static_setRenderTarget(lua_State *L) {
  SDL_Texture *texture;
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  texture = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_SetRenderTarget(globalRenderer, texture);
  return 0;
}

static int l_static_unsetRenderTarget(lua_State *L) {
  SDL_SetRenderTarget(globalRenderer, NULL);
  return 0;
}

static int l_static_renderClear(lua_State *L) {
  SDL_SetRenderDrawColor(globalRenderer, 0x00, 0x00, 0x00, 0x00);
  SDL_Rect rect;
  rect.x = 0;
  rect.y = 0;
  rect.w = SCREEN_WIDTH;
  rect.h = SCREEN_HEIGHT;
  SDL_RenderFillRect(globalRenderer, &rect);
  return 0;
}

static int l_static_renderBlendmode(lua_State *L) {
  SDL_BlendMode mode;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  mode = static_cast<SDL_BlendMode>(static_cast<int>(lua_tonumber(L, -1)));
  lua_pop(L, 1);
  SDL_SetRenderDrawBlendMode(globalRenderer, mode);
  return 0;
}

static const struct luaL_Reg static_meta[] = {
    {"quit", l_static_quit},
    {"wait", l_static_wait},
    {"framedelay", l_static_framedelay},
    {"setRenderTarget", l_static_setRenderTarget},
    {"unsetRenderTarget", l_static_unsetRenderTarget},
    {"renderClear", l_static_renderClear},
    {"renderBlendmode", l_static_renderBlendmode},
    {NULL, NULL}};

static int l_move_sprite(lua_State *L) {
  // printLuaStack(L, "move_sprite");
  int x, y;
  Sprite *s;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  y = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  x = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  s = *reinterpret_cast<Sprite **>(lua_touserdata(L, -1));
  lua_pop(L, 1);
  s->move(x, y);
  return 0;
}

static int l_size_sprite(lua_State *L) {
  // printLuaStack(L, "size_sprite");
  int w, h;
  Sprite *s;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  h = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  w = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  s = *reinterpret_cast<Sprite **>(lua_touserdata(L, -1));
  lua_pop(L, 1);
  s->size(w, h);
  return 1;
}

static int l_new_sprite(lua_State *L) {
  // printLuaStack(L, "new_sprite");
  int x, y, w, h, sx, sy;
  SDL_Texture *tex;
  Sprite *s;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 7);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  sy = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 6);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  sx = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 5);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  h = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  w = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  y = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }

  x = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);

  // printf("here %s\n", lua_typename(L, lua_type(L, -1)));
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }

  // printf("(x %i, y %i, w %i, h %i) sx %i, sy%i\n", x,y,w,h,sx,sy);
  tex = (SDL_Texture *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  s = new Sprite();
  *reinterpret_cast<Sprite **>(lua_newuserdata(L, sizeof(Sprite *))) = s;

  s->init(tex, x, y, w, h, sx, sy);
  /*for(int l = 0; l < sizeof(Sprite); l++){
    printf("c: %i/%ld v: %i\n", l, sizeof(Sprite), *(c++));
    }*/
  // s->draw();
  set_meta(L, -1, "Sprite");
  return 1;
}

static int l_surface_new(lua_State *L) {
  char *source;
  if (!lua_isstring(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  source = (char *)lua_tostring(L, -1);
  lua_pop(L, 1);
  SDL_Surface *loadedSurface = IMG_Load(source);
  if (loadedSurface == NULL) {
    printf("Unable to load image %s! SDL_image Error: %s\n", source,
           IMG_GetError());
    lua_pushnil(L);
  } else {
    lua_pushlightuserdata(L, (void *)loadedSurface);
  }
  return 1;
}

static int l_surface_newBlank(lua_State *L) {
  int width;
  int height;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  height = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  width = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  Uint32 rmask, gmask, bmask, amask;

/* SDL interprets each pixel as a 32-bit number, so our masks must depend
       on the endianness (byte order) of the machine */
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
  rmask = 0xff000000;
  gmask = 0x00ff0000;
  bmask = 0x0000ff00;
  amask = 0x000000ff;
#else
  rmask = 0x000000ff;
  gmask = 0x0000ff00;
  bmask = 0x00ff0000;
  amask = 0xff000000;
#endif
  SDL_Surface *s =
      SDL_CreateRGBSurface(0, width, height, 32, rmask, gmask, bmask, amask);
  lua_pushlightuserdata(L, (void *)s);
  return 1;
}

static int l_surface_blendmode(lua_State *L) {
  SDL_Surface *surface;
  SDL_BlendMode mode;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  mode = static_cast<SDL_BlendMode>(static_cast<int>(lua_tonumber(L, -1)));
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  surface = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_SetSurfaceBlendMode(surface, mode);
  return 0;
}

static int l_surface_fill(lua_State *L) {
  SDL_Surface *surface;
  int x;
  int y;
  int width;
  int height;
  int r;
  int g;
  int b;
  int a;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 9);
    return 0;
  }
  a = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 8);
    return 0;
  }
  b = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 7);
    return 0;
  }
  g = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 6);
    return 0;
  }
  r = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 5);
    return 0;
  }
  height = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  width = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  y = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  x = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  surface = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_Rect rect;
  rect.x = x;
  rect.y = y;
  rect.w = width;
  rect.h = height;
  SDL_FillRect(surface, &rect, SDL_MapRGBA(surface->format, r, g, b, a));
  return 0;
}

static int l_surface_size(lua_State *L) {
  SDL_Surface *surface;
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  surface = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  lua_pushnumber(L, surface->w);
  lua_pushnumber(L, surface->h);
  return 2;
}

static int l_surface_blit(lua_State *L) {
  SDL_Surface *dst;
  SDL_Surface *src;
  int x;
  int y;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  y = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  x = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  src = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  dst = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_Rect stretchRect;
  stretchRect.x = x;
  stretchRect.y = y;
  stretchRect.w = src->w;
  stretchRect.h = src->h;
  if (SDL_BlitScaled(src, NULL, dst, &stretchRect) < 0) {
    printf("Unable to blit! SDL Error: %s\n", SDL_GetError());
  }
  return 0;
}

static int l_surface_textureFrom(lua_State *L) {
  SDL_Surface *surface;
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  surface = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  // Create texture from surface pixels
  SDL_Texture *newTexture =
      SDL_CreateTextureFromSurface(globalRenderer, surface);
  if (newTexture == NULL) {
    printf("Unable to create texture from surface! SDL Error: %s\n",
           SDL_GetError());
    return 0;
  }
  lua_pushlightuserdata(L, (void *)newTexture);
  return 1;
}

static int l_surface_blitScale(lua_State *L) {
  SDL_Surface *dst;
  SDL_Surface *src;
  int sx;
  int sy;
  int sw;
  int sh;
  int dx;
  int dy;
  int dw;
  int dh;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 10);
    return 0;
  }
  dh = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 9);
    return 0;
  }
  dw = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 8);
    return 0;
  }
  dy = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 7);
    return 0;
  }
  dx = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 6);
    return 0;
  }
  sh = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 5);
    return 0;
  }
  sw = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  sy = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  sx = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  src = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  dst = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_Rect stretchRect;
  stretchRect.x = dx;
  stretchRect.y = dy;
  stretchRect.w = dw;
  stretchRect.h = dh;
  SDL_Rect sourceRect;
  sourceRect.x = sx;
  sourceRect.y = sy;
  sourceRect.w = sw;
  sourceRect.h = sh;
  if (SDL_BlitScaled(src, &sourceRect, dst, &stretchRect) < 0) {
    printf("Unable to blit! SDL Error: %s\n", SDL_GetError());
  }
  return 0;
}

static int l_surface_destroy(lua_State *L) {
  SDL_Surface *surface;
  if (!lua_islightuserdata(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  surface = (SDL_Surface *)lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_FreeSurface(surface);
  return 0;
}

static const struct luaL_Reg surface_meta[] = {
    {"new", l_surface_new},
    {"newBlank", l_surface_newBlank},
    {"blendmode", l_surface_blendmode},
    {"fill", l_surface_fill},
    {"size", l_surface_size},
    {"blit", l_surface_blit},
    {"textureFrom", l_surface_textureFrom},
    {"blitScale", l_surface_blitScale},
    {"destroy", l_surface_destroy},
    {NULL, NULL}};

static int l_ttf_surface(lua_State *L) {
  char *text;
  int r;
  int g;
  int b;
  int a;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 5);
    return 0;
  }
  a = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    return 0;
  }
  b = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  g = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  r = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (!lua_isstring(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  text = (char *)lua_tostring(L, -1);
  lua_pop(L, 1);
  SDL_Color c;
  c.r = r;
  c.b = b;
  c.g = g;
  c.a = a;
  SDL_Surface *textSurface = TTF_RenderText_Solid(gFont, text, c);
  lua_pushlightuserdata(L, (void *)textSurface);
  return 1;
}

static int l_ttf_size(lua_State *L) {
  char *text;
  if (!lua_isstring(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  text = (char *)lua_tostring(L, -1);
  lua_pop(L, 1);
  int w, h;
  if (TTF_SizeText(gFont, text, &w, &h) < 0) {
    printf("Error sizing font %s\n", TTF_GetError());
    return 0;
  }
  lua_pushnumber(L, w);
  lua_pushnumber(L, h);
  return 2;
}

static const struct luaL_Reg ttf_meta[] = {
    {"surface", l_ttf_surface}, {"size", l_ttf_size}, {NULL, NULL}};

static const struct luaL_Reg spritemeta[] = {{"new", l_new_sprite},
                                             {"draw", l_draw_sprite},
                                             {"destroy", l_free_sprite},
                                             {"move", l_move_sprite},
                                             {"size", l_size_sprite},
                                             {"__index", l_meta_indexer},
                                             {NULL, NULL}};

static const struct luaClassList game[] = { //{"Music", music_meta},
    {"Texture", texture_meta}, {"Sprite", spritemeta}, {"static", static_meta},
    {"Surface", surface_meta}, {"TTF", ttf_meta},      {NULL, NULL}};

struct luaConstInt {
  const char *name;
  const int val;
};

static const struct luaConstInt globints[] = {
    {"SCREEN_WIDTH", SCREEN_WIDTH},
    {"SCREEN_HEIGHT", SCREEN_HEIGHT},
    {"KEY_UP", SDLK_UP},
    {"KEY_DOWN", SDLK_DOWN},
    {"KEY_LEFT", SDLK_LEFT},
    {"KEY_RIGHT", SDLK_RIGHT},
    {"KEY_ESCAPE", SDLK_ESCAPE},
    {"KEY_a", SDLK_a},
    {"KEY_b", SDLK_b},
    {"KEY_c", SDLK_c},
    {"KEY_d", SDLK_d},
    {"KEY_e", SDLK_e},
    {"KEY_f", SDLK_f},
    {"KEY_g", SDLK_g},
    {"KEY_h", SDLK_h},
    {"KEY_i", SDLK_i},
    {"KEY_j", SDLK_j},
    {"KEY_k", SDLK_k},
    {"KEY_l", SDLK_l},
    {"KEY_m", SDLK_m},
    {"KEY_n", SDLK_n},
    {"KEY_o", SDLK_o},
    {"KEY_p", SDLK_p},
    {"KEY_q", SDLK_q},
    {"KEY_r", SDLK_r},
    {"KEY_s", SDLK_s},
    {"KEY_t", SDLK_t},
    {"KEY_u", SDLK_u},
    {"KEY_v", SDLK_v},
    {"KEY_w", SDLK_w},
    {"KEY_x", SDLK_x},
    {"KEY_y", SDLK_y},
    {"KEY_z", SDLK_z},
    {"KEY_0", SDLK_0},
    {"KEY_1", SDLK_1},
    {"KEY_2", SDLK_2},
    {"KEY_3", SDLK_3},
    {"KEY_4", SDLK_4},
    {"KEY_5", SDLK_5},
    {"KEY_6", SDLK_6},
    {"KEY_7", SDLK_7},
    {"KEY_8", SDLK_8},
    {"KEY_9", SDLK_9},
    {"KEY_QUOTE", SDLK_QUOTE},
    {"KEY_QUOTEDBL", SDLK_QUOTEDBL},
    {"KEY_SLASH", SDLK_SLASH},
    {"KEY_BACKSLASH", SDLK_BACKSLASH},
    {"KEY_COMMA", SDLK_COMMA},
    {"KEY_PERIOD", SDLK_PERIOD},
    {"KEY_EQUALS", SDLK_EQUALS},
    {"KEY_SEMICOLON", SDLK_SEMICOLON},
    {"KEY_COLON", SDLK_COLON},
    {"KEY_BACKSPACE", SDLK_BACKSPACE},
    {"KEY_QUESTION", SDLK_QUESTION},
    {"KEY_GREATER", SDLK_GREATER},
    {"KEY_LESS", SDLK_LESS},
    {"KEY_RIGHTPAREN", SDLK_RIGHTPAREN},
    {"KEY_LEFTPAREN", SDLK_LEFTPAREN},
    {"KEY_UNDERSCORE", SDLK_UNDERSCORE},
    {"KEY_PERCENT", SDLK_PERCENT},
    {"KEY_MINUS", SDLK_MINUS},
    {"KEY_PLUS", SDLK_PLUS},
    {"KEY_HASH", SDLK_HASH},
    {"KEY_EXCLAIM", SDLK_EXCLAIM},
    {"KEY_AT", SDLK_AT},
    {"KEY_CARET", SDLK_CARET},
    {"KEY_AMPERSAND", SDLK_AMPERSAND},
    {"KEY_ASTERISK", SDLK_ASTERISK},
    {"KEY_LEFTBRACE", SDLK_KP_LEFTBRACE},
    {"KEY_RIGHTBRACE", SDLK_KP_RIGHTBRACE},
    {"KEY_RIGHTBRACKET", SDLK_RIGHTBRACKET},
    {"KEY_LEFTBRACKET", SDLK_LEFTBRACKET},
    {"KEY_RALT", SDLK_RALT},
    {"KEY_LALT", SDLK_LALT},
    {"KEY_LCTRL", SDLK_LCTRL},
    {"KEY_RCTRL", SDLK_RCTRL},
    {"KEY_RSHIFT", SDLK_RSHIFT},
    {"KEY_LSHIFT", SDLK_LSHIFT},
    {"KEY_TICK", SDLK_BACKQUOTE},
    {"KEY_ENTER", SDLK_RETURN},
    {"KEY_ENTER2", SDLK_RETURN2},
    {"KEY_SPACE", SDLK_SPACE},
    {"BLENDMODE_NONE", SDL_BLENDMODE_NONE},
    {"BLENDMODE_BLEND", SDL_BLENDMODE_BLEND},
    {"BLENDMODE_ADD", SDL_BLENDMODE_ADD},
    {"BLENDMODE_MOD", SDL_BLENDMODE_MOD},
    {NULL, 0}};

int luaopen_sprites(lua_State *L) {
  int count = 0;
  lua_newtable(L);
  struct luaClassList *ptr = (struct luaClassList *)game;
  while (ptr->name != NULL) {
    ++count;
    lua_newtable(L);
    luaL_setfuncs(L, ptr->meta, 0);
    lua_setfield(L, -2, ptr->name);
    ++ptr;
  }
  struct luaConstInt *pint = (struct luaConstInt *)globints;
  while (pint->name != NULL) {
    lua_pushnumber(L, pint->val);
    lua_setfield(L, -2, pint->name);
    ++pint;
  }
  return 1;
}

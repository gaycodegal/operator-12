#include "lua_sprites.hpp"

static int l_free_texture(lua_State *L) {
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

static int l_new_texture(lua_State *L) {
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

static int l_static_wait(lua_State *L) {
  // printLuaStack(L, "static_wait");
  int t;
  Sprite *s;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  t = (int)lua_tonumber(L, -1);
  lua_pop(L, 1);
  SDL_Delay(t);
  return 0;
}

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

static int l_quit(lua_State *L) {
  quit = true;
  return 0;
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
  SDL_Surface *s = SDL_CreateRGBSurface(0, width, height, 32, rmask, gmask, bmask, amask);
  lua_pushlightuserdata(L, (void *)s);
  return 1;
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
  SDL_BlitScaled(src, &sourceRect, dst, &stretchRect);
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

static const struct luaL_Reg texturemeta[] = {
  {"new", l_new_texture}, {"destroy", l_free_texture}, {NULL, NULL}};

static const struct luaL_Reg staticmeta[] = {
  {"wait", l_static_wait}, {"quit", l_quit}, {NULL, NULL}};

static const struct luaClassList game[] = {
  {"Texture", texturemeta},  {"Sprite", spritemeta}, {"static", staticmeta},
  {"Surface", surface_meta}, {"TTF", ttf_meta},      {NULL, NULL}};

struct luaConstInt {
  const char *name;
  const int val;
};

static const struct luaConstInt globints[] = {{"SCREEN_WIDTH", SCREEN_WIDTH},
                                              {"SCREEN_HEIGHT", SCREEN_HEIGHT},
                                              {"KEY_UP", SDLK_UP},
                                              {"KEY_DOWN", SDLK_DOWN},
                                              {"KEY_LEFT", SDLK_LEFT},
                                              {"KEY_RIGHT", SDLK_RIGHT},
                                              {"KEY_ESCAPE", SDLK_ESCAPE},
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

#include "lua_sprites.h"
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
  times = lua_tointeger(L, -1);
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

static int l_draw_sprite(lua_State *L) {
  Sprite *s;
  int x, y;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  y = lua_tointeger(L, -1);
  lua_pop(L, 1);

  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  x = lua_tointeger(L, -1);
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

static int l_move_sprite(lua_State *L) {
  // printLuaStack(L, "move_sprite");
  int x, y;
  Sprite *s;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    return 0;
  }
  y = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  x = lua_tointeger(L, -1);
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
  h = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    return 0;
  }
  w = lua_tointeger(L, -1);
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
  sy = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 6);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  sx = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 5);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  h = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 4);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  w = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 3);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }
  y = lua_tointeger(L, -1);
  lua_pop(L, 1);
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 2);
    // printf("abort\n");
    lua_pushnil(L);
    return 1;
  }

  x = lua_tointeger(L, -1);
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

const struct luaL_Reg spritemeta[] = {{"new", l_new_sprite},
                                             {"draw", l_draw_sprite},
                                             {"destroy", l_free_sprite},
                                             {"move", l_move_sprite},
                                             {"size", l_size_sprite},
                                             {"__index", l_meta_indexer},
                                             {NULL, NULL}};

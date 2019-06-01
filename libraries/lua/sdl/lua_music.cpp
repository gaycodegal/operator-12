#ifndef NO_MUSIC
#include "lua_music.h"

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
  double position;
  if (!lua_isnumber(L, -1)) {
    lua_pop(L, 1);
    return 0;
  }
  position = (double)lua_tonumber(L, -1);
  lua_pop(L, 1);
  if (Mix_SetMusicPosition(position) == -1) {
    lua_pushstring(L, (Mix_GetError()));
    return 1;
  }
  return 0;
}

static int l_music_pause(lua_State *L) {
  Mix_PauseMusic();
  return 0;
}

static int l_music_resume(lua_State *L) {
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

const struct luaL_Reg music_meta[] = {{"new", l_music_new},
                                      {"play", l_music_play},
                                      {"setPosition", l_music_setPosition},
                                      {"pause", l_music_pause},
                                      {"resume", l_music_resume},
                                      {"destroy", l_music_destroy},
                                      {"__index", l_meta_indexer},
                                      {NULL, NULL}};

#endif

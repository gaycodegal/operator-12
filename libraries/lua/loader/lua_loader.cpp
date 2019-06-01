#include "lua_loader.h"

struct luaConstInt {
  const char *name;
  const int val;
};

int luaopen_gamelibs(lua_State *L) {
  static const struct luaClassList game[] = {
#ifndef NO_MUSIC
      {"Music", music_meta},
#endif
      {"Texture", texture_meta},
      {"Sprite", spritemeta},
      {"static", static_meta},
      {"Surface", surface_meta},
      {"TTF", ttf_meta},
      {NULL, NULL}};

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

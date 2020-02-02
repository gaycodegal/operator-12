#nguard NO_MUSIC
#include "lua_music.h"

/**
   creates new music from a source file

   @lua-constructor
   @lua-name new
   @lua-arg source: string
   @lua-return Class Mix_Music Music
 */
static Mix_Music* l_music_new(const char* source) {
  Mix_Music *music = Mix_LoadMUS(source);
  if (!music) {
    printf("Music error: %s\n", Mix_GetError());
  }
  return music;
}

/**
   plays a music n times

   @lua-name play
   @lua-arg self: Class Mix_Music
   @lua-arg times: int
 */
static void l_music_play(Mix_Music* self, lua_Integer times) {
  if (Mix_PlayMusic(self, times) == -1) {
    printf("Music error: %s\n", Mix_GetError());
  }
}

/**
   sets the position of the current music

   @lua-name setPosition
   @lua-arg position: number
 */
static void l_music_setPosition(lua_Number position) {
  if (Mix_SetMusicPosition(position) == -1) {
    printf("Music error: %s\n", Mix_GetError());
  }
}

/**
   pauses the current music

   @lua-name pause
 */
static void l_music_pause() {
  Mix_PauseMusic();
}

/**
   resumes the current music

   @lua-name resume
 */
static void l_music_resume() {
  Mix_ResumeMusic();
}

/**
   frees a music

   @lua-name destroy
   @lua-arg self: Delete Mix_Music
 */
static void l_music_destroy(Mix_Music* self) {
  Mix_FreeMusic(self);
}

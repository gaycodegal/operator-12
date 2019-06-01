#include "util_files.h"

char *fileRead(const char *fname, Sint64 &size) {
  SDL_RWops *io = SDL_RWFromFile(fname, "rb");
  if (io == NULL) {
    printf("No such file %s\n", fname);
    return NULL;
  }
  size = SDL_RWsize(io);
  if (size == -1) {
    SDL_RWclose(io);
    return NULL;
  }
  char *c = new char[size + 1];
  SDL_RWread(io, c, size, 1);
  SDL_RWclose(io);
  c[size] = 0;
  return c;
}

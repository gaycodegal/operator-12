#include "util_files.hh"

std::string fileRead(const char* fname, bool& success) {
  SDL_RWops* io = SDL_RWFromFile(fname, "rb");
  if (io == NULL) {
    printf("No such file %s\n", fname);
    success = false;
    return "";
  }
  Sint64 size = SDL_RWsize(io);
  if (size == -1) {
    SDL_RWclose(io);
    success = false;
    return "";
  }
  std::string out(size + 1, ' ');
  // modifying data safe in C++11 or higher
  char* data = const_cast<char*>(out.data());
  SDL_RWread(io, data, size, 1);
  SDL_RWclose(io);
  data[size] = 0;
  success = true;
  return out;
}

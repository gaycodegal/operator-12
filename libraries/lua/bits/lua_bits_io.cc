#include "lua_bits_io.hh"

inline int hexdig(char c) {
  if (c >= '0' && c <= '9') {
    return c - '0';
  }
  if (c >= 'a' && c <= 'f') {
    return c - 'a' + 10;
  }
  return c - 'A' + 10;
}

bool init_memory(std::string file) {
  //file = std::string("lu\0luaa");
  size_t gfx = file.find("\n__gfx__\n");
  if (gfx == std::string::npos) {
    return false;
  }
  gfx += 9;
  size_t label = file.find("\n__label__\n");
  if (label == std::string::npos || gfx > label) {
    return false;
  }
  label += 11;
  const auto splits = util::split(file.substr(gfx, label - gfx), '\n');
  size_t i = 0x0;
  for (const auto& split : splits) {
    for(size_t j = 0; j < split.size(); j += 2) {
      memory[i] = (hexdig(split[j]) << 4) | hexdig(split[j + 1]);
      ++i;
    }
  }
  return true;
}

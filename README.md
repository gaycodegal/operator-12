
# About

- Successfully bound Lua and SDL2 on Linux.
Implementated basic Sprite class into Lua.
- Documentation not yet written, currently figuring out how I wish to organize the project in terms of both code structure, and physical file locations. At the current stage of the project, I'm still learning about interacting with Lua.
  - Haven't dealt with Lua's setjmp and longjmp usage for errors yet.
- Planning to implement sprites, tweens, text, and music into Lua. I may incorporate some support for bezier curves possibly and possibly very basic support for something like synfig studio's .sif animation format tying in work from a previous project.
- Still very much a work in progress.

# Building

Custom Libraries you'll need
- SDL2-Dev `apt-get install libsdl2-dev`
- SDL2-Image-Dev `apt-get install libsdl2-image-dev`
- SDL2-TTF-Dev `apt-get install libsdl2-ttf-dev`
- SDL2-Mixer-Dev `apt-get install libsdl2-mixer-dev`
- Lua 5.3.4
  - Installation instructions available at [www.lua.org](https://www.lua.org/download.html)

# Classes

Sprite
- new(Texture, sx, sy, sw, sh, x, y, w, h)
- move(self, x, y)
- size(self, w, h)
- destroy(self)

Texture
- new(source)
  - doesn't create an object (userdata), only a pointer (lightuserdata)
- destroy(texture)

# Temporary sprite asset

Turtle from:

| Tag | Data |
|---|---|
| Source | https://www.creativetail.com/40-free-flat-animal-icons/ or http://archive.is/lE5aD |
| Author | Creative Tail |
| Permission (Reusing this file) | https://www.creativetail.com/licensing/ |

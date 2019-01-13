#ifndef _DRAWABLE_HPP_
#define _DRAWABLE_HPP_

/**
   anything that can draw itself to the current sdl2 context
 */
class Drawable {
public:
  Drawable() {}
  virtual ~Drawable() {}
  virtual void draw(int x, int y) = 0;
};

#endif

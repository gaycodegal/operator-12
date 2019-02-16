#ifndef _DRAWABLE_H_
#define _DRAWABLE_H_

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

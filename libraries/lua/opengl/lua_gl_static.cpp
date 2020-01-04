#include "sdl_include.h"
#include "lua_include.h"
#include "lua_gl_static.h"
#include "util_lua.h"

/**
   @lua-name clearColor
   @lua-arg r: number
   @lua-arg g: number
   @lua-arg b: number
   @lua-arg a: number
 */
static void l_gl_clearColor(lua_Number r, lua_Number g, lua_Number b, lua_Number a) {
  glClearColor(r, g, b, a);
}

/**
   @lua-name genBuffer
   @lua-return int
 */
static lua_Integer gl_gen_buffer() {
  GLuint vb;
  glGenBuffers(1, &vb);
  return vb;
}

/**
   @lua-name genVertexArray
   @lua-return int
 */
static lua_Integer gl_gen_vertex_array() {
  GLuint va;
  glGenVertexArrays(1, &va);
  return va;
}

/**
   @lua-name bindBuffer
   @lua-arg target: int
   @lua-arg buffer: int
 */
static void gl_bind_buffer(lua_Integer target, lua_Integer buffer) {
  glBindBuffer(target, buffer);
}

/**
   @lua-name bindVertexArray
   @lua-arg va: int
 */
static void gl_bind_vertex_array(lua_Integer va) {
  glBindVertexArray(va);
}

/**
   @lua-name bufferData
   @lua-arg target: int
   @lua-arg size: int
   @lua-arg data: Struct VoidArray
   @lua-arg usage: int
 */
static void gl_buffer_data(lua_Integer target, lua_Integer size, VoidArray* data, lua_Integer usage) {
  if (data->data == NULL) {
    return;
  }
  glBufferData(target, size, data->data, usage);
}

/**
   @lua-name vertexAttribPointer
   @lua-arg index: int
   @lua-arg size: int
   @lua-arg type: int
   @lua-arg normalized: bool
   @lua-arg stride: int
   @lua-arg pointer: int
 */
static void gl_vertex_attrib_pointer(lua_Integer index, lua_Integer size, lua_Integer type, bool normalized, lua_Integer stride, lua_Integer pointer) {
  glVertexAttribPointer(index, size, type, normalized, stride, reinterpret_cast<const void*>(pointer));
}

/**
   @lua-name enableVertexAttribArray
   @lua-arg index: int
 */
static void gl_enable_vertex_attrib_array(lua_Integer index) {
  glEnableVertexAttribArray(index);
}



/**
   @lua-name clear
 */
static void l_gl_clear() {
  glClear(GL_COLOR_BUFFER_BIT);
}

/**
   @lua-name drawElements
   @lua-arg mode: int
   @lua-arg count: int
   @lua-arg type: int
   @lua-arg indices: int
 */
static void l_gl_drawElements(lua_Integer mode, lua_Integer count, lua_Integer type, lua_Integer indicies) {
  glDrawElements(mode, count, type, reinterpret_cast<const void*>(indicies));
}

/**
   @lua-name drawArrays
   @lua-arg mode: int
   @lua-arg first: int
   @lua-arg count: int
 */
static void l_gl_drawArrays(lua_Integer mode, lua_Integer first, lua_Integer count) {
  glDrawArrays(mode, first, count);
}

/**
   @lua-name polygonMode
   @lua-arg face: int
   @lua-arg mode: int
 */
static void l_gl_polygonMode(lua_Integer face, lua_Integer mode) {
#ifndef __EMSCRIPTEN__
  glPolygonMode(face, mode);
#endif
}

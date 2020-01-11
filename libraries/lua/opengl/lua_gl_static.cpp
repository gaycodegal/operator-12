#include "lua_gl_static.h"

/**
   @lua-name clearColor
   @lua-arg r: number
   @lua-arg g: number
   @lua-arg b: number
   @lua-arg a: number
 */
static void gl_clearColor(lua_Number r, lua_Number g, lua_Number b, lua_Number a) {
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
   @lua-name activeTexture
   @lua-arg unit: int
 */
static void gl_activeTexture(lua_Integer unit) {
  glActiveTexture(unit + GL_TEXTURE0);
}

/**
   @lua-name bindTexture
   @lua-arg texture: int
 */
static void gl_bindTexture(lua_Integer texture) {
  glBindTexture(GL_TEXTURE_2D, texture);
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
static void gl_clear() {
  glClear(GL_COLOR_BUFFER_BIT);
}

/**
   @lua-name drawElements
   @lua-arg mode: int
   @lua-arg count: int
   @lua-arg type: int
   @lua-arg indices: int
 */
static void gl_drawElements(lua_Integer mode, lua_Integer count, lua_Integer type, lua_Integer indicies) {
  glDrawElements(mode, count, type, reinterpret_cast<const void*>(indicies));
}

/**
   @lua-name uniform1i
   @lua-arg location: int
   @lua-arg v0: int
 */
static void gl_uniform1i(lua_Integer location, lua_Integer v0) {
  glUniform1i(location, v0);
}

/**
   @lua-name uniform1f
   @lua-arg location: int
   @lua-arg v0: number
 */
static void gl_uniform1f(lua_Integer location, lua_Number v0) {
  glUniform1f(location, v0);
}

/**
   @lua-name uniform2f
   @lua-arg location: int
   @lua-arg v0: number
   @lua-arg v1: number
 */
static void gl_uniform2f(lua_Integer location, lua_Number v0, lua_Number v1) {
  glUniform2f(location, v0, v1);
}

/**
   @lua-name uniform3f
   @lua-arg location: int
   @lua-arg v0: number
   @lua-arg v1: number
   @lua-arg v2: number
 */
static void gl_uniform3f(lua_Integer location, lua_Number v0, lua_Number v1, lua_Number v2) {
  glUniform3f(location, v0, v1, v2);
}

/**
   @lua-name uniform4f
   @lua-arg location: int
   @lua-arg v0: number
   @lua-arg v1: number
   @lua-arg v2: number
   @lua-arg v3: number
 */
static void gl_uniform4f(lua_Integer location, lua_Number v0, lua_Number v1, lua_Number v2, lua_Number v3) {
  glUniform4f(location, v0, v1, v2, v3);
}

/**
   @lua-name uniformMatrix4f
   @lua-arg location: int
   @lua-arg transpose: bool
   @lua-arg value: Class glm::mat4
 */
static void gl_uniformMatrix4f(lua_Integer location, bool transpose, glm::mat4* value) {
  glUniformMatrix4fv(location, 1, transpose, glm::value_ptr(*value));
}

/**
   @lua-name drawArrays
   @lua-arg mode: int
   @lua-arg first: int
   @lua-arg count: int
 */
static void gl_drawArrays(lua_Integer mode, lua_Integer first, lua_Integer count) {
  glDrawArrays(mode, first, count);
}

/**
   @lua-name texParameterf
   @lua-arg target: int
   @lua-arg name: int
   @lua-arg param: number
 */
static void gl_texParameterf(lua_Integer target, lua_Integer name, lua_Number param) {
  glTexParameterf(target, name, param);
}

/**
   @lua-name texParameteri
   @lua-arg target: int
   @lua-arg name: int
   @lua-arg param: int
 */
static void gl_texParameteri(lua_Integer target, lua_Integer name, lua_Integer param) {
  glTexParameteri(target, name, param);
}


/**
   @lua-name polygonMode
   @lua-arg face: int
   @lua-arg mode: int
 */
static void gl_polygonMode(lua_Integer face, lua_Integer mode) {
#ifndef __EMSCRIPTEN__
  glPolygonMode(face, mode);
#endif
}

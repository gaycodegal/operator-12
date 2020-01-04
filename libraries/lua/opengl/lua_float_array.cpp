#include "lua_float_array.h"

/**
   @lua-name new
   @lua-arg size: int
   @lua-return Struct FloatArray
 */
static FloatArray float_array_new(lua_Integer size) {
  FloatArray array;
  array.data = new GLfloat[size];
  array.size = size;
  return array;
}

/**
   If indexing with a number, return the number at that index,
   otherwise, fetch whatever value is stored in the metatable for that key

   @lua-meta
   @lua-name __index
 */
static int __index(lua_State *L) {
  FloatArray* self;
  if (lua_isnumber(L, -1)) {
    lua_Integer key = lua_tointeger(L, -1);
    lua_pop(L, 1);

    if (!lua_isuserdata(L, -1)) {
      return 0;
    }
    self = reinterpret_cast<FloatArray*>(lua_touserdata(L, -1));
    if (self->data == NULL) {
      return 0;
    }

    if (key < 0 || key >= self->size) {
      return 0;
    }

    lua_pushnumber(L, self->data[key]);
    return 1;
  }

  lua_getmetatable(L, -2);
  // table
  // str
  // meta
  lua_replace(L, -3);
  // meta
  // str
  lua_gettable(L, -2);
  // meta
  // val
  lua_replace(L, -2);
  // val
  return 1;
}

/**
   do array[number] = number
   @lua-name __newindex
   @lua-arg self: Struct FloatArray
   @lua-arg key: int
   @lua-arg value: number
 */
static void __newindex(FloatArray* self, lua_Integer key, lua_Number value) {
  if (self->data == NULL) {
    return;
  }
  if (key < 0 || key >= self->size) {
    return;
  }
  self->data[key] = value;
}

/**
   get the length
   @lua-name __len
   @lua-arg self: Struct FloatArray
   @lua-return int
 */
static lua_Integer __len(FloatArray* self) {
  if (self->data == NULL) {
    return -1;
  }
  return self->size;
}

/**
   @lua-name destroy
   @lua-arg self: Struct FloatArray
 */
static void float_array_delete(FloatArray* self) {
  if (self->data == NULL) {
    return;
  }
  delete[] self->data;
  self->data = NULL;
}

#ifndef _LUA_HELPERS_H_
#define _LUA_HELPERS_H_
#include "main.h"

/**
   get the length of object at stack index i
 */
int getLen(lua_State *L, int i);

/**
   load a table from a name
 */
void getTable(lua_State *L, const char *named);

/**
   load a table from an index
 */
void getTableAtIndex(lua_State *L, int i);

/**
   get an int from a table
 */
int getInt(lua_State *L, const char *named);

/**
   get a string from a table
 */
std::string getString(lua_State *L, const char *named);

/**
   the library name as exposed to lua.
 */
#define LUA_LIBNAME "Game"
/**
   reads in the text content of a file.
   allocates and returns a c string.
 */
char *fileRead(const char *fname, Sint64 &size);

/**
   loads a lua file named <fname> into the state <L>

   file returns maximally <nresults>
 */
int loadLuaFile(lua_State *L, const char *fname, int nresults);

/**
   checks whether a global variable <name> exists of type <type>
 */
int globalTypeExists(lua_State *L, int type, const char *name);

/**
   calls a lua funciton as if it were a void(void)
 */
void callLuaVoid(lua_State *L, const char *name);

/**
   calls a lua funciton as if it were a void(int,char**)
 */
void callLuaVoidArgv(lua_State *L, const char *name, int argc, char **argv);

/**
   pcall and prints if it messes up
 */
void callErr(lua_State *L, const char *name, int nargs);

/**
   Sets the metatable of an object to LUA_LIBNAME.<name>
 */
void set_meta(lua_State *L, int ind, const char *name);

/**
   prints the entire lua stack, which is normally
   empty save for the current arguments to/stack
   manupulations done within a c funciton
 */
void printLuaStack(lua_State *L, const char *name);

/**
   a function meant to be the __index funciton of
   a metatable on userdata. It will fetch any propety
   of it's own metatable as if it were the property
   of the userdata. Basically useful for accessing
   class methods (and static class vars/functions).
 */
int l_meta_indexer(lua_State *L);

/**
   loads the sprite library into lua
 */
int luaopen_gamelibs(lua_State *L);

#endif

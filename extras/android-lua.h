#include <android/log.h>
#define lua_writestring(s,l) __android_log_print(ANDROID_LOG_DEBUG, "LUA", "%s", (s))
#define lua_writestringerror(s,p) __android_log_print(ANDROID_LOG_ERROR, "LUA", (s), (p))

#ifndef _STD_INCLUDE_H_
#define _STD_INCLUDE_H_

#include <vector>

#ifdef _WIN32

#include <Windows.h>

#elif ANDROID

#include <android/log.h>
#include <jni.h>
#include <stdlib.h>
#include <unistd.h>
#define printf(...)                                                            \
  __android_log_print(ANDROID_LOG_DEBUG, "PRINTF", __VA_ARGS__)
#elif __APPLE__

#include <unistd.h>

#elif __EMSCRIPTEN__

#include <emscripten.h>
#include <unistd.h>

#else

#include <unistd.h>

#endif

#include <chrono>
#include <stdio.h>
#include <string>

#endif

#include "sdl_include.h"
#include "lua_include.h"
#include "util_lua.h"

class Shader {
public:
  Shader(const char* vert, const char* frag);
  ~Shader();
  bool isOk();
  void useProgram();
private:
  GLuint program;
  std::vector<GLuint> shaders;
  bool ok;

  bool compileShader(const char* path, GLenum shaderType);
  GLuint loadShader(const char* path, GLenum shaderType);
  bool link();
  void printShaderInfoLog(GLuint shader);
  void printProgramInfoLog(GLuint program);
  void printInfoLog(const char* name, const char* error);
};

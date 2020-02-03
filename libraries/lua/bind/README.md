# Bind

Bind is a helper for binding C++ code to lua.

For more info on bind, please run:

    bazel run //libraries/lua/bind:gen_lua_cpp_binding -- --help
	
For a demo please run:

    bazel run //libraries/lua/bind:test.cpp --run_under bat
	
or 

    bazel run //libraries/lua/bind:test.h --run_under bat

## Usage

usage: `gen_lua_cpp_binding.py [-h] IN_FILE OUT_LOCATION OUT_BASENAME`

Parses Javadoc like statements in a C++ file and generates binding functions
to help call the functions in lua. Also outputs a metatable for linking purposes
generates a `{OUT_LOCATION}/{OUT_BASENAME}.cpp` and `{OUT_LOCATION}/{OUT_BASENAME}.h`

The .cpp file includes the contents of `{IN_FILE}` already, so you may use static
functions and will not need to include `{IN_FILE}` in your build.

javadoc functions are defined with `/** */`. rules are defined with `@lua-` statements
that each occupy their own line. Possible values are:

- `@lua-meta`
    -   specifies that this function is a low level lua linking function and can be
        directly included in the metatable. `@lua-name` still required.
- `@lua-name NAME`
    -   specifies the name this function will be called by from lua
- `@lua-arg NAME: TYPE`
    -   specifies an argument to the function. Ordering of these statements
        creates the order arguments will be accepted in.
- `@lua-return TYPE`
    -   specifies the type of value this function will return
- `@lua-constructor`
    -   specifies that this function is a constructor and the metatable should have
        `__index` set to the meta-indexer, which allows class-like use of instances

TYPE is one of the following patterns
- `string`
    - A simple heap-allocated C string
- `String`
    - A C++ stack allocated string
- `Class CTYPE [METATABLE_NAME]`
    - e.g. Class SDL_Surface Surface
    - e.g. Class Sprite Sprite
    - When this is a return TYPE, Lua only allocates the size of a pointer to
      the class
- `int`
    - a lua_Integer
- `number`
    - a lua_Number
- `Delete CTYPE`
    - Same as Class, but nulls the pointer after fetch, which is useful
      for functions in which you call `delete` on the returned pointer.
- `bool`
    - a boolean
- `Struct CTYPE [METATABLE_NAME]`
    - like class, but lua allocates the full size of this type onto the stack

positional arguments:
  `IN_FILE`       the input .cpp file
  `OUT_LOCATION`  the output directory
  `OUT_BASENAME`  output file basename

optional arguments:
  `-h`, `--help`    show this help message and exit

## Sample

Please see [test-src.cpp](./test-src.cpp)

INC=./headers
SRC=./source
LUA=third_party/lua/src
OBJS = $(patsubst %.cpp,%.o,$(wildcard $(SRC)/*.cpp))
CC = g++
LINKER_FLAGS = -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL_mixer -llua -ldl -lm
OBJ_NAME = main

ifneq (,$(findstring wasm,$(MAKECMDGOALS)))
OBJ_NAME = out/op12.html
LUAO=third_party/lua/lua.o
CC = emcc
EMFLAGS = -s USE_SDL=2 -s USE_SDL_TTF=2 -s USE_SDL_IMAGE=2 -s SDL2_IMAGE_FORMATS='["png"]' -s ALLOW_MEMORY_GROWTH=1
endif

CPPFLAGS = --std=c++11 -O2 -L$(LUA) -I$(LUA) -I$(INC) $(EMFLAGS)

all: $(OBJS)
	$(CC) $(OBJS) $(CPPFLAGS) $(LINKER_FLAGS) -o $(OBJ_NAME)
wasm: $(OBJS)
	mkdir -p out
	$(CC) $(OBJS) $(LUAO) $(CPPFLAGS) $(LINKER_FLAGS) -o $(OBJ_NAME) --preload-file resources/
clean:
	rm -f $(OBJS) $(wildcard *~) $(wildcard $(SRC)/*~) $(wildcard $(INC)/*~)
fclean:
	rm -f $(OBJS) $(OBJ_NAME) $(wildcard *~)
re:
	make clean all
format:
	clang-format -i $(shell find source/ headers/ -iname '*.[ch]pp')

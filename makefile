INC=./headers
SRC=./source
LUA=$(HOME)/lua/src
OBJS = $(patsubst %.cpp,%.o,$(wildcard $(SRC)/*.cpp))
CC = g++
CPPFLAGS = -L$(LUA) -I$(LUA) -I$(INC)
LINKER_FLAGS = -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer -llua -ldl -lm
OBJ_NAME = main
all: $(OBJS)
	$(CC) $(OBJS) $(CPPFLAGS) $(LINKER_FLAGS) -o $(OBJ_NAME)
clean:
	rm -f $(OBJS) $(wildcard *~) $(wildcard $(SRC)/*~) $(wildcard $(INC)/*~)
fclean:
	rm -f $(OBJS) $(OBJ_NAME) $(wildcard *~)
re:
	make clean all

CC = gcc
CFLAGS = -Wall -g

LIB_DIR = lib
BIN_DIR = bin

SOURCES = $(LIB_DIR)/game.c $(LIB_DIR)/input.c $(LIB_DIR)/render.c $(LIB_DIR)/term.c $(BIN_DIR)/main.c
OBJECTS = $(SOURCES:.c=.o)
TARGET = game

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -I $(LIB_DIR) -c $< -o $@

clean:
	rm -f $(LIB_DIR)/*.o $(BIN_DIR)/*.o $(TARGET)

.PHONY: all clean

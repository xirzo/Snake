#ifndef GAME_H
#define GAME_H

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef struct pos_t {
  size_t x;
  size_t y;
} pos_t;

typedef struct game_t {
  size_t **map;
  size_t width;
  size_t height;
  pos_t player_pos;
} game_t;

game_t *createGame(size_t width, size_t height);
void freeGame(game_t *g);

#endif 

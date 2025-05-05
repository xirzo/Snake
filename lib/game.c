#include "game.h"

game_t *createGame(size_t width, size_t height) {
  game_t *game = malloc(sizeof(game_t));
  game->map = malloc(height * sizeof(size_t *));
  for (size_t i = 0; i < height; i++) {
    game->map[i] = malloc(width * sizeof(size_t));
  }
  game->width = width;
  game->height = height;
  game->player_pos = (pos_t){.x = 0, .y = 0};
  return game;
}

void freeGame(game_t *g) {
  for (size_t i = 0; i < g->height; i++) {
    free(g->map[i]);
  }
  free(g->map);
  free(g);
}

#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

#include "game.h"
#include "render.h"
#include "term.h"
#include "input.h"

const size_t WIDTH = 100;
const size_t HEIGHT = 20;

int main(void) {
  initTerminal();

  game_t *game = createGame(WIDTH, HEIGHT);
  char *buffer = malloc(game->width * game->height);

  while (1) {
    drawGame(buffer, game);
    enum EInputType input = processInput();

    switch (input) {
    case UNKNOWN: {
      continue;
    }
    case QUIT: {
      fprintf(stdout, "quiting...\n");
      break;
    }
    case UP: {
      if (game->player_pos.y > 0) {
        game->player_pos.y -= 1;
      }
      continue;
    }
    case LEFT: {
      if (game->player_pos.x > 0) {
        game->player_pos.x -= 1;
      }
      continue;
    }
    case DOWN: {
      if (game->player_pos.y < game->height - 1) {
        game->player_pos.y += 1;
      }
      continue;
    }
    case RIGHT: {
      if (game->player_pos.x < game->width - 1) {
        game->player_pos.x += 1;
      }
      continue;
    }
    }

    break;
  }

  free(buffer);
  freeGame(game);
  restoreTerminal();
  return 0;
}

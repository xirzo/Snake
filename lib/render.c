#include "render.h"

const char EMPTY_CHAR = ' ';
const char PLAYER_CHAR = '#';

void clearScreen() {
#ifdef _WIN32
  system("cls");
#else
  printf("\033[H\033[J");
#endif
}

void clearBuffer(char *buffer, size_t width, size_t height) {
  memset(buffer, EMPTY_CHAR, width * height);
}

void drawGame(char *buffer, const game_t *game) {
  clearScreen();
  clearBuffer(buffer, game->width, game->height);

  buffer[game->player_pos.y * game->width + game->player_pos.x] = PLAYER_CHAR;

  for (size_t y = 0; y < game->height; y++) {
    for (size_t x = 0; x < game->width; x++) {
      putchar(buffer[y * game->width + x]);
    }
    putchar('\n');
  }
}

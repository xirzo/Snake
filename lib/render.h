#ifndef RENDER_H
#define RENDER_H

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "game.h"

void clearScreen();
void clearBuffer(char *buffer, size_t width, size_t height);
void drawGame(char *buffer, const game_t *game);

#endif

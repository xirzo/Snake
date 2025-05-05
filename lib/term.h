#ifndef TERM_H
#define TERM_H

#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>

void initTerminal();
void restoreTerminal();

#endif

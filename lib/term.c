#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>

struct termios initial_termios, new_termios;

void initTerminal() {
  tcgetattr(STDIN_FILENO, &initial_termios);
  new_termios = initial_termios;
  new_termios.c_lflag &= ~(ICANON | ECHO);
  tcsetattr(STDIN_FILENO, TCSANOW, &new_termios);
  fflush(stdout);
}

void restoreTerminal() {
  tcsetattr(STDIN_FILENO, TCSANOW, &initial_termios);
  fprintf(stdout, "terminal restored\n");
}

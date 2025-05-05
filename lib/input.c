#include "input.h"

enum EInputType {
  UNKNOWN,
  QUIT,
  UP,
  LEFT,
  DOWN,
  RIGHT,
};

enum EInputType processInput() {
  char ch = getchar();

  switch (ch) {
  case 'q': {
    return QUIT;
  }
  case 'w': {
    return UP;
  }
  case 'a': {
    return LEFT;
  }
  case 's': {
    return DOWN;
  }
  case 'd': {
    return RIGHT;
  }
  default: {
    return UNKNOWN;
  }
  }
}

#ifndef INPUT_H
#define INPUT_H

#include <stdio.h>

enum EInputType {
  UNKNOWN,
  QUIT,
  UP,
  LEFT,
  DOWN,
  RIGHT,
};

enum EInputType processInput();

#endif

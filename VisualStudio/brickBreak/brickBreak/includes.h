#pragma comment(lib, "RaspberryPI.lib")
#include <stdio.h>
#include <stdlib.h>
#include <RaspberryDLL.h>
#include <iostream>
#include <string>
#include "Position.h"

using namespace std;

#define stageHeight 20
#define stageWidth (stageHeight * 1.5) 
#define boardWidth 4
#define brickWidth 3
#define numberOfBricks 9*3
#define brickPositions 9*3

void stage(char y, char x, Position ball, Position board, Position bricks);
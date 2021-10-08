#include "includes.h"

int main(void)
{
	if (!Open())
	{
		printf("Error with connection\n");
		exit(1);
	}

	printf("Connected to Raspberry Pi\n");
	// To do your code

	char y = 1, x = 1, 
	startPositionBallX = 5, startPositionBallY = 5,
	startPositionBoardX = 5, startPositionBoardY = 5,
	startPositionBricksX = 1, startPositionBricsY = 1;

	Position ball(startPositionBallX, startPositionBallY);
	Position board(startPositionBoardX, startPositionBoardY);
	Position bricks(startPositionBricksX, startPositionBricsY);

	stage(y, x, ball, board, bricks);

	return 0;
}
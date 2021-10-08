#include "includes.h"

static string bricksLeft[numberOfBricks];
static int bricksLeftPosition[brickPositions];
static char t;

void border() {

	cout << endl;
	for (char n = 0; n < stageWidth; n++)
		cout << "* ";

}

void ballBorder(Position* board, Position* ball, Position* bricks, char* x, char* y) {

	if (ball->getPositionY() == stageHeight) {
		ball->printDeath();
		exit(1);
	}

	else if ((ball->getPositionY() == board->getPositionX() || ball->getPositionY() == board->getPositionX() + 1 || ball->getPositionY() == board->getPositionX() + 2 || ball->getPositionY() == board->getPositionX() + 3) && ball->getPositionY() == stageHeight - 1)
		*y = -1;

	else if (ball->getPositionY() == -3)
		*y = 1;

	if (ball->getPositionX() == stageWidth - 3)
		*x = -1;

	else if (ball->getPositionX() == 0)
		*x = 1;

	if (*y == 1)
		ball->setPositionY(ball->getPositionY() + 1);

	else if (*y == -1)
		ball->setPositionY(ball->getPositionY() - 1);

	if (*x == 1)
		ball->setPositionX(ball->getPositionX() + 1);

	else if (*x == -1)
		ball->setPositionX(ball->getPositionX() - 1);

	for (char n = 0, k = 5; n < numberOfBricks || bricksLeft[t] == "      "; n++) {
		if (ball->getPositionY() < 0 && bricksLeft[t] != "      ") {
			if (ball->getPositionX() >= bricksLeftPosition[n] && ball->getPositionX() < bricksLeftPosition[n + 5]) {
				bricksLeft[t] = "      ";
				t++;
				break;
			}

			if (n == k) {
				k += 5;
				t++;
			}

		}
	}
}		

void ballMovement(Position* ball) {

	for (char n = 0; n < stageHeight; n++) {
		cout << endl << "*";

		if (n == ball->getPositionY()) {
			for (char i = 0; i < stageWidth - 1; i++) {

				if (i == ball->getPositionX())
					cout << "*";
				else
					cout << "  ";
			}
			cout << "*";
			n++;

		}

		else {

			for (char k = 0; k < stageWidth - 2; k++) {

				cout << "  ";
				if (k == stageWidth - 3)
					cout << " *";

			}
		}
	}
}

void boardmovment(Position* board) {
	
	cout << endl;

	for (char n = 0; n < (stageWidth - boardWidth - 1); n++) {

		if (n == board->getPositionX()) {
			for (char i = 0; i < boardWidth; i++)
				cout << "*";
		}
		else
			cout << "  ";
	}

	for (int k = 0; k < 300; k++) {
		if (keyPressed(1)) {
			board->setPositionX(board->getPositionX() + (boardWidth / 2));
			Wait(1000);
			break;
		}

		else if (keyPressed(2)) {
			board->setPositionX(board->getPositionX() - (boardWidth / 2));
			Wait(1000);
			break;
		}
		Wait(1);
	}

}

void brickPosition(Position* bricks) {

	for (char m = 0; m < bricks->getPositionY(); m++) {
		cout << endl << "*";

		for (char q = 0; q < stageWidth - 2; q++) 
			cout << "  ";

		cout << " *";
	}

	for (char n = bricks->getPositionY(); n < (bricks->getPositionY() + 3); n++) {
		cout << endl << "*";

		for (char i = 0; i < stageWidth - 1; i++) {

			if (i == bricks->getPositionX()) {
				for (char k = 0; k <= (stageWidth / 4) + 1; k++) {
					cout << bricksLeft[k];
					i += 3;
				}
				cout << " ";
			}
			else
				cout << "  ";
		}
		cout << "*";

	}

}

void stage(char y, char x, Position ball, Position board, Position bricks) {

	for (char n = 0; n < numberOfBricks; n++)
		bricksLeft[n] = " **** ";
			
	for ( char n = 0; n < numberOfBricks; n++)
		bricksLeftPosition[n] = n;


	while (1) {

		border();
		brickPosition(&bricks);
		ballMovement(&ball);
		ballBorder(&board, &ball, &bricks, &x, &y);
		boardmovment(&board);
		

	}


}
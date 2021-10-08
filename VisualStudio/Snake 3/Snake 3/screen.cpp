#include "screen.h"

void border() {

	char n;

	cout << endl;

	for (n = 0; n < arraySize; n++)
		cout << "* ";

}

void screen() {

	int n, i, q1 = 0, q2 = SIZE, k, z = 0;
	int snakeSize = 4, length = 4, startPosition = 2, lastPositionX = startPosition, lastPositionY = startPosition, position = startPosition, direction = 3, directionSwitch;
	int positionX[arraySize], positionY[arraySize], positionMid[arraySize], snakePosition;

	for (k = 0; k < arraySize; k++) {
		positionX[k] = -1;
		positionY[k] = -1;
	}

	for (k = startPosition; k < (startPosition + 4); k++) {
		if (direction == 1 || direction == 2)
			positionX[startPosition + k] = startPosition;

		else if (direction == 3 || direction == 4)
			positionX[startPosition] = startPosition;

		positionY[startPosition + k] = startPosition;
	}

	while (1) {

		border();

		for (i = 0; i < arraySize; i++) {

			cout << endl << "*";

			if (positionX[i] != -1 && (direction == 3 || direction == 4)) {

				if (positionX[lastPositionY] == SIZE - snakeSize) {
					cout << " *";
					for (n = 0; n < (positionX[i] - 3); n++)
						cout << "  ";
				}
				else if (positionX[lastPositionY] == SIZE - snakeSize + 1) {
					cout << " * *";
					for (n = 0; n < (positionX[i] - 4); n++)
						cout << "  ";
				}

				else if (positionX[lastPositionY] == SIZE - snakeSize + 2) {
					cout << " * * *";
					for (n = 0; n < (positionX[i] - 6); n++)
						cout << "  ";
				}

				else {
					for (n = 0; n < (positionX[i]); n++)
						cout << "  ";
				}

			}

			else {
				for (n = 0; n < (positionX[i]); n++)
					cout << "  ";
			}

			if (positionY[i] != -1 && (direction == 1 || direction == 2)) {
				cout << "*";
				for (; n < (arraySize - 2); n++)
					cout << "  ";
			}

			else if (positionX[i] != -1 && (direction == 3 || direction == 4)) {

				if (positionX[lastPositionY] == SIZE - snakeSize)
					cout << "* * *  ";
				else if (positionX[lastPositionY] == SIZE - snakeSize + 1)
					cout << "* *  ";
				else if (positionX[lastPositionY] == SIZE - snakeSize + 2)
					cout << "*  ";

				else if (positionX[lastPositionY] == SIZE - snakeSize + 3)
					cout << " ";

				else
					cout << "* * * *";

				for (; n < (arraySize - snakeSize - 1); n++)
					cout << "  ";

			}

			else {
				for (; n < (arraySize - 2); n++)
					cout << "  ";
				if (n = 1)
					cout << " ";
			}

			cout << "*";

		}

		border();

		for (k = 0; k < 250; k++) {

			if (keyPressed(1) && switchOn()) {
				direction = 1;
				lastPositionY = position;
			}

			else if (keyPressed(2) && switchOn()) {
				direction = 2;
				lastPositionY = position;
			}

			else if (keyPressed(1)) {
				direction = 3;
				lastPositionX = position;
			}

			else if (keyPressed(2)) {
				direction = 2;
				lastPositionX = position;
			}

		}

		if (direction == 1) {

			position++;
			cout << position;
			for (k = 0; k < arraySize; k++) {
				positionY[k] = -1;
				positionX[k] = lastPositionX;
			}

			for (k = position; k < (position + snakeSize); k++) {

				if (position < SIZE)
					positionY[k] = position;

			}

			if (position > SIZE - snakeSize) {
				for (k = 0; k < q1; k++)
					positionY[k] = k;
				q1++;

				if (position == arraySize)
					position = 0;

			}

		}

		else if (direction == 2) {

			position--;
			cout << position;
			for (k = 0; k < arraySize; k++) {
				positionY[k] = -1;
				positionX[k] = lastPositionX;
			}

			for (k = position + snakeSize; k > position; k--) {

				if (k >= 0)
					positionY[k] = k;

			}

			if (position < 0) {
				for (k = SIZE; k > q2; k--)
					positionY[k] = k;
				q2--;

				if (position == -snakeSize)
					position = arraySize - snakeSize;

			}

		}

		else if (direction == 3) {

			position++;
			cout << position;

			for (k = 0; k < arraySize; k++) 
				positionX[k] = -1;
			
			positionX[lastPositionY] = position;


			if (positionX[lastPositionY] == SIZE - snakeSize + 3)
				position = 0;

		}

	}

}
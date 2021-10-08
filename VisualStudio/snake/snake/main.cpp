#include <iostream>
#include <string>
#include <conio.h>
#include <Windows.h>

#define SIZE 20

using namespace std;

class Snake {

public:


private:


};

void border() {
	
	char n;

	cout << endl;

	for (n = 0; n < SIZE; n++)
		cout << "* ";

}

void screen() {

	char n, i;
	int position[SIZE], snakePosition;

	for (int k = 0; k < SIZE; k++)
		position[k] = -1;

	while (1) {

		cin >> snakePosition;

		border();

		position[snakePosition] = snakePosition;

		for (i = 0; i < SIZE; i++) {

			if (position[i] != -1) {

				cout << endl << "*";

				for (n = 0; n < (position[i]); n++)
					cout << "  ";

				cout << "*";

				for (n; n < (SIZE - 2); n++)
					cout << "  ";

				cout << "*";

			}

			else {

				cout << endl << "*";

				for (n = 0; n < (SIZE - 2); n++)
					cout << "  ";

				cout << " *";

			}

		}

		border();

	}

}

int main() {

	screen();

}
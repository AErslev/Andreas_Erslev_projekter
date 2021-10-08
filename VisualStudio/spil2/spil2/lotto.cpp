#include <iostream>
#include <string>
#include <iomanip>
#include <Windows.h>
#include "ur.h"
#include <time.h>

#define SIZE 6

int lotto() {

	string name, spilLotto;
	int  udtraekning, i = 0, price = 0, rigtgeTal = 0;
	int lottoTal[SIZE], lottoCheck[SIZE], brugerLottoTal[SIZE], rigtige[SIZE];

	srand(time(0));

	for (int n = 0; n < 6; n++) {
		udtraekning = rand() % 9 + 1;
		lottoTal[n] = udtraekning;
		lottoCheck[n] = udtraekning;
	}

	cout << "Choose your 6 lotto numbers.\nYou may only use numbers 0-9:" << endl;

	for (int n = 0; n < 6; n++) {

		cout << "  -  ";
		cin >> brugerLottoTal[n];

	}

	for (int n = 0; i < 6; n++) {

		if (lottoCheck[n] == brugerLottoTal[i]) {
			rigtige[i] = brugerLottoTal[i];
			lottoCheck[n] = 0;
			n = 0; i++;
		}

		else if (n == 5) {
			rigtige[i] = 0;
			n = 0;  i++;
		}

	}

	cout << "\nThe numbers are: " << endl;

	for (int n = 0; n < 6; n++) {

		cout << lottoTal[n] << " ";

	}

	cout << "\n\nYou correct numbers: " << endl;

	for (int n = 0; n < 6; n++) {

		if (rigtige[n] != 0) {
			rigtgeTal++;
			cout << rigtige[n] << " ";
		}

	}

	if (rigtgeTal == 3) {
		price = rand() % 1000 + 1;

		cout << "Congratulation, you won " << price << "$\n" << endl;
	}

	else if (rigtgeTal == 4) {
		price = rand() % 100000 + 1;

		cout << "Congratulation, you won " << price << "$\n" << endl;
	}

	else if (rigtgeTal == 5) {
		price = rand() % 1000000 + 1;

		cout << "Congratulation, you won " << price << "$\n" << endl;
	}

	else if (rigtgeTal == 6) {
		price = rand() % 100000000 + 1;

		cout << "Congratulation, you won " << price << "$\n" << endl;
	}

	else
		cout << "Too bad, you didnt win anything this time. Try again another time!" << "\n" << endl;

	cout << "\n" << endl;

	return price;

}
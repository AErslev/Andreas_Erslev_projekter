#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

/*	const int antal;
	int i, type, antalTilbage, sortere[antal];
	float tilsvarende = 0, modstand, tidligereModstand = 0, tal1, tal2;*/

#define SIZE 100

int main(void) {

	srand(time(0));

	int i, x, temp, numbers[SIZE], antal = SIZE, valg, deci = 0;

	printf_s("Vil du indskrive op til 100 tal, eller vil du have en raekke tilfaeldige tal (mellem 0 og 1000) sorteret? \nTast 1 for selv at vaelge og 2 for en tilfaeldig raekke tal: ");
	scanf_s("%d", &valg);

	switch (valg) {

	case 1: 
		printf_s("Hvor mange tal vil du sortere? Du kan sortere op til 100 tal: ");
		scanf_s("%d", &antal);

		if (antal > 100) {
			printf_s("Du har intastet for mange tal til sortering. Tallet skal være mellem 1 og 100. Proev igen.");
		}

		else if (antal < 1) {
			printf_s("Du har indtastet et 0 eller et negativt tal. Tallet skal være mellem 1 og 100. Proev igen.");
		}

		printf("\nIndtast dit foerste tal: ");

		for (i = 0; i < antal; i++) {

			scanf_s("%d", &numbers[i]);

			if (i < antal - 1) {
				printf("\nDu har indtastet: %d tal \n", i + 1);
				printf("Indtast dit naeste nummer: ");
			}

			else {
				printf_s("\nDu har indtastet %d tal i alt \nHer ser du dine tal sorteret fra hoejest til lavest: \n", i + 1);
			}

		}

		break;

	case 2:

		for (size_t n = 0; n < SIZE; n++) {

			x = rand() % 1000;
			numbers[n] = x;

			for (size_t i = 0; i < SIZE; i++) {

				if (numbers[n] == numbers[i] && i != n) {

					x = rand() % 1000;
					numbers[n] = x;

					i = -1;

				}

			}

		}

		break;

	default:

		printf_s("\nDu har indtastet en forkert vaerdi. Farvel\n");

		return 0;

	}


	for (size_t n = 0; n < SIZE; n++) {

		if (numbers[n] < numbers[n + 1]) {

			temp = numbers[n];
			numbers[n] = numbers[n + 1];
			numbers[n + 1] = temp;
			n = -1;

		}

	}

	if (valg == 1) {
		for (i = 0; i < antal; i++)
			if (i < antal - 1) {
				printf_s("%d : ", numbers[i]);
			}

			else {
				printf_s("%d", numbers[i]);
			}
	}

	else {

		for (i = 0; i < antal / 20; i++) {

			for (int y = 0; y < 20 && deci < antal; y++) {

				printf_s("%d   ", numbers[deci]); deci++;

			}

			printf_s("\n---------------------------------------------------------------------------------------------------------------\n");

		}

	}

	printf_s("\n\n");

	return 0;
}

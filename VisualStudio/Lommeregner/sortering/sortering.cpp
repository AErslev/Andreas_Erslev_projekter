#include <stdio.h>
#include <math.h>

/*	const int antal;
	int i, type, antalTilbage, sortere[antal];
	float tilsvarende = 0, modstand, tidligereModstand = 0, tal1, tal2;*/

int main(void)
{

	printf_s("Hvor mange tal vil du sortere? Du kan sortere op til 100 tal: ");
	int antal; scanf_s("%d", &antal);

	if (antal > 100) {
		printf_s("Du har intastet for mange tal til sortering. Tallet skal være mellem 1 og 100. Proev igen.");
	}

	else if (antal < 1) {
		printf_s("Du har indtastet et 0 eller et negativt tal. Tallet skal være mellem 1 og 100. Proev igen.");
	}

	printf("\nIndtast dit foerste tal: ");

	int i, n, maximum, numbers[100];

	for (i = 0; i < antal; i++)
	{

		scanf_s("%d", &numbers[i]);

		if (i < antal - 1) {
			printf("\nDu har indtastet: %d tal \n", i + 1);
			printf("Indtast dit naeste nummer: ");
		}

		else {
			printf_s("\nDu har indtastet %d tal i alt \nHer ser du dine tal sorteret fra hoejest til lavest: \n", i + 1);
		}

	}

	for (i = 0; i < antal; i++) {

		maximum = numbers[0];

		for (n = 1; n <= antal; n++) {


			if (numbers[n] > maximum)
			{
				maximum = numbers[n];
			}

		}

		for (n = 0; n < antal; n++) {

			if (maximum == numbers[n]) {
				numbers[n] = 0;
				break;
			}

		}

		if (i < antal - 1) {
			printf_s("%d : ", maximum);
		}

		else {
			printf_s("%d", maximum);
		}

	}

	printf_s("\n\n");

	return 0;
}

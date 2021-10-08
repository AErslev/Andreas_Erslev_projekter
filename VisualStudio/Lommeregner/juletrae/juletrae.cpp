#include <stdio.h>
#include <math.h>

int main(void) {

	int i, n, k, antal;

	printf_s("Hvor højt skal dit juletrae vaere? ");
	scanf_s("%d", &antal);

	for (i = 0; i < antal; i++) {

		for (n = antal - i; n > 0; n--) {

			printf_s(" ");

		}

		for (k = 0; k <= i; k++) {

			printf_s("*");

		}

		for (k = 0; k < i; k++) {

			printf_s("*");

		}

		printf_s("\n");

	}

	for (i = 0; i < antal / 4; i++) {

		for (n = antal - antal / 2; n > 0; n--) {

			printf_s(" ");

		}

		for (k = 0; k < antal; k++) {

			printf_s("*");
			
		}

		printf_s("\n");

	}

	return 0;
}
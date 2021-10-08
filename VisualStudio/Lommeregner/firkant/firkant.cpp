#include <stdio.h>

int main(void) {

	int antalr, antalk, mellemrum, n, i, hul;

	printf_s("Hvor mange raekker oensker du i din firkant?");
	scanf_s("%d", &antalr);

	printf_s("Hvor mange koloner oensker du i din firkant?");
	scanf_s("%d", &antalk);

	printf_s("\n\nSkal firkanten vaere hul eller fyldt?\nTast 1 for hul og 0 for fyldt: ");
	scanf_s("%d", &hul);

	printf_s("\n");

	if (hul == 0) {
		for (i = 0; i < antalr; i++) {

			for (n = 0; n < antalk; n++) {

				printf_s("* ");

			}

			printf_s("\n");

		}
	}

	else {

		for (n = 0; n < antalk; n++) {

			printf_s("* ");

		}

		printf_s("\n");

		for (i = 0; i < antalr - 2; i++) {

			printf_s("* ");

			for (n = 0; n < antalk; n++) {

				printf_s(" ");

			}

			printf_s(" * \n");

		}

		for (n = 0; n < antalk; n++) {

			printf_s("* ");

		}

	}


	return 0;
}
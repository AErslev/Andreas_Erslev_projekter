/*Ikke fuldt opdateret, virker dog*/

#include <stdio.h>
#include <math.h>

int main(void) {

	int antal, i, type, antalTilbage;
	float tilsvarende = 0, modstand, tidligereModstand = 0;

	printf_s("Hvor mange modstande vil du regne med? "); scanf_s("%d", &antal); antalTilbage = antal;

	printf_s("\nVil du udregne serie- eller parallelforbindelse?\nTast 0 for serie og 1 for parallel, tast 2 for begge\n\n");
	scanf_s("%d", &type);

	printf_s("Skriv foerste vaerdi af modstandende ");

	for (i = 0; i < antal; i++) {

		if (type == 1) {

			if (tidligereModstand == 0) {

				scanf_s("%f", &modstand); tilsvarende = 1 / ( (1 / modstand) ); printf_s("\nDin valgte modstand var: %f\n", modstand);
				tidligereModstand += 1 / modstand;
				printf_s("Den nuvaerende tilsvarende modstand er: %f\n", tilsvarende);
				--antalTilbage;

			}

			else {

				scanf_s("%f", &modstand); tilsvarende = 1 / (tidligereModstand + (1 / modstand)); printf_s("\nDin valgte modstand var: %f\n", modstand);
				tidligereModstand += 1 / modstand;
				printf_s("Den nuvaerende tilsvarende modstand er: %f\n", tilsvarende);
				--antalTilbage;

			}

			if (i != antal - 1) {
				printf_s("Du har %d modstande tilbage at saette i parallelforbindelse \n\n", antalTilbage);
				printf_s("Indtast den naeste modstand: ");
			}

		}


	}

	return 0;
}
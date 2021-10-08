/*Ikke fuldt opdateret, virker dog*/

#include <stdio.h>
#include <math.h>
#include <time.h> 

/*VENTETID SCRIPT*/
void delay(int number_of_seconds)
{
	// Converting time into milli_seconds 
	int milli_seconds = 1000 * number_of_seconds;

	// Stroing start time 
	clock_t start_time = clock();

	// looping till required time is not acheived 
	while (clock() < start_time + milli_seconds);
}
/*VENTETID AFSLUTNING*/

int main(void) {

	//Velkomst
	printf_s("Velkommen til lommeregneren.\n");
	int valg = 0, valg2 = 1, antal, i, antalTilbage, en = 1, foerste, type, slet;
	float sum = 0, tal, tal2, tabel1, tabel2 = 1, tilsvarende = 0, modstand, tidligereModstand = 0, resultat;

	/*LOOP*/
	do {

		/*INTRO*/
		do {

			if (valg2 == 1) {

				printf_s("\nVil du: \n\n");
				printf_s("- Plusse (+): tast 1 \n");
				printf_s("- Minuse (-): tast 2 \n");
				printf_s("- Gange (*): tast 3 \n");
				printf_s("- Dividere (/): tast 4 \n");
				printf_s("- Tabel: tast 5 \n");
				printf_s("- Parallel- eller seriemodstande: tast 6 \n");
				/*!n, firkant*/
				/*kvadratrod, kvadrere*/

				printf_s("\nTast 0 for at afslutte \n\n");

				printf_s("Dit valg: "); scanf_s("%d", &valg);

			}

			if (valg != 1 && valg != 2 && valg != 3 && valg != 4 && valg != 5 && valg != 6 && valg != 0) {

				printf_s("\nDu har indtastet et ugyldigt tal. Proev igen!\n\n");

			}

		} while (valg != 1 && valg != 2 && valg != 3 && valg != 4 && valg != 5 && valg != 6 && valg != 0);
		/*INTRO AFSLUTNING*/

		/*ANTAL*/
		if (valg == 1 || valg == 2 || valg == 3 || valg == 4) {

			printf_s("\nHvor mange tal vil du regne med: "); scanf_s("%d", &antal);
			printf_s("\nDu regner med %d tal\n\n", antal);
			antalTilbage = antal;

		}

		else if (valg == 5) {

			printf_s("\nHvilken tabel vil du gerne have vist? "); scanf_s("%f", &tabel1);
			printf_s("\nDu for vist %f tabellen\n\n", tabel1);

		}

		else if (valg == 6) {

			printf_s("\nHvor mange modstande vil du regne med? "); scanf_s("%d", &antal); antalTilbage = antal;

			printf_s("\nVil du udregne serie- eller parallelforbindelse?\nTast 1 for serie og 2 for parallel ");
			scanf_s("%d", &type);

			printf_s("\nSkriv foerste vaerdi af modstandende ");

		}
		/*ANTAL AFSLUTNING*/

		/*SELVE LOMMEREGNEREN*/
		switch (valg) {
		
		/*PLUS*/
		case 1:

			printf_s("Indtast dit foerste tal: ");

			for (i = 0; i < antal; i++) {

				scanf_s("%f", &tal); sum += tal; printf_s("\nDit valgte tal var: %f\n", tal);
				printf_s("Din nuvaerende sum er: %f\n", sum);
				--antalTilbage;


				if (i != antal - 1) {
					printf_s("Du har %d tal tilbage at regne med \n\n", antalTilbage);
					printf_s("Indtast naeste tal: ");
				}

			}

			break;
		/*PLUS AFSLUTNING*/
		
		/*MINUS*/
		case 2:

			printf_s("Indtast dit foerste tal: ");

			for (i = 0; i < antal; i++) {

				scanf_s("%f", &tal); sum -= tal; printf_s("\nDit valgte tal var: %f\n", tal);
				printf_s("Din nuvaerende sum er: %f\n", sum);
				--antalTilbage;


				if (i != antal - 1) {
					printf_s("Du har %d tal tilbage at regne med \n\n", antalTilbage);
					printf_s("Indtast naeste tal: ");
				}

			}

			break;
		/*MINUS AFSLUTNING*/

		/*GANGE*/
		case 3:

			printf_s("Indtast dit foerste tal: ");

			if (sum == 0) {

				sum += en;

			}

			for (i = 0; i < antal; i++) {

				scanf_s("%f", &tal); sum *= tal; printf_s("\nDit valgte tal var: %f\n", tal);
				printf_s("Din nuvaerende sum er: %f\n", sum);
				--antalTilbage; 

				if (i != antal - 1) {
					printf_s("Du har %d tal tilbage at regne med \n\n", antalTilbage);
					printf_s("Indtast naeste tal: ");
				}

			}

			break;
		/*GANGE AFSLUTNING*/

		/*DIVISION*/
		case 4:
				
			foerste = 1;
			for (i = 0; i < antal; i++) {
				
				if (sum == 0) {
					printf_s("Indtast dit foerste tal: "); scanf_s("%f", &tal);
					sum = tal/1; printf_s("\nDit valgte tal var: %f\n", tal);
					printf_s("Din nuvaerende sum er: %f\n", sum);
					--antalTilbage; printf_s("Du har %d tal tilbage at regne med \n\n", antalTilbage);
					foerste--;

				}

				else {
				
					if (foerste == 1) {

						printf_s("Indtast dit foerste tal: "); scanf_s("%f", &tal);

					}
					scanf_s("%f", &tal);
					sum /= tal; printf_s("\nDit valgte tal var: %f\n", tal);
					printf_s("Din nuvaerende sum er: %f\n", sum);
					--antalTilbage; 
				}

				if (i != antal - 1) {
					printf_s("Du har %d tal tilbage at regne med \n\n", antalTilbage);
					printf_s("Indtast naeste tal: ");
				}


			}

			break;
		/*DIVISION AFSLUTNING*/

		/*TABEL*/
		case 5: 

			for (i = 1; i <= 10; i++) {

				tabel2 = i * tabel1;
				printf_s("- %f \n", tabel2);

				delay(1);

			}

			printf_s("\n\n");

			break;
		/*TABEL AFSLUTNING*/

		/*MODSTANDE*/
		case 6:

			for (i = 0; i < antal; i++) {

				if (type == 2) {

					if (tidligereModstand == 0) {

						scanf_s("%f", &modstand); tilsvarende = 1 / ((1 / modstand)); printf_s("\nDin valgte modstand var: %f\n", modstand);
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

				else if (type == 1) {

					scanf_s("%f", &modstand); tilsvarende += modstand; printf_s("\nDin valgte modstand var: %f\n", modstand);
					printf_s("Den nuvaerende tilsvarende modstand er: %f\n", tilsvarende);
					--antalTilbage;

					if (i != antal - 1) {
						printf_s("Du har %d modstande tilbage at saette i serieforbindelse \n\n", antalTilbage);
						printf_s("Indtast den naeste modstand: ");
					}

				}

			}

			break;
		/*MODSTANDE AFSLUTNING*/

		//UDGANG
		case 0:

			break;

		}

		/*FORTSÆT ELLER AFSLUT*/
		if (valg == 1 || valg == 2 || valg == 3 || valg == 4) {

			printf_s("\nDin sum efter din udregning er: %f \n\n", sum);

		}

		else if (valg == 6) {

			printf_s("\nDin endelige tilsvarende modstand er: %f \n\n", tilsvarende);

		}

		if (valg != 0) {
			printf_s("Vil du forsaette med at regne, eller vil du stoppe? \nTast 1 for at forsaette eller 0 for at stoppe: ");
			scanf_s("%d", &valg2);
		}

		if (valg2 == 0) {

			valg = 0;

		}

		if (valg != 0) {

			printf_s("\nVil du slette din sum / tilsvarende modstand? \nTast 1 for at slette ellers tast 2: ");
			scanf_s("%d", &slet);

			if (slet == 1) {

				sum = 0;
				tilsvarende = 0;

			}

		}
		/*FORTSÆT ELLER AFSLUT AFSLUTNING*/

	} while (valg != 0);
	/*LOOP AFSLUTNING*/

	//FARVEL
	printf_s("\nTak fordi du brugte os som din lommeregner. Vi haaber snart vi ser dig igen!\n");

	return 0;

}
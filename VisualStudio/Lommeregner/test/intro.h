int intro() {

	int valg;

	/*INTRO*/
	do {

		printf_s("\n\nVil du: \n\n");
		printf_s("- Plusse (+): tast 1 \n");
		printf_s("- Minuse (-): tast 2 \n");
		printf_s("- Gange (*): tast 3 \n");
		printf_s("- Dividere (/): tast 4 \n");
		printf_s("- Potens (^): tast 5 \n");
		printf_s("- Kvadratrod: tast 6 \n");
		printf_s("- Kubikrod: tast 7 \n");
		printf_s("- Udregn en fakultet: tast 8 \n");
		printf_s("- Udregne parallel- eller seriemodstande: tast 9 \n");
		printf_s("- Se en valgfri tabel: tast 10 \n");
		printf_s("- Sortere en raekke tal: tast 11 \n");
		printf_s("- Lav en firkant: tast 12 \n");
		printf_s("- Lav et juletrae: tast 13 \n");

		printf_s("\nTast 0 for at afslutte \n\n");

		printf_s("Dit valg: "); scanf_s("%d", &valg);

		if (valg < 0 || valg > 13) {

			printf_s("\nDu har indtastet et ugyldigt tal. Proev igen!\n");

		}

	} while (valg < 0 || valg > 13);

	return valg;
}
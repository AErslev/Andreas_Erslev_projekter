float modstand(float resultat) {

	int antal, i, antalTilbage, type, fortsaet;
	float modstand, tidligereModstand = 0;

	printf_s("\nVil du udregne serie- eller parallelforbindelse?\nTast 1 for serie og 2 for parallel ");
	scanf_s("%d", &type);

	do {
	
		printf_s("Hvor mange modstande vil du regne med? "); scanf_s("%d", &antal); antalTilbage = antal;

		printf_s("\nSkriv foerste vaerdi af modstandende ");


		for (i = 0; i < antal; i++) {

			if (type == 2) {

				if (resultat == 0) {

					scanf_s("%f", &modstand); resultat = 1 / ((1 / modstand));
					printf_s("\nDin valgte modstand var: %.2f\n", modstand);
					tidligereModstand += 1 / modstand;
					--antalTilbage;

				}

				else {

					scanf_s("%f", &modstand); resultat = 1 / (tidligereModstand + (1 / modstand));
					printf_s("\nDin valgte modstand var: %.2f\n", modstand);
					tidligereModstand += 1 / modstand;
					--antalTilbage;

					printf_s("Den nuvaerende tilsvarende modstand er: %.2f\n", resultat);

				}

				if (i != antal - 1) {
					printf_s("Du har %d modstande tilbage at saette i parallelforbindelse \n\n", antalTilbage);
					printf_s("Indtast den naeste modstand: ");

				}



			}



			else if (type == 1) {

				scanf_s("%f", &modstand); resultat += modstand; printf_s("\nDin valgte modstand var: %.2f\n", modstand);
				--antalTilbage;

				if (i != antal - 1) {
					printf_s("Den nuvaerende tilsvarende modstand er: %.2f\n", resultat);
					printf_s("Du har %d modstande tilbage at saette i serieforbindelse \n\n", antalTilbage);
					printf_s("Indtast den naeste modstand: ");
				}

				fortsaet = 0;

			}

		}

		if (type == 2) {
			printf_s("\nVil du laegge en eller flere seriemodstande til? \nTast 1 for ja og 0 for nej: ");
			scanf_s("%d", &fortsaet); 
			type = 1;
		}

	} while (fortsaet != 0);

	return resultat;
}
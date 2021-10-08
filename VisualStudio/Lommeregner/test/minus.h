int minus(float resultat) {

	int antal, i, antalTilbage;
	float tal;

	printf_s("\nHvor mange tal vil du regne med: "); scanf_s("%d", &antal);
	printf_s("Du regner med %d tal\n\n", antal);
	antalTilbage = antal;

	printf_s("Indtast dit foerste tal: ");

	for (i = 0; i < antal; i++) {

		scanf_s("%f", &tal); printf_s("\n%.2f - %.2f ", resultat, tal);
		resultat -= tal; printf_s("= %.2f\n", resultat);
		--antalTilbage;

		if (i != antal - 1) {
			printf_s("Dit nuvaerende resultat er: %.2f\n", resultat);
			printf_s("Du har %d tal tilbage at regne med \n\n", antalTilbage);
			printf_s("Indtast naeste tal: ");
		}

	}

	return resultat;
}

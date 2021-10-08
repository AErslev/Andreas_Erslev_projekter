float potens(float resultat) {

	int antal, i, antalTilbage;
	float tal1, tal2 = 0, tal3 = 0;

	printf_s("Indtast grundtalet: "); scanf_s("%f", &tal1);
	printf_s("Dit valgte grundtal var: %.2f", tal1);

	printf_s("\n\nHvor mange eksponenter vil du regne med? ");
	scanf_s("%d", &antal); antalTilbage = antal;

	if (antal == 1) {
		printf_s("\nIndtast eksponenten: ");
		scanf_s("%f", &tal2);
		printf_s("%.2f ^ %.2f ", tal1, tal2);
		resultat = pow(tal1, tal2); printf_s("= %.2f\n", resultat);

	}

	else {
		printf_s("Du regner med %d eksponenter\n", antal);
		printf_s("\nIndtast foerste eksponent: ");

		for (i = 0; i < antal; i++) {

			scanf_s("%f", &tal2); tal3 += tal2;
			printf_s("\n%.2f ^ %.2f ", tal1, tal3);
			resultat = pow(tal1, tal3); printf_s("= %.2f\n", resultat);
			--antalTilbage;


			if (i != antal - 1) {
				printf_s("Dit nuvaerende resultat er: %.2f\n", resultat);
				printf_s("\nDu har %d tal tilbage at regne med \n\n", antalTilbage);
				printf_s("Indtast naeste eksponent: ");
			}

		}

	}


	return resultat;

}
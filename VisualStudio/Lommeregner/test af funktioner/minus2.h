int valg = 0, valg2 = 1, antal, i, antalTilbage, en = 1, foerste, type, slet;
float sum = 0, tal, tal2, tabel1, tabel2 = 1, tilsvarende = 0, modstand, tidligereModstand = 0, resultat;

int plus() {

	printf_s("\nHvor mange tal vil du regne med: "); scanf_s("%d", &antal);
	printf_s("\nDu regner med %d tal\n\n", antal);
	antalTilbage = antal;


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

	return sum;

}
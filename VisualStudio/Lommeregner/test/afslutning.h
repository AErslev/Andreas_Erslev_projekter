float afslutning(int valg, float resultat){
	

	if (valg > 0 && valg < 8) {
		printf_s("Dit endelige resultat blev: %.2f", resultat);
	}

	else if (valg == 9) {
		printf_s("Din endelige tilsvarende modstand blev: %.2f", resultat);

	}

	if (valg != 0) {
		printf_s("\n\n-------------------\n\nVil du forsaette med at regne, eller vil du stoppe? \nTast 1 for at forsaette eller 0 for at stoppe: ");
		scanf_s("%d", &valg);
	}

	return valg;

}
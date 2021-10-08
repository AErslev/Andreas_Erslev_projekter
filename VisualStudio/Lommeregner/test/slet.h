float slet(int valg, float resultat) {

	int slet;

	printf_s("\nVil du slette dit nuvaerende resultat \nTast 1 for ja og 0 for nej: ");
	scanf_s("%d", &slet);

	if (slet == 1) {

		resultat = 0;

	}

	printf_s("\n-------------------");

		return resultat;
}
float kvadratrod(float resultat) {

	float tal;

	printf_s("Valg hvlket tal du vil tage kvadratroden af: "); scanf_s("%f", &tal);
	printf_s("Dit valgte tal var: %.2f\n\n", tal);

	resultat = sqrt(tal);

	return resultat;
}

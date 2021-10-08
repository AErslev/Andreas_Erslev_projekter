float kubikrod(float resultat) {

	float tal;

	printf_s("Valg hvlket tal du vil tage kubikroden af: "); scanf_s("%f", &tal);
	printf_s("Dit valgte tal var: %.2f\n\n", tal);

	resultat = cbrt(tal);

	return resultat;
}
#pragma once

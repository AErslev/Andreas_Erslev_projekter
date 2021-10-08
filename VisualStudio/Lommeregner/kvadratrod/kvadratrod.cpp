#include <stdio.h>
#include <math.h>

int main(void) {

	float tal, resultat;

	printf_s("Valg hvlket tal du vil tage kvadratroden af:"); scanf_s("%f", &tal);
	printf_s("Dit valgte tal var: %.2f", tal);

	resultat = sqrt(tal);

	return resultat;
}

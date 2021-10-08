#include <stdio.h>
#include <math.h>

int main(void) {

	int valg, i, slet;
	float resultat, tal1, tal2;

	printf_s("Indtast grundtalet: "); scanf_s("%f", &tal1);
	printf_s("\nDit valgte grundtal var: %f\n", tal1);
	printf_s("Indtast eksponenten: "); scanf_s("%f", &tal2);
	printf_s("\nDin valgte eksponent var: %f\n", tal1);

	resultat = pow(tal1, tal2);

	return resultat;

}
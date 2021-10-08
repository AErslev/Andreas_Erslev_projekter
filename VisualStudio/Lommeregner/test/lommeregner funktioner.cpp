#include <stdio.h>
#include <stdlib.h>
#include "include.h"
#include "lommeregner.h"

int main(void) {

	//Velkomst
	printf_s("Velkommen til lommeregneren.\n-------------------");
	int valg;
	float resultat = 0;

	//Lommeregner
	do {

		valg = intro();

		resultat = lommeregner(valg, resultat);

		/*FORTSÆT?*/

		valg = afslutning(valg, resultat); 

		/*FORTSÆT? AFSLUTNING*/

		/*SLET?*/
		if (valg > 0 && valg < 8 || valg == 9) {

			resultat = slet(valg, resultat);

		}
		/*SLET? AFSLUTNING*/

	} while (valg != 0);

	//FARVEL
	printf_s("\n-------------------\nTak fordi du brugte os som din lommeregner. Vi haaber snart vi ser dig igen!\n");

	return 0;

}
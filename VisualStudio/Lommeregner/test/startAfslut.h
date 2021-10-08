int start() {

	int valg, slet;
	float resultat = 0, tilsvarende = 0, tilsvarendeModstand = 0, sum = 0;

	valg = intro();

	/*SELVE LOMMEREGNEREN*/
	switch (valg) {

		/*PLUS*/
	case 1:
		printf_s("Du valgte at plusse!\n\n-------------------\n");
		resultat = plus();

		break;
		/*PLUS AFSLUTNING*/

		/*MINUS*/
	case 2:
		printf_s("Du valgte at minusse!\n\n-------------------\n");
		resultat = minus();

		break;
		/*MINUS AFSLUTNING*/

		/*GANGE*/
	case 3:
		printf_s("Du valgte at gange!\n\n-------------------\n");
		resultat = gange();

		break;
		/*GANGE AFSLUTNING*/

		/*DIVISION*/
	case 4:
		printf_s("Du valgte at dividere!\n\n-------------------\n");
		resultat = dividere();

		break;
		/*DIVISION AFSLUTNING*/

		/*POTENS*/
	case 5:
		printf_s("Du valgte potens!\n\n-------------------\n");
		resultat = potens();
		/*POTENS AFSLUTNING*/

		break;

		/*KVADRATROD*/
	case 6:
		printf_s("Du valgte kvadratrod!\n\n-------------------\n");
		resultat = kvadratrod();
		/*KVADRATROD AFSLUTNING*/

		break;

		/*KUBIKROD*/
	case 7:
		printf_s("Du valgte kubikrod!\n\n-------------------\n");
		resultat = kubikrod();

		break;
		/*KUBIKROD AFSLUTNING*/

		/*FAKULTET*/
	case 8:
		printf_s("Du valgte at udregne et fakultet!\n\n-------------------\n");
		fakultet();

		break;
		/*FAKULTET AFSLUTNING*/

		/*MODSTANDE*/
	case 9:
		printf_s("Du valgte at udregne parallel- eller seriemodstande!\n\n-------------------\n");
		tilsvarende = modstand();

		break;
		/*MODSTANDE AFSLUTNING*/

		/*TABEL*/
	case 10:
		printf_s("Du valgte at faa fremvist en valgfri tabel!\n\n-------------------\n");
		tabel();

		break;
		/*TABEL AFSLUTNING*/

	case 11:		
		printf_s("Du valgte at sortere en raekke tal!\n\n-------------------\n");
		sortering();

		/*FIRKANT*/
	case 12:
		printf_s("Du valgte at lave din egen firkant!\n\n-------------------\n");
		firkant();
		/*FIRKANT AFSLUTNING*/

		break;

		//UDGANG
	case 0:

		break;

	}
	/*LOMMEREGNER AFSLUTNING*/


	/*RESULTAT*/
	if (valg == 1 || valg == 2 || valg == 3 || valg == 4 || valg == 5 || valg == 6 || valg == 7) {

		printf_s("Dit endelige resultat blev: %.2f", resultat);

	}

	else if (valg == 9) {

		printf_s("\nDin endelige tilsvarende modstand blen: %.2f", tilsvarende);

	}
	/*RESULTAT AFSLUTNING*/

	return valg;

}
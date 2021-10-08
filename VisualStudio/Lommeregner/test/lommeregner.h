float lommeregner(int valg, float resultat) {

	/*SELVE LOMMEREGNEREN*/
	switch (valg) {

		/*PLUS*/
	case 1:
		printf_s("Du valgte at plusse!\n\n-------------------\n");
		resultat = plus(resultat);

		break;
		/*PLUS AFSLUTNING*/

		/*MINUS*/
	case 2:
		printf_s("Du valgte at minusse!\n\n-------------------\n");
		resultat = minus(resultat);

		break;
		/*MINUS AFSLUTNING*/

		/*GANGE*/
	case 3:
		printf_s("Du valgte at gange!\n\n-------------------\n");
		resultat = gange(resultat);

		break;
		/*GANGE AFSLUTNING*/

		/*DIVISION*/
	case 4:
		printf_s("Du valgte at dividere!\n\n-------------------\n");
		resultat = dividere(resultat);

		break;
		/*DIVISION AFSLUTNING*/

		/*POTENS*/
	case 5:
		printf_s("Du valgte potens!\n\n-------------------\n");
		resultat = potens(resultat);
		/*POTENS AFSLUTNING*/

		break;

		/*KVADRATROD*/
	case 6:
		printf_s("Du valgte kvadratrod!\n\n-------------------\n");
		resultat = kvadratrod(resultat);
		/*KVADRATROD AFSLUTNING*/

		break;

		/*KUBIKROD*/
	case 7:
		printf_s("Du valgte kubikrod!\n\n-------------------\n");
		resultat = kubikrod(resultat);

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
		resultat = modstand(resultat);

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

		break;

		/*FIRKANT*/
	case 12:
		printf_s("Du valgte at lave din egen firkant!\n\n-------------------\n");
		firkant();

		break;
		/*FIRKANT AFSLUTNING*/

		/*JULETRÆ*/
	case 13:
		printf_s("Du valgte at lave dit egen juletrae!\n\n-------------------\n");
		juletrae();
		/*JULETRÆ AFSLUTNING*/

		break;

		//UDGANG
	case 0:

		break;

	}
	/*LOMMEREGNER AFSLUTNING*/

	return resultat;

}
#include <iostream>
#include <string>
#include "BilForhandler.h"
#include "brugere.h"
#include "BilKunde.h"

void Anders() {

	BilForhandler
		ferrai("Janus", 1200000, "Ferrai"),
		volvo("Ingen ejer", 50000, "Volvo");

	BilKunde Anders("Anders", 100000000);

	string navn,
		ejerFerrai = ferrai.hentEjer(), ejerVolvo = volvo.hentEjer(),
		maerkeFerrai = ferrai.hentMaerke(), maerkeVolvo = volvo.hentMaerke(),
		ejer[2] = { ejerFerrai, ejerVolvo }, maerke[2] = { maerkeFerrai, maerkeVolvo };

	int valg, inventar = 0, saldo;

	navn = Anders.hentNavn();
	saldo = Anders.hentSaldo();

	cout << "\nVelkommen " << navn << endl;

	while (1) {

		cout << "\nHvad kan vi goere for dig idag?\n"
			<< "\nTast 1: Se bil inventar"
			<< "\nTast 2: Koebe en bil"
			<< "\nTast 3: Se info om biler"
			<< "\nSkriv dit valg her:  ";
		cin >> valg;

		switch (valg) {

		case 1:

			cout << "\nHer er din bil inventar: \n" << endl;

			for (int n = 0; n < 1; n++) {

				if (ejer[n] == navn) {
					cout << " - " << maerke[n] << "\n" << endl;
					inventar = 1;
				}

			}

			if (inventar == 0)
				cout << "Du har desvaerre ikke nogle biler i din inventar\n" << endl;

			else
				inventar = 0;

			break;

		case 2:

			cout << "\nHvilken bil oensker du at koebe? \n"
				<< "Tast 1: Ferrai\n"
				<< "Tast 2: Volvo\n"
				<< "Skriv dit valg her:  ";
			cin >> valg;
			cout << endl;

			switch (valg)
			{

			case 1:
				ferrai.handel(navn, saldo);
				break;

			case 2:
				volvo.handel(navn, saldo);

			default:
				break;
			}

			break;

		case 3:

			cout << "\nHvilken bil oensker du at se info omkring? \n"
				<< "Tast 1: Ferrai\n"
				<< "Tast 2: Volvo\n"
				<< "Skriv dit valg her:  ";
			cin >> valg;
			cout << endl;

			switch (valg)
			{

			case 1:
				ferrai.bilInfo();
				break;

			case 2:
				volvo.bilInfo();

			default:
				break;
			}

			break;

		default:
			break;
		}

	}

}

/*---------- Ny bruger ----------*/

void Morten() {

	BilForhandler
		ferrai("Janus", 1200000, "Ferrai"),
		volvo("Ingen ejer", 50000, "Volvo");

	BilKunde Morten("Morten", 1231);

	string navn,
		ejerFerrai = ferrai.hentEjer(), ejerVolvo = volvo.hentEjer(),
		maerkeFerrai = ferrai.hentMaerke(), maerkeVolvo = volvo.hentMaerke(),
		ejer[2] = { ejerFerrai, ejerVolvo }, maerke[2] = { maerkeFerrai, maerkeVolvo };

	int valg, inventar = 0, saldo;

	navn = Morten.hentNavn();
	saldo = Morten.hentSaldo();

	cout << "\nVelkommen " << navn << endl;

	while (1) {

		cout << "\nHvad kan vi goere for dig idag?\n"
			<< "\nTast 1: Se bil inventar"
			<< "\nTast 2: Koebe en bil"
			<< "\nTast 3: Se info om biler"
			<< "\nSkriv dit valg her:  ";
		cin >> valg;

		switch (valg) {

		case 1:

			cout << "\nHer er din bil inventar: \n" << endl;

			for (int n = 0; n < 1; n++) {

				if (ejer[n] == navn) {
					cout << " - " << maerke[n] << "\n" << endl;
					inventar = 1;
				}

			}

			if (inventar == 0)
				cout << "Du har desvaerre ikke nogle biler i din inventar\n" << endl;

			else
				inventar = 0;

			break;

		case 2:

			cout << "\nHvilken bil oensker du at koebe? \n"
				<< "Tast 1: Ferrai\n"
				<< "Tast 2: Volvo\n"
				<< "Skriv dit valg her:  ";
			cin >> valg;
			cout << endl;

			switch (valg)
			{

			case 1:
				ferrai.handel(navn, saldo);
				break;

			case 2:
				volvo.handel(navn, saldo);

			default:
				break;
			}

			break;

		case 3:

			cout << "\nHvilken bil oensker du at se info omkring? \n"
				<< "Tast 1: Ferrai\n"
				<< "Tast 2: Volvo\n"
				<< "Skriv dit valg her:  ";
			cin >> valg;
			cout << endl;

			switch (valg)
			{

			case 1:
				ferrai.bilInfo();
				break;

			case 2:
				volvo.bilInfo();

			default:
				break;
			}

			break;

		default:
			break;
		}

	}

}


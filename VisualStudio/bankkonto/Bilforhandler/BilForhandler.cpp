#include <iostream>
#include <string>
#include "BilForhandler.h"

using namespace std;

	BilForhandler::BilForhandler(string startEjer, int nyPris, string Maerke) {

		ejer = startEjer;
		pris = nyPris;
		maerke = Maerke;
	}

	string BilForhandler::hentEjer() {

		return ejer;

	}

	string BilForhandler::hentMaerke() {

		return maerke;

	}

	void BilForhandler::bestemEjer(string nyEjer) {

		ejer = nyEjer;

	}

	void BilForhandler::handel(string navn, int saldo) {

		if (pris != 0 && saldo > pris) {
			cout << "Vil du koebe denne bil? Den koster: " << pris << "\nTast 1 for ja eller 0 for nej: ";
			cin >> valg;

			switch (valg)
			{

			case 1:
				ejer = navn;
				saldo -= pris;

				cout << "\nHvad skal bilen koste fremover? \nTast din pris eller tast 0 hvis bilen IKKe skal saettes til salg: ";
				cin >> nyPris;

				if (nyPris == 0)
					pris = 0;

				else
					pris = nyPris;

				break;

			default:
				break;
			}

		}

		else if (pris == 0)
			cout << "Denne bil er ikke til salg!\n";

		else if (saldo < pris)
			cout << "Du har ikke raad til denne bil!\n";

	}

	void BilForhandler::bilInfo() {

		if (pris != 0)
			cout << "Pris: " << pris << "\nMaerke: " << maerke << "\nEjer: " << ejer << endl;

		else 
			cout << "Pris: Bilen er ikke til salg!" << "\nMaerke: " << maerke << "\nEjer: " << ejer << endl;

	}
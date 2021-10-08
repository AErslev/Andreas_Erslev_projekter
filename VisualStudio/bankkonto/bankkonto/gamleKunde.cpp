#include <iostream>
#include <string>
#include "kunder.h"
#include "konto.h"

using namespace std;

void gamleKunde(int kontoNummer, int nytKontonummer, string navn, int startBeloeb) {

	int beloeb, logUd = 1, valg, kontoSaldo;
	Konto Jan("Jan", 1224), Asger("Asger", 3121), nyKunde(navn, startBeloeb);

	if (kontoNummer == nytKontonummer && nytKontonummer != 0) {

		nyKunde.velkomstBesked();

		do {

			valg = nyKunde.valgMuligheder();

			if (valg == 1) {
				kontoSaldo = nyKunde.hentKontoSaldo();
				cout << "Din nuvaereende saldo er: " << kontoSaldo << endl;
			}

			else if (valg == 2) {
				beloeb = nyKunde.indsaetHaev();
				nyKunde.setKontoSaldo(beloeb);
			}

			else if (valg == 3)
				logUd = 0;

		} while (logUd == 1);

		logUd = 1;
	}

	else {

		switch (kontoNummer)
		{

		case 1234:

			Jan.velkomstBesked();

			do {

				valg = Jan.valgMuligheder();

				if (valg == 1) {
					kontoSaldo = Jan.hentKontoSaldo();
					cout << "Din nuvaereende saldo er: " << kontoSaldo << endl;
				}

				else if (valg == 2) {
					beloeb = Jan.indsaetHaev();
					Jan.setKontoSaldo(beloeb);
				}

				else if (valg == 3)
					logUd = 0;

			} while (logUd == 1);

			logUd = 1;

			break;

		case 4321:

			Asger.velkomstBesked();

			do {

				valg = Asger.valgMuligheder();

				if (valg == 1) {
					kontoSaldo = Asger.hentKontoSaldo();
					cout << "Din nuvaereende saldo er: " << kontoSaldo << endl;
				}

				else if (valg == 2) {
					beloeb = Asger.indsaetHaev();
					Asger.setKontoSaldo(beloeb);
				}

				else if (valg == 3)
					logUd = 0;

			} while (logUd == 1);

			logUd = 1;

			break;

		default:
			cout << "\nDu har indtasttet et ugyldigt kontonummer!" << endl;
			break;
		}

	}

}
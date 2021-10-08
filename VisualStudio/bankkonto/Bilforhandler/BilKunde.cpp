#include <iostream>
#include <string>
#include "BilKunde.h"

using namespace std;

	BilKunde::BilKunde(string kundeNavn, int startSaldo) {

		navn = kundeNavn;
		saldo = startSaldo;

	}

	string BilKunde::hentNavn() {
		return navn;
	}

	int BilKunde::hentSaldo() {
		return saldo;
	}

	void BilKunde::bestemSaldo(int nySaldo) {
		saldo = nySaldo;
	}
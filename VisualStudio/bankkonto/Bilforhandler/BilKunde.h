#include <iostream>
#include <string>
#include "brugere.h"

using namespace std;

class BilKunde {

private:
	string navn;
	int saldo;

public:
	explicit BilKunde(string kundeNavn, int startSaldo);
	string hentNavn();
	int hentSaldo();
	void bestemSaldo(int nySaldo);

};
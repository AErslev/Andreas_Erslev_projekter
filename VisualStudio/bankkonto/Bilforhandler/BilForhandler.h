#include <iostream>
#include <string>
#include "brugere.h"

using namespace std;

class BilForhandler {

private:
	string ejer, maerke;
	int pris, valg, nyPris;

public:

	explicit BilForhandler(string startEjer, int nyPris, string Maerke);
	string hentEjer();
	string hentMaerke();
	void bestemEjer(string nyEjer);
	void handel(string navn, int saldo);
	void bilInfo();

};
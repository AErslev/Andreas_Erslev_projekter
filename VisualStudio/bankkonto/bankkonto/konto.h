#include <iostream>
#include <string>

using namespace std;

class Konto {

private:

	int kontoSaldo, valg, beloebIH;
	string kontoEjer;

public:

	explicit Konto(string Ejer, int kontoStartBeloeb);
	void setKontoEjer(string Ejer);
	void setKontoSaldo(int beloeb);
	string hentKontoNavn() const;
	int hentKontoSaldo() const;
	void velkomstBesked() const;
	int valgMuligheder();
	int indsaetHaev();

};
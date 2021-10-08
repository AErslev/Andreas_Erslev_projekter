#include <iostream>
#include <string>
#include "kunder.h"

using namespace std;

int main() {

	int kontoNummer, afslut, kundetype, nytKontonummer = 0, startBeloeb = 0;
	string navn = " ";

	cout << "Goddag. Er du eksisterende eller ny kunde?\n Tast 1 for eksisterende eller 2 som ny kunde: ";
	cin >> kundetype;

	do {

		if (kundetype == 2)
			nytKontonummer = nyKunde(&navn, &startBeloeb);

		cout << "Indtast dit kontonummer: ";
		cin >> kontoNummer;

		gamleKunde(kontoNummer, nytKontonummer, navn, startBeloeb);

		cout << "Vil du lukke ned eller logge paa med en anden konto?\n"
			<< "Tast 1 for at logge paa med en anden konto\n"
			<< "Tast 0 for at lukke ned: ";
		cin >> afslut; cout << endl;
		
	} while (afslut != 0);
}
#include <iostream>
#include <string>
#include "kunder.h"
#include "konto.h"

using namespace std;

int nyKunde(string* navn, int* startBeloeb) {

	cin.ignore();

	int nytKontonummer;

	cout << "Hvad er dit navn? ";
	getline(cin, *navn);

	cout << "Vaelg et 4 cifret kontonummer: ";
	cin >> nytKontonummer;

	cout << "Hvor mange penge vil du starte med at indsaette paa din konto? ";
	cin >> *startBeloeb;

	cout << "\nDu er blevet oprettet i systemet som: " << *navn << "\nmed start beloeb paa: " << *startBeloeb <<"\n" << endl;

	Konto nyKunde(*navn, *startBeloeb);

	return nytKontonummer;

}
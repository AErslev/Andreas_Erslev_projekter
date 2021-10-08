#include <iostream>
#include <string>
#include "kunder.h"
#include "konto.h"

	Konto::Konto(string Ejer, int kontoStartBeloeb) {
		kontoEjer = Ejer;
		kontoSaldo = kontoStartBeloeb;
	}

	void Konto::setKontoEjer(string Ejer) {
		kontoEjer = Ejer;
	}

	void  Konto::setKontoSaldo(int beloeb) {
		kontoSaldo += beloeb;
	}

	string  Konto::hentKontoNavn() const {
		return kontoEjer;
	}

	int  Konto::hentKontoSaldo() const {
		return kontoSaldo;
	}

	void  Konto::velkomstBesked() const {
		cout << "\nVelkommen " << kontoEjer << "\n"
			<< "Her kan du se din saldo og haeve/indsaette penge"
			<< endl;
	}

	int  Konto::valgMuligheder() {
		cout << "\nSe din nuvaerende saldo, tast 1\n"
			<< "Haev beloeb eller indset penge, tast 2\n"
			<< "For at slutte, tast 3: ";
		cin >> valg;
		cout << endl;

		return valg;
	}

	int  Konto::indsaetHaev() {

		cout << "Hvor mange penge vil du gerne haeve/indsaette? " ;
		cin >> beloebIH;
		cout << endl;

		return beloebIH;
	}
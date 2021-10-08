#include <iostream>
#include <string>
#include "BilForhandler.h"
#include "BilKunde.h"
#include "brugere.h"

using namespace std;

int main() {

	int pinkode;

	cout << "Goddag. \nVenligst indtast din pin kode: ";
	cin >> pinkode;

	switch (pinkode)
	{

	case 1234:

		Anders();

		break;

	case 4321:

		 Morten();

		break;

	default:
		break;
	}

}
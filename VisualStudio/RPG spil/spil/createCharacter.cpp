#include "createCharacter.h"

int Loading(int min, int max) {

	int wait = rand() % 650 + 100;
	int RNG = rand() % max + min;

	cout << "Loading";

	for (int n = 0; n < 3; n++) {

		Sleep(wait);
		cout << ".";

		wait = rand() % 650 + 100;
		RNG = rand() % max + min;

	}

	cout << " ";

	return RNG;

}

int createCharacter(string& name, string& race, double& health, int& strength, int& mana, double& damage)
{

	srand(time(0));

	int RNG, chosenRace, strengthMin, strengthMax, manaMin, manaMax;

	cout << "Enter character name: "; cin >> name;
	cout << "\nChoose race: " << endl << "1. Ork" << endl << "2. Wizard\n" << endl << "Choice: "; cin >> chosenRace;

	switch (chosenRace) {
	case 1:

		race = "Ork";

		health = 250;
		damage = 125;

		strengthMin = 60;
		strengthMax = 100;
		RNG = Loading(strengthMin, strengthMax);
		strength = RNG;

		manaMin = 10;
		manaMax = 70;
		RNG = Loading(manaMin, manaMax);
		mana = RNG;

		break;

	case 2:

		race = "Wizard";

		health = 125;
		damage = 85;

		strengthMin = 70;
		strengthMax = 15;
		RNG = Loading(strengthMin, strengthMax);
		strength = RNG;

		manaMin = 70;
		manaMax = 100;
		RNG = Loading(manaMin, manaMax);
		mana = RNG;

		break;

	}

	cout << endl << "---------------" << endl;

	cout << "Stats: "
		" Health: " << health <<
		" strength: " << strength <<
		" Mana: " << mana <<
		endl << "--------------------------------------------------------" << endl << endl;

	return chosenRace;

}

void levelUp(string name, double& health, int& strength, int& mana, double& damage, int chosenRace)
{
	srand(time(0));

	int RNG, strengthMin, strengthMax, manaMin, manaMax;

	cout << name << " leveled up!" << endl;

	switch (chosenRace) {
	case 1:

		health *= 1.6;
		damage *= 1.4;

		strengthMin = strength;
		strengthMax = strength * 3;
		RNG = Loading(strengthMin, strengthMax);
		strength = RNG;

		manaMin = mana;
		manaMax = mana * 2;
		RNG = Loading(manaMin, manaMax);
		mana = RNG;

		break;

	case 2:

		health *= 1.3;
		damage *= 1.4;

		strengthMin = strength;
		strengthMax = strength * 2;
		RNG = Loading(strengthMin, strengthMax);
		strength = RNG;

		manaMin = mana;
		manaMax = mana * 3;
		RNG = Loading(manaMin, manaMax);
		mana = RNG;

		break;

	}

	cout << endl << "---------------" << endl;

	cout << "Level up stats: "
		" Health: " << health <<
		" strength: " << strength <<
		" Mana: " << mana <<
		endl << "--------------------------------------------------------" << endl << endl;

}

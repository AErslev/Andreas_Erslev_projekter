#include "Battle.h"

Battle::Battle()
{
	shield_ = 0;
	action_ = 0;
}

Battle::Battle(list<Character> battleCharacters, list<Foes> battleFoes)
{
	shield_ = 0;
	action_ = 0;
	battleCharacters_ = battleCharacters;
	battleFoes_ = battleFoes;
}

void Battle::attack(double damage, double health)
{
	health_ -= damage + shield_;
}

void Battle::defend(double shield)
{
	shield_ = shield;
}

void Battle::setDistance()
{
}

void Battle::setTurn()
{
	list<Character>::iterator C;
	list<Character>::iterator CB = battleCharacters_.begin();
	list<Character>::iterator CE = battleCharacters_.end();

	list<Foes>::iterator F;
	list<Foes>::iterator FB = battleFoes_.begin();
	list<Foes>::iterator FE = battleFoes_.end();

	C = CB;
	F = FB;

	while (1) {

		if (C->getHealth() <= 0) {
			C++;

			if (C == CE)
				C = CB;
		}

		else if (turn_ == 0) {
			printActionMenu();
			C++;
			turn_++;

			if (action_ == 1) {
				this->attack(25, C->getHealth());
				C->setHealth(health_);
			}

			else if (action_ == 2)
				defend(75);

			if (C == CE)
				C = CB;

		}

		if (F->getHealth() <= 0) {
			F++;

			if (F == FE)
				F == FB;
		}

		else if (turn_ == 1) {
			this->printActionMenu();
			F++;
			turn_ = 0;

			if (action_ == 1) {
				this->attack(25, C->getHealth());
				C->setHealth(health_);
			}

			else if (action_ == 2)
				defend(75);

			if (F == FE)
				F = FB;

		}

	}
}

void Battle::printActionMenu()
{

	list<Character>::iterator C;

	cout << "Choose you action: " << endl
		<< "1. Attack" << endl
		<< "2. Defend" << endl
		<< "Action: "; cin >> action_;

}



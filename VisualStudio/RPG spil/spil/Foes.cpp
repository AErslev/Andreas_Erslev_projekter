#include "Foes.h"

int Foes::foeCount_ = 0;

Foes::Foes()
{

	name_ = "Unknown";
	race_ = "Unknown";
	health_ = 0;
	strength_ = 0;
	mana_ = 0;
	damage_ = 0;
	chosenRace_ = 0;

	createFoes(foeCount_, name_, race_, health_, strength_, mana_, damage_);

}

void Foes::setHealth()
{
}

double Foes::getHealth()
{
	return 0.0;
}

#pragma once
#include "createFoes.h"

class Foes
{
public:
	Foes();
	void setHealth();
	double getHealth();

private:
	int strength_, mana_, chosenRace_;
	double health_, damage_;
	string name_, race_;
	static int foeCount_;
};


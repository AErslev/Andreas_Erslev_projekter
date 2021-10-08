#pragma once
#include <iostream>
#include <string>
#include "createCharacter.h"

using namespace std;

class Character
{
public:
	Character();
	void setHealth(double);
	double getHealth();
	void levelUpCharacter();

private:
	int strength_, mana_, chosenRace_; 
	double health_, damage_;
	string name_, race_;
	static int playerCount;
};


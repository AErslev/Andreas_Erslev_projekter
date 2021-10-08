#pragma once
#include "Character.h"

class Warrior : public Character
{
public:
	Warrior(double XPLevelUp = 20, double multiplier = 1.7, int type = 2, double health = 0, double mana = 0, double strength = 0, string name = "Unnamed", string chracterClass = "Warrior");
	~Warrior();
	void levelUp();
	void print() const;

private:
	double multiplier_, XPLevelUp_;
};



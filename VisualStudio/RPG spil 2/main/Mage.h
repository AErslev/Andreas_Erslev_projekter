#pragma once
#include "Character.h"

class Mage : public Character
{
public:
	Mage(double XPLevelUp = 20, double multiplier = 1.7, int type = 1, double health = 0, double mana = 0, double strength = 0, string name = "Unnamed", string chracterClass = "Mage");
	~Mage();
	void defaultAttacks();
	void levelUp(double XP);
	void print() const;

private:
	double multiplier_, XP_, XPLevelUp_;
};


#pragma once
#include "Character.h"

class Enemy : public Character
{
public:
	Enemy(double XPLevelUp = 20, double multiplier = 1.7, int type = 4, double health = 0, double mana = 0, double strength = 0, string name = "Unnamed", string chracterClass = "Enemy");
	~Enemy();
	void levelUp(double XP);
	void printName() const;

private:
	string type_, name_;
	double multiplier_;
};


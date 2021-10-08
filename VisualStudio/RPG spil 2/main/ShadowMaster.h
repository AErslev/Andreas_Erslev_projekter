#pragma once
#include "Character.h"

class ShadowMaster : public Character
{
public:
	ShadowMaster(double XPLevelUp = 20, double multiplier = 1.7, int type = 3, double health = 0, double mana = 0, double strength = 0, string name = "Unnamed", string chracterClass = "Shadow Master");
	~ShadowMaster();
	void levelUp();
	void print() const;

private:
	double multiplier_, XPLevelUp_;
};


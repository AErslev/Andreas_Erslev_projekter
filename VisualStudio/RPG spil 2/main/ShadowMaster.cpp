#include "ShadowMaster.h"

ShadowMaster::ShadowMaster(double XPLevelUp, double multiplier, int type, double health, double mana, double strength, string name, string chracterClass) : Character(XPLevelUp, multiplier, type, health, mana, strength, name, chracterClass)
{
	multiplier_ = multiplier;
	XPLevelUp_ = XPLevelUp;
}

ShadowMaster::~ShadowMaster()
{
}

void ShadowMaster::levelUp()
{
	Character::setHealth(Character::getHealth() * multiplier_);
	Character::setMana(Character::getMana() * multiplier_);
	Character::setStrength(Character::getStrength() * multiplier_);
}

void ShadowMaster::print() const
{
	Character::print();
}

#include "Warrior.h"

Warrior::Warrior(double XPLevelUp, double multiplier, int type, double health, double mana, double strength, string name, string chracterClass) : Character(XPLevelUp, multiplier, type, health, mana, strength, name, chracterClass)
{
	multiplier_ = multiplier;
	XPLevelUp_ = XPLevelUp;
}

Warrior::~Warrior()
{
}

void Warrior::levelUp()
{
	Character::setHealth(Character::getHealth() * multiplier_);
	Character::setMana(Character::getMana() * multiplier_);
	Character::setStrength(Character::getStrength() * multiplier_);
}

void Warrior::print() const
{
	Character::print();
}

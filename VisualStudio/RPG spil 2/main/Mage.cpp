#include "Mage.h"

Mage::Mage(double XPLevelUp, double multiplier, int type,  double health, double mana, double strength, string name, string chracterClass) : Character(XPLevelUp, multiplier, type, health, mana, strength, name, chracterClass)
{
	multiplier_ = multiplier;
	XPLevelUp_ = XPLevelUp;
}

Mage::~Mage()
{
}

void Mage::defaultAttacks()
{
	Attack thunderBash(25, "Thunder Bash"); addAttack(thunderBash);
	Attack fireBlast(30, 10, "Fire Blast"); addAttack(fireBlast);
	Attack arrowBoom(50, "Arrow Boom"); addAttack(arrowBoom);
}

void Mage::levelUp(double XP)
{
	Character::levelUp(XP);
}

void Mage::print() const
{
	Character::print();
}
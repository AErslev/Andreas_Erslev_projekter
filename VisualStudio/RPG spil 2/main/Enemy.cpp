#include "Enemy.h"

Enemy::Enemy(double XPLevelUp, double multiplier, int type, double health, double mana, double strength, string name, string chracterClass) : Character(XPLevelUp, multiplier, type, health, mana, strength, name, chracterClass)
{
	multiplier_ = multiplier;
	name_ = name;
}

Enemy::~Enemy()
{
}

void Enemy::levelUp(double XP)
{
	Character::levelUp(XP);
}

void Enemy::printName() const
{
	Character::printName();
}

#include "Attack.h"

Attack::Attack(double damage, string name)
{
	damage_ = damage;
	name_ = name;
}

Attack::Attack(double damage, double mana, string name)
{
	damage_ = damage;
	mana_ = mana;
	name_ = name;
}

double Attack::getDamage() const
{
	return damage_;
}

double Attack::getMana() const
{
	return mana_;
}

string Attack::getName() const
{
	return name_;
}

void Attack::setID(int ID)
{
	id_ = ID;
}

int Attack::getID() const
{
	return id_;
}

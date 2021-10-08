#pragma once
#include "Attack.h"

using namespace std;

class Character
{
public:
	Character(double XPLevelUp = 20, double multiplier = 1.7, int type = 0, double health = 0, double mana = 0, double strength = 0, string name = "Unknown", string characterClass = "Unknown");
	virtual ~Character();
	Character(const Character& other);
	Character& operator=(const Character& other);
	void setHealth(double health);
	double getHealth() const;
	void damageInput(double damage);
	void setMana(double mana);
	double getMana() const;
	void setStrength(double strength);
	double getStrength() const;
	double getDamage(int attackID) const;
	void setName(string name);
	string getName() const;
	int getNumberOfAttacks() const;
	virtual void defaultAttacks(int type);
	virtual void levelUp(double XP);
	void addAttack(Attack addAtack);
	double dealDamage(int attackID);
	virtual void printAttack(int attackID) const;
	virtual void printAttacks() const;
	virtual void printName() const;
	virtual void print() const;

private:
	double health_, mana_, strength_, attackPower_, XP_, multiplier_, XPLevelUp_;
	Attack* attacks;
	string name_, characterClass_;
	int id_, numberOfAttacks_;
};


#include "Character.h"

Character::Character(double XPLevelUp, double multiplier, int type, double health, double mana, double strength, string name, string characterClass)
{

	health_ = (health > 0 ? health : 50);
	mana_ = (mana > 0 ? mana : 5);
	strength_ = (strength > 0 ? strength : 5);
	multiplier_ = multiplier;
	XPLevelUp_ = XPLevelUp;
	name_ = name;
	id_ = 0;
	characterClass_ = characterClass;
	numberOfAttacks_ = 0;

	attacks = nullptr;
	defaultAttacks(type);

}

Character::~Character()
{

}

Character::Character(const Character& other)
{
	health_ = other.health_;
	mana_ = other.mana_;
	strength_ = other.strength_;
	multiplier_ = other.multiplier_;
	XPLevelUp_ = other.XPLevelUp_;
	name_ = other.name_;
	id_ = other.id_;
	numberOfAttacks_ = other.numberOfAttacks_;
	characterClass_ = other.characterClass_;
	XPLevelUp_ = other.XPLevelUp_;
	attacks = other.attacks;

}

Character& Character::operator=(const Character& other)
{

	if (this != &other) {

		health_ = other.health_;
		mana_ = other.mana_;
		strength_ = other.strength_;
		multiplier_ = other.multiplier_;
		XPLevelUp_ = other.XPLevelUp_;
		name_ = other.name_;
		id_ = other.id_;
		numberOfAttacks_ = other.numberOfAttacks_;
		characterClass_ = other.characterClass_;
		XPLevelUp_ = other.XPLevelUp_;
		attacks = other.attacks;

	}

	return *this;
}

void Character::setHealth(double health)
{
	health_ = health;
}


double Character::getHealth() const
{
	return health_;
}

void Character::damageInput(double damage)
{
	health_ -= damage;
}

void Character::setMana(double mana)
{
	mana_ = mana;
}

double Character::getMana() const
{
	return mana_;
}

void Character::setStrength(double strength)
{
	strength_ = strength;
}

double Character::getStrength() const
{
	return strength_;
}

double Character::getDamage(int attackID) const
{
	return attacks[attackID].getDamage();
}

void Character::setName(string name)
{
	name_ = name;
}

string Character::getName() const
{
	return name_;
}

int Character::getNumberOfAttacks() const
{
	return numberOfAttacks_;
}

void Character::defaultAttacks(int type)
{

	Attack thunderBash(25, "Thunder Bash"); addAttack(thunderBash);
	Attack fireBlast(30, 10, "Fire Blast"); addAttack(fireBlast);
	Attack arrowBoom(50, "Arrow Boom"); addAttack(arrowBoom);

}

void Character::levelUp(double XP)
{

	XP_ += XP;

	if (XP_ >= XPLevelUp_) {
		setHealth(Character::getHealth() * multiplier_);
		setMana(Character::getMana() * multiplier_);
		setStrength(Character::getStrength() * multiplier_);

		XPLevelUp_ *= multiplier_;
		cout << "Level up!\n\n";
	}

}

void Character::addAttack(Attack addAttack)
{

	if (attacks != nullptr) {

		Attack* temp = attacks;
		attacks = new Attack[id_ + 1];
		for (int n = 0; n < id_; n++) 
			attacks[n] = temp[n];
		delete[] temp;
		attacks[id_] = addAttack;
	}

	else {
		attacks = new Attack[id_ + 1];
		attacks[id_] = addAttack;
	}

	id_++; attacks[id_ - 1].setID(id_);
	numberOfAttacks_++;
}

double Character::dealDamage(int attackID)
{
	
	for (int n = 0; n < id_; n++) {
		if (attackID == attacks[n].getID())
			return attacks[n].getDamage();
	}

}

void Character::printAttack(int attackID) const
{
	cout << attacks[attackID].getName() << endl << endl;
}

void Character::printAttacks() const
{
	for (int n = 0; n < numberOfAttacks_; n++) {
		cout << n + 1 << ". " << attacks[n].getName();
		cout << " - Attack damage: " << attacks[n].getDamage() << endl;
	}

	cout << endl;
}

void Character::printName() const
{
	cout << name_ << endl;
}

void Character::print() const
{
	cout << "Player " << name_ << " stats: \n" << endl 
		 << "Health: " << health_ << endl 
		 << "Mana: " << mana_ << endl 
		 <<	"Strength: " << strength_ << endl 
		 << "Class: " << characterClass_ 
		 << endl << endl;
}
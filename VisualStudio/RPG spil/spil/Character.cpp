#include "Character.h"

int Character::playerCount = 0;

Character::Character()
{

	name_ = "Unknown";
	race_ = "Unknown";
	health_ = 0;
	strength_ = 0;
	mana_ = 0;
	damage_ = 0;
	chosenRace_ = 0;

	if (playerCount != 0)
		chosenRace_ = createCharacter(name_, race_, health_, strength_, mana_, damage_);

	if (playerCount != 0)
		chosenRace_ = createCharacter(name_, race_, health_, strength_, mana_, damage_);

	playerCount++;

}

void Character::setHealth(double)
{
}

double Character::getHealth()
{
	return health_;
}

void Character::levelUpCharacter()
{
	levelUp(name_, health_, strength_, mana_, damage_, chosenRace_);
}


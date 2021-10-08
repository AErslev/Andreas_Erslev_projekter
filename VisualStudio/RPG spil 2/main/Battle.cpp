#include "Battle.h"

Battle::Battle()
{
}

bool Battle::fight(Character& player, vector<Enemy>& enemies)
{

	currentEnemy_ = enemies.begin() + 1;
	numberOfEnemies_ = 1;
	XP_ = 1;

	do {

		cout << "Choose your attack:\n" << endl;

		player.printAttacks();

		cin >> attack_;

		cout << "Choose what enemy to attack: " << endl << endl;

		for (itr = enemies.begin() + 1; itr != enemies.end(); itr++, numberOfEnemies_++) {
			cout << numberOfEnemies_ << ". ";  
			(*itr).printName();
			cout << " - Health: " << (*itr).getHealth() << endl;
		}

		numberOfEnemies_ = 1;

		cin >> chooseEnemy_;

		enemy_ = enemies.begin() + chooseEnemy_;
		
		(*enemy_).damageInput(player.dealDamage(attack_));
		
		if ((*enemy_).getHealth() <= 0) {
			enemies.erase(enemy_);
			currentEnemy_ = enemies.begin();
			XP_ += XP_;
		}

		if (enemies.size() == 1)
			return true;

		if (currentEnemy_ > enemies.end())
			currentEnemy_ = enemies.begin() + 1;
		else
			currentEnemy_++;

		enemyAttack_ = 1;

		player.damageInput((*currentEnemy_).dealDamage(enemyAttack_));

	} while (0 <= player.getHealth());

	player.levelUp(XP_);

	return false;

}


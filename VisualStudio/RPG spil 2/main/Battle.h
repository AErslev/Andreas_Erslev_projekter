#pragma once
#include "Mage.h"
#include "Enemy.h"
#include "Character.h"
#include <vector>
#include <iterator>
#include <string>

class Battle
{
public:
	Battle();
	bool fight(Character& player, vector<Enemy>& enemies);

private:

	int attack_, enemyAttack_, placement_, chooseEnemy_, numberOfEnemies_;
	double XP_;

	vector<Enemy>::iterator itr, enemy_, currentEnemy_;
};

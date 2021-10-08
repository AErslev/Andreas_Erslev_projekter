#include <stdlib.h>
#include <time.h> 

#include "Character.h"
#include "Mage.h"
#include "Warrior.h"
#include "ShadowMaster.h"
#include "Enemy.h"
#include "Battle.h"
#include "createACharacter.h"

int main() {

	bool outcome;
	int classType;
	int classStats;

	srand(time(NULL));
	double RNGStatsHealth;
	double RNGStatsMana;
	double RNGStatsStrength;

	cout << "Select class: \n 1. Mage\n 2. Warrior\n 3. Shadow Master\n";

	cin >> classType;

	Character player;

	Mage mage; 
	Warrior warrior;
	ShadowMaster ShadowMaster;

	Enemy empty;
	Enemy Bear(20, 0, 1, 1, 0, 1, "Bear", "Enemy");

	vector<Enemy> enemies;
	enemies.push_back(empty);
	enemies.push_back(Bear);


	Battle battle;

	switch (classType)
	{
	case 1: 
		RNGStatsHealth = rand() % 50 + 20;
		RNGStatsMana = rand() % 10 + 7;
		RNGStatsStrength = rand() % 6 + 1;

		player = create(mage, RNGStatsHealth, RNGStatsMana, RNGStatsStrength);
		
		break;
		
	case 2:
		RNGStatsHealth = rand() % 80 + 20;
		RNGStatsMana = rand() % 5 + 3;
		RNGStatsStrength = rand() % 10 + 5;

		player = create(warrior, RNGStatsHealth, RNGStatsMana, RNGStatsStrength);

		break;

	case 3:
		RNGStatsHealth = rand() % 60 + 20;
		RNGStatsMana = rand() % 7 + 5;
		RNGStatsStrength = rand() % 7 + 3;

		player = create(ShadowMaster, RNGStatsHealth, RNGStatsMana, RNGStatsStrength);

		break;

	default:
		break;
	}

	player.print();
	enemies[1].print();
	enemies[1].printAttack(0);
	enemies[1].printAttacks();

	outcome = battle.fight(player, enemies);

	if (outcome)
		cout << "VICTORY!\n\n";
	else
		cout << "Defeat!\n\n";

	enemies.push_back(Bear);
	enemies.push_back(Bear);
	enemies.push_back(Bear);

	enemies[1].print();
	enemies[1].printAttack(0);
	enemies[1].printAttacks();

	outcome = battle.fight(player, enemies);

	if (outcome)
		cout << "VICTORY!\n\n";
	else
		cout << "Defeat!\n\n";

	return 0;

}
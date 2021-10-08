#include "createACharacter.h"

Character create(Character& player, int RNGStatsHealth, int RNGStatsMana, int RNGStatsStrength) {

	string name;

	cout << "Enter charater name: "; cin >> name; cout << endl;

	player.setName(name);
	player.setHealth(RNGStatsHealth);
	player.setMana(RNGStatsMana);
	player.setStrength(RNGStatsStrength);

	return player;

}
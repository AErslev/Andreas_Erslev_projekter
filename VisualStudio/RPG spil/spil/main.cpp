#include "Character.h"
#include "Battle.h"
#include "Foes.h"

#define numberOfFoes 2

int main(void) {

	int numberOfPlayers;

	cout << "How many players? "; cin >> numberOfPlayers; numberOfPlayers++;

	Character* players = new Character[numberOfPlayers];
	Foes* foes = new Foes[numberOfFoes];
	list<Character> battleCharaters;
	list<Foes> battleFoes;

	players[1].levelUpCharacter();

	for (int n = 0; n < numberOfPlayers; n++) 
		battleCharaters.push_back(players[n]);
	
	for (int n = 0; n < numberOfFoes; n++)
		battleFoes.push_back(foes[n]);

	Battle battle(battleCharaters, battleFoes);

	return 0;

}
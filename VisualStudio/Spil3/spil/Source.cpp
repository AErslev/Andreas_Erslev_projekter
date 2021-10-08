#include "CarDealer.h"

#define SIZE 6
#define turns 3
#define numberOfCars 8

int main(void) {

	srand(time(0));

	//Initialize vars
	int t = rand() % 24 + 1; int m = rand() % 60 + 1; int s = rand() % 60 + 1;
	int age = 0, arbejdsTimer = 9, price, choise, carNumber, carOwner;
	int numberOfPlayers, won = 0, currentPlayer = 1;
	int lottoTal[SIZE], brugerLottoTal[SIZE], rigtige[SIZE];
	string userName, spilLotto;

	//Intro
	cout << "This is a turn based game. Every player gets " << turns << " actions. After this, the turn will shift. \n" << endl;

	//Initialize classes
	cout << "Initializing game\n";
	Time time(t, m, s);
	Time clock = time;
	clock.printTime();
	Car* cars = new Car[numberOfCars];
	cout << endl << endl;

	cout << "Enter number of players: "; cin >> numberOfPlayers; numberOfPlayers++; cout << endl;

	Player* players = new Player[numberOfPlayers];

	for (int n = 1; n < numberOfCars; n++) {
		carNumber = rand() % numberOfCars;
		carOwner = rand() % numberOfPlayers;
		cars[carNumber].setOwner(players[carOwner]);
	}

	CarDealer* carDealer = new CarDealer[numberOfCars];

	for (int n = 0; n < numberOfCars; n++) 
		carDealer[n].setCarDetails(cars[n]);

	do {

		cout << "Player: " << players[currentPlayer].getPlayerName() << " turn.\n" << endl;

		cout << "Current time is: "; clock.printTime();

		for (int n = 0; n < turns; n++) {
	
			cout << "Player " << players[currentPlayer].getPlayerName() << " choose your action: " << endl
				<< "1. Check bank" << endl
				<< "2. Go to work" << endl
				<< "3. Get car info" << endl
				<< "0. End turn" << endl
				<< endl << "Action: ";
			
			cin >> choise;

			switch (choise) {
			
			case 1:
				players[currentPlayer].accessBank();
				break;
				
			case 2:
				players[1].work(&clock);
				break;

			case 3:
				for (int n = 0; n < numberOfPlayers; n++) {
					if (cars[n].getOwner() == players[currentPlayer].getPlayerName()) {
						cars[n].printInfo();
					}
				}
				break;

			case 0:
				break;

			default:
				break;
			
			}

		}

		if (clock == time) {
			time.setRandom();
			clock = time;
			cout << "No time has passed. New time is: ";
			time.printTime();
		}

		currentPlayer++;

		if (currentPlayer >= numberOfPlayers)
			currentPlayer = 1;

	} while (won != 1);

	return 0;

}
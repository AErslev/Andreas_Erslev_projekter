#include "PlayerDetails.h"

int PlayerDetails::playerCount_ = 0;

PlayerDetails::PlayerDetails()
{

	playerName_ = "Unknown";

	if (playerCount_ != 0) {
		cout << "Enter username for player " << playerCount_ << ": ";
		cin.clear(); cin.ignore(INT_MAX, '\n'); 
		getline(cin, playerName_);
		cout << "\nCreating character: " << playerName_ << endl;
	}

	playerCount_++;
}

void PlayerDetails::setUserName(string userName)
{
	playerName_ = userName;
}

void PlayerDetails::setplaerAge(int age)
{
	playerAge_ = age;
}

string PlayerDetails::getUserName()
{
	return playerName_;
}

int PlayerDetails::getUserAge()
{
	return playerAge_;
}


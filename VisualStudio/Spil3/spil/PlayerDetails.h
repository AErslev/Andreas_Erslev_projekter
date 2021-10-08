#pragma once
#include <iostream>
#include <string>

using namespace std;
class PlayerDetails
{
public:
	PlayerDetails();
	void setUserName(string);
	void setplaerAge(int);
	string getUserName();
	int getUserAge();


private:
	string playerName_;
	int playerAge_;
	static int playerCount_;
};


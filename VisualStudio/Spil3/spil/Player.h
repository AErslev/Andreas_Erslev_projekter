#pragma once
#include <iostream>
#include <string>
#include "Bank.h"
#include "Job.h"
#include "PlayerDetails.h"
#include "Time.h"

using namespace std;

class Player
{
public:
	Player();
	void changePin();
	void changeSaldo(int);
	void carSale(int, int);
	string getPlayerName();
	const void printOwner();
	void accessBank();
	void work(Time*);
	static int playerCount_;

private:
	string playerName_;
	PlayerDetails details;
	Job playerJob_;
	Bank bankAccount_;
	double payCheck_;

};


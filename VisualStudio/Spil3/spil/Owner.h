#pragma once
#include <iostream>
#include <string>
#include "Bank.h"
#include "Job.h"
#include "PlayerDetails.h"
#include "chooser.h"

using namespace std;

class Owner
{
public:
	Owner();
	Owner(string);
	void changePin();
	string getOwner();
	const void printOwner();
	void accessBank();
	static int playerCount_;

private:
	string userName_;
	PlayerDetails user;
	Job playerJob_;
	Bank bankAccount_;

};


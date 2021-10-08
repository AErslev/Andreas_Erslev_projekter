#pragma once
#include <iostream>
#include <string>
#include <iomanip>
#include <Windows.h>
#include "bank.h"
#include "bilEjer.h"

using namespace std;

class Karrakter : public Bank, public BilEjer {

private:
	string userName_, userJob_;
	int userAge_, saldo_, pin_;

public:
	explicit Karrakter(string userName, int age, string job, int saldo, int pin);
	int setSaldo(int saldo);
	string getUsername();
	int getMySaldo();
	BilEjer spec_[5];
};
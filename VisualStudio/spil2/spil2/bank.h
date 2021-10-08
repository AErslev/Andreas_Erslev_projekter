#pragma once
#include <iostream>
#include <string>

using namespace std;

class Bank {

private:

	int saldo_, choice_, pin_;
	string owner_;

public:
	explicit Bank(string owner, int startSaldo, int pin);
	void setOwner(string owner);
	void setSaldo(int amount);
	void moneyEarned(int amount);
	string getName();
	int getSaldo();
	void welcome() const;
	int options(int pin);
	void useMoney(int money);
};
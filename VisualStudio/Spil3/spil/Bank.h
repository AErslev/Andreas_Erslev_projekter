#pragma once
#include <iostream>
#include <string.h>
#include "chooser.h"

using namespace std;

class Bank
{
public:
	Bank();
	void setSaldo(int);
	void setPin(int);
	const void carSale(int, int);
	const bool withdraw();
	const bool insert();
	const void payDay(double);
	const bool changePin();
	const bool printSaldo();
	const bool enterPin();
	const void printMenu(string);
	const void openAccount();
	static int accountCount_;

private:
	int pin_;
	int pinCode_;
	double saldo_;
	int incorrect_;
	double amount_;
	int choice_;

	int* pinPtr_ = &pin_;
	double* saldoPtr_ = &saldo_;
	
};


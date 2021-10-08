#pragma once
#include "karrakter.h"

Karrakter::Karrakter(string userName, int age, string job, int saldo, int pin) : Bank ( userName, saldo , pin), BilEjer ( userName ) {

	userName_ = userName;
	userAge_ = age;
	userJob_ = job;
	saldo_ = saldo;
	pin_ = pin;
}

int Karrakter::setSaldo(int saldo) {
	saldo_ = saldo;
	cout << saldo_;
	return 0;
}

string Karrakter::getUsername() {
	return userName_;
}

int Karrakter::getMySaldo()
{
	return saldo_;
}

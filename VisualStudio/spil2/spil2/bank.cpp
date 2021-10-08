#include "bank.h"

Bank::Bank(string owner, int startSaldo, int pin) {
	owner_ = owner;
	saldo_ = startSaldo;
	pin_ = pin;
}

void Bank::setOwner(string Ejer) {
	owner_ = Ejer;
}

void  Bank::setSaldo(int amount) {
	saldo_ = amount;
}

void  Bank::moneyEarned(int amount) {
	saldo_ += amount;
}

string  Bank::getName() {
	return owner_;
}

int  Bank::getSaldo() {
	return saldo_;
}

void Bank::useMoney(int amount) {
	saldo_ -= amount;
}

void  Bank::welcome() const {
	cout << "n\Welcome " << owner_ << endl;
}

int  Bank::options(int pin) {

	cout << "Please enter your pin: ";
	cin >> pin;
	
	if (pin_ != pin) {
		cout << "INCORRECT PIN!\n\n";
		return 0;
	}

	cout << "\n\nTo see your saldo, press 1\n"
		<< "Deposit or withdraw money, press 2\n"
		<< "Quit, press 3: ";
	cin >> choice_;
	cout << endl;

	return choice_;
}

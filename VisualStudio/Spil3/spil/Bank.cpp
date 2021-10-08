#include "Bank.h"

int Bank::accountCount_ = 0;

Bank::Bank()
{
	pin_ = 0;
	saldo_ = 0;
	pinCode_ = 0;
	incorrect_ = 0;
	amount_ = 0;
	choice_ = 0;

	if (Bank::accountCount_ != 0)
		setBankAccount(saldoPtr_, pinPtr_);

	Bank::accountCount_++;

}

void Bank::setSaldo(int saldo)
{
	saldo_ = saldo;
}

void Bank::setPin(int pin)
{
	pin_ = pin;
}

const void Bank::carSale(int amount, int status)
{
	if (status == 1)
		saldo_ += amount;

	else if (status == 0)
		saldo_ -= amount;

}

const bool Bank::withdraw()
{
	if (!this->enterPin()) 
		return false;

	cout << "Your current saldo is : " << saldo_ << endl;
	cout << "How much do you want to withdraw?: "; cin >> amount_;
	saldo_ -= amount_;
	cout << "You have withdrawed: " << amount_ << " Your current saldo is: " << saldo_ << endl << endl;

	return true;

}

const bool Bank::insert()
{
	if (!this->enterPin()) 
		return false;
	
	cout << "Your current saldo is : " << saldo_ << endl;
	cout << "How much do you want to insert?: "; cin >> amount_;
	saldo_ += amount_;
	cout << "You have inserted: " << amount_ << " Your current saldo is: " << saldo_ << endl << endl;

	return true;

}

const void Bank::payDay(double payCheck)
{
	saldo_ += payCheck;
}



const bool Bank::changePin()
{
	if (!this->enterPin()) 
		return false;
	
	cout << "Enter your new PIN: "; cin >> pin_;

	return true;

}

const bool Bank::printSaldo()
{
	if (!this->enterPin()) 
		return false;
	
	cout << "You current saldo is: " << saldo_ << endl << endl; 

	return true;

}

const bool Bank::enterPin()
{
	cout << "Enter your pincode: "; cin >> pinCode_;
	if (pin_ == pinCode_)
		cout << "Welcome!\n" << endl;

	else {
		while (pinCode_ != pin_ && incorrect_ != 3) {
			incorrect_++;
			cout << "Wrong pincode. You have " << 3 - incorrect_ << " tries left. " << "Try again: "; cin >> pinCode_;
		}

		if (incorrect_ == 3) {
			cout << "Your account has been locked! Contact you bank, to open your account";
			return false;
		}

		else {
			cout << "Welcome!\n" << endl;
			incorrect_ = 0;
			pinCode_ = 0;
		}
	}

	return true;

}

const void Bank::printMenu(string name)
{

	cout << "Hello " << name << " How may I service you today?" << endl;

	cout	
		<< "1. Show saldo" << endl
		<< "2. Withdraw money" << endl
		<< "3. Insert money" << endl
		<< "4. Change PIN" << endl 
		<< "0. Exit" << endl
		<< "\nAction: ";
	cin >> choice_;

	switch (choice_) {

	case 1:
		this->printSaldo();
		break;

	case 2:
		this->withdraw();
		break;

	case 3:
		this->insert();
		break;

	case 4:
		this->changePin();
		break;

	default:
		cout << "See you later, alligator.\n" << endl;

	}


}

const void Bank::openAccount()
{
	incorrect_ = 0;
}

#include "Owner.h"

Owner::Owner()
{
}

Owner::Owner(string userName)
{
	user.getUserName();
}

void Owner::changePin()
{
	bankAccount_.changePin();
}

string Owner::getOwner()
{
	return userName_;
}

const void Owner::printOwner()
{
	cout << "Car is owned by: " << userName_ << endl << endl;
}

void Owner::accessBank()
{
	bankAccount_.printMenu(userName_);
}

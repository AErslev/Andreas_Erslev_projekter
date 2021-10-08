#include "CarDealer.h"

CarDealer::CarDealer()
{
	carType_ = "Unknown";
	owner_ = "Unknown";
	price_ = 0;
}

void CarDealer::setCarDetails(Car& carForSale)
{
	carType_ = carForSale.getCarType();
	owner_ = carForSale.getOwner();
	price_ = carForSale.getPrice();
}

string CarDealer::getCarType()
{
	return carType_;
}

string CarDealer::getOwner()
{
	return owner_;
}

void CarDealer::carSale(Player& seller, Player& buyer, Car& carForSale)
{
	if (carForSale.getForSale()) {
		seller.carSale(price_, sell_);
		buyer.carSale(price_, buy_);
		carForSale.setOwner(buyer);
		owner_ = carForSale.getOwner();
	}

}

void const CarDealer::printMenu()
{
	cout << "What would you like to do?\n" << endl;
	
	cout << "1. Check cars" << endl
		<< "2. Sell car" << endl
		<< "3 Buy car" << endl
		<< "Action: ";

	cin >> choice_;

	switch (choice_) {
	case 1:

		break;
	}

}

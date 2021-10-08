#include "Car.h"

Car::Car()
{
	carNotExisting_ = 0;
	setCar(carTypePtr_, pricePtr_, notExistingPtr_);
	owner_ = "This car has no owner.";
}

Car::Car(string owner, int price, string carType)
{
	owner_ = owner;
	price_ = price;
	carType_ = carType;
}

void Car::setOwner(Player& carOwner)
{
	if (carNotExisting_ == 0)
		owner_ = carOwner.getPlayerName();

	else if (carNotExisting_ == 1)
		owner_ = "Car not existing";
}

string Car::getOwner()
{
	return owner_;
}

void Car::setPrice(int price)
{
	price_ = price;
}

void Car::setWheelType(string wheelType)
{
	wheels_.setWheelType(wheelType);
}

void Car::setCarType_(string carType)
{
	carType_ = carType;
}

string Car::getWheelType()
{
	return wheels_.getWheelType();
}

int Car::getPrice()
{
	return price_;
}

string Car::getCarType()
{
	return carType_;
}

const void Car::printInfo()
{
	cout << "Price: " << price_
		<< "\nCar type: " << carType_
		<< "\nWheel type: " << wheels_.getWheelType()
		<< "\nOwner: " << owner_ << endl << endl;
}

void Car::setforSale(int status)
{
	available_ = status;
}

bool Car::getForSale()
{	
	if (available_ == 1)
		return true;

	return false;
}

#include "bilEjer.h"
#include "case.h"

BilEjer::BilEjer(string carOwner, string type, int price) {

	carOwner_ = carOwner;
	type_ = type;
	price_ = price;

}

void BilEjer::setCarOwner(string owner) {
	carOwner_ = owner;
}

string BilEjer::getCarOwner()
{
	return carOwner_;
}

void BilEjer::setCarType(string type) {
	type_ = type;
}

string BilEjer::getCarType() {
	return carOwner_;
}

void BilEjer::setCarPrice(int price) {
	price_ = price;
}

int BilEjer::getCarPrice() {
	return price_;
}

void BilEjer::setSpecs() {

	setSpecsFunktion(carOwnerPtn_, typePtn_, pricePtn_);

}

void BilEjer::getSpecs() {

	cout <<
		carOwner_ << endl <<
		type_ << endl <<
		price_ << endl <<
		endl;

}

void BilEjer::printOwner()
{
	cout << carOwner_;
}

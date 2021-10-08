#pragma once
#include <iostream>
#include <string>

using namespace std;

class BilEjer
{

private:
	string carOwner_, type_;
	int price_;

	string* carOwnerPtn_ = &carOwner_;
	string* typePtn_ = &type_;
	int* pricePtn_ = &price_;

public:
	explicit BilEjer(string carOwner = " ", string type = "You don't own any car", int price = 0);
	void setCarOwner(string owner);
	string getCarOwner();
	void setCarType(string type);
	string getCarType();
	void setCarPrice(int price);
	int getCarPrice();
	void setSpecs();
	void getSpecs();
	void printOwner();

};


#pragma once
#include <iostream>
#include <string.h>
#include "chooser.h"
#include "Player.h"
#include "Wheels.h"

using namespace std;

class Car
{
public:
	Car();
	Car(string, int, string);
	void setOwner(Player&);
	string getOwner();
	void setPrice(int);
	void setWheelType(string);
	void setCarType_(string);
	int getPrice();
	string getWheelType();
	string getCarType();
	const void printInfo();
	void setforSale(int);
	bool getForSale();
private:

	string owner_;
	Wheels wheels_;
	string carType_;
	int price_, carNotExisting_, available_ = 0;
	string* ownerPtr_ = &owner_;
	string* carTypePtr_ = &carType_;
	int* pricePtr_ = &price_;
	int* notExistingPtr_ = &carNotExisting_;

};


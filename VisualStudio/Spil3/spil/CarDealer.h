#pragma once
#include <iostream>
#include <string>
#include "Car.h"

using namespace std;

class CarDealer
{
	
public:
	CarDealer();
	void setCarDetails(Car&);
	string getCarType();
	string getOwner();
	void carSale(Player&, Player&, Car&);
	void const printMenu();

private:
	int price_, sell_ = 1, buy_ = 0, choice_;
	string owner_, carType_;
};


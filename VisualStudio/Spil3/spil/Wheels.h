#pragma once
#include "iostream"
#include "string"

using namespace std;

class Wheels
{
public:
	Wheels();
	void setWheelType(string);
	string getWheelType();

private:
	string wheelType_;
};


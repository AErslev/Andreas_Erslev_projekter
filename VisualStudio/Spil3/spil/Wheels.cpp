#include "Wheels.h"

Wheels::Wheels()
{
	wheelType_ = "Classic";
}

void Wheels::setWheelType(string wheelType)
{
	wheelType_ = wheelType;
}

string Wheels::getWheelType()
{
	return wheelType_;
}

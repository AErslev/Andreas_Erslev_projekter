#include "Person.h"

int Person::numberOfPeople_ = 2;

Person::Person()
{
	y_ = 0;
	m_ = 0;
	d_ = 0;

	date.setDate(y_, m_, d_);
}

Person::Person(int& y, int& m, int& d)
{
	y_ = y; m_ = m; d_ = d;
	date.setDate(y_, m_, d_);
}

int Person::getMyStatic()
{
	return numberOfPeople_;
}

Birthday Person::getDate() const
{
	return date;
}

void Person::printDate() const
{
	date.printDate();
}


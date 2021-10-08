#include "Birthday.h"

Birthday::Birthday()
{
	y_ = 0;
	m_ = 0;
	d_ = 0;
}

Birthday::Birthday(int& y, int& m, int& d)
{
	y_ = y; m_ = m; d_ = d;
}

void Birthday::setDate(int y, int m, int d)
{
	y_ = y;
	m_ = m;
	d_ = d;
}

void Birthday::printDate() const 
{
	cout << y_ << " " << m_ << " " << d_ << endl;
}

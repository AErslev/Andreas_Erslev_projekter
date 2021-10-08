#include "Time.h"

Time::Time()
{
	hour_ = 0;
	minut_ = 0;
	second_ = 0;
}

Time::Time(int hour, int minut, int second)
{
	
	second_ = (second < 60 && second >= 0 ? second : 0);
	minut_ = (minut < 60 && minut >= 0 ? minut : 0);
	hour_ = (hour < 24 && hour >= 0 ? hour : 0);

}

Time Time::operator=(Time& copy) {

	hour_ = copy.hour_;
	minut_ = copy.minut_;
	second_ = copy.second_;

	return *this;

};

bool Time::operator==(Time& equalTo) {

	srand(time(0));
	
	if (this->hour_ == equalTo.hour_ &&
		this->minut_ == equalTo.minut_ &&
		this->second_ == equalTo.second_)
			return true;

	return false;

}

void Time::setRandom()
{
	hour_ = rand() % 24 + 1; minut_ = rand() % 60 + 1; second_ = rand() % 60 + 1;
}

void Time::setTime(int hour, int minut, int second)
{
	second_ = (second < 60 && second >= 0 ? second : 0);
	minut_ = (minut < 60 && minut >= 0 ? minut : 0);
	hour_ = (hour < 24 && hour >= 0 ? hour : 0);

	if (second_ == 0 && minut_ == 0 && hour_ == 0)
		cout << "Time has been reset to | 00 : 00 : 00 |\n" << endl;

}

const void Time::clock()
{
	second_++;

	if (second_ == 60) {
		minut_++;
		second_ = 0;
	}

	if (minut_ == 60) {
		hour_++;
		minut_ = 0;
	}

	if (hour_ == 24)
		hour_ = 0;

}

const void Time::printTime()
{
	cout << "Current time is: "
		<< "| " << setfill('0') << setw(2) << hour_ 
		<< " : " << setfill('0') << setw(2) << minut_ 
		<< " : " << setfill('0') << setw(2) << second_ 
		<< " |\n" << endl;
}

Time::~Time()
{
}


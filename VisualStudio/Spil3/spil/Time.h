#pragma once
#include <iostream>
#include <iomanip>
#include <string>
#include "chooser.h"

class Time
{

public:
	Time();
	Time(int, int, int);
	Time operator=(Time&);
	bool operator==(Time&);
	void setRandom();
	void setTime(int, int, int);
	const void clock();
	const void printTime();
	~Time();

private:
	int hour_, minut_, second_;
	
};


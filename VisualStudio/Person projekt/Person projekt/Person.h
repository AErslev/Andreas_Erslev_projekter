#pragma once
#include <iostream>
#include <string>
#include "Birthday.h"

using namespace std;

class Person
{
public:
	Person();
	Person(int&, int&, int&);
	static int getMyStatic();
	Birthday getDate() const;
	void printDate() const;

private:
	int y_; 
	char m_, d_;
	static int numberOfPeople_;
	Birthday date;
};


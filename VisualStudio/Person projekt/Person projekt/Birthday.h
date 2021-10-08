#pragma once
#include <iostream>
#include <string>

using namespace std;

class Birthday
{

public:
	Birthday();
	Birthday(int& y, int& m, int& d);
	void setDate(int, int, int);
	void printDate() const;

private: 

	int y_, m_, d_;
};


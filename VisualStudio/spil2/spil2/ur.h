#pragma once
#include <iostream>
#include <string>
#include <iomanip>
#include <Windows.h>

using namespace std;

class Tid {

private:

	int s, m, t;

public:

	explicit Tid(int sekund, int minut, int time);
	void clockTime();
	void setTime(int sekund, int minut, int time);
	int getTime(int anmodning);
	void printTid() const;

};
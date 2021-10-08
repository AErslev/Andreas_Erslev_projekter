#pragma once
#include <iostream>
#include <string>
#include "Time.h"
#include "chooser.h"

using namespace std;

class Job
{

public:
	Job();
	void setJob(string);
	void setSalary(int);
	int getSalary();
	double work(Time*);
	static int jobCount;

private:
	string job_;
	int salary_, time_, workHours_;
	double payCheck_;
	Time jobClock;
	string* jobPtr_ = &job_;
	int* salaryPtr_ = &salary_;

};


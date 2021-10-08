#include "Job.h"

int Job::jobCount = 0;

Job::Job()
{

	job_ = "unknown";
	salary_ = 0;
	time_ = 8;
	workHours_ = 0;

	if (jobCount != 0)
		jobChooser(jobPtr_, salaryPtr_);

	jobCount++;

}

void Job::setJob(string job)
{
	job_ = job;
}

void Job::setSalary(int salary)
{
	salary_ = salary;
}

int Job::getSalary()
{
	return salary_;
}

double Job::work(Time* clock)
{

	clock->setTime(6, 0, 0);
	jobClock.setTime(time_, 0, 0);

	for (int n = 0; n < 8; n++) {

		if (jobClock == *clock) {
			workHours_++;
			time_++;
			jobClock.setTime(time_, 0, 0);
		}

		for (int i = 0; i < 3600; i++) {
			clock->clock();
			Sleep(1);
		}

		clock->printTime();

	}

	payCheck_ = workHours_ * salary_;
	workHours_ = 0;

	cout << "You made " << payCheck_ << "$ today\n" << endl;

	return payCheck_;
		
}

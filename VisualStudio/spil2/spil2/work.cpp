#pragma once
#include <iostream>
#include <string>
using namespace std;
#include "work.h"

int work(class Tid *ur, class Karrakter *spiller, int loen, int arbejdsTimer) {

	ur->printTid();

	do  {

		if (ur->getTime(3) > 8 && ur->getTime(3) < 17 && ur->getTime(3) == arbejdsTimer) {

			spiller->moneyEarned(loen);
			arbejdsTimer++;
			ur->printTid();

		}

		else if (ur->getTime(3) < 9 || ur->getTime(3) > 16) {

			arbejdsTimer = 9;
			cout << "Work hours are between 8-16. The current time is: "; ur->printTid(); cout << endl;

		}

	} while (ur->getTime(3) > 8 && ur->getTime(3) < 17);

	return loen;

}
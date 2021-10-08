#include <iostream>
#include <string>
#include <iomanip>
#include <Windows.h>
#include "ur.h"

	Tid::Tid(int sekund, int minut, int time) {

		s = sekund;
		m = minut;
		t = time;

	}

	void Tid::clockTime() {

		s += 1;

		if (s > 59) {
			s = 0;
			m += 1;
		}

		if (m > 59) {
			m = 0;
			t += 1;
		}

		if (t > 23) {
			t = 0;
		}

		Sleep(1);

	}

	void Tid::setTime(int sekund, int minut, int time) {

		s = sekund;

		m = minut;

		t = time;

	}

	int Tid::getTime(int anmodning) {

		if (anmodning == 1)
			return s;

		if (anmodning == 2)
			return m;

		if (anmodning == 3)
			return t;

	}

	void Tid::printTid() const {

		cout << "| " <<
			setfill('0') << setw(2) << t << " : " <<
			setfill('0') << setw(2) << m << " : " <<
			setfill('0') << setw(2) << s << " |\n"
			<< endl;

	}
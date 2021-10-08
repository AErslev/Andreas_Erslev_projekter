#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip> 
#include "windows.h" 

using namespace std;

class Ur {

private:

		int h, m, s, h_pm;

public:

	Ur(int hour, int minut, int second) {

		if (hour < 24 && hour >= 0 && minut < 60 && minut >= 0 && second < 60 && second >= 0) {

			h = hour;
			m = minut;
			s = second;

		}

		else
			cout << "Du har ikke valgt et reelt tidspunkt";

	}

	void setSecond(int second) {

		s = second;

	}

	void setMinut(int minut) {

		m = minut;

	}

	void setHour(int hour) {

		h = hour;

	}

	int setTime(int second) {

		s++;

		if (s == 60)
			m++;

		if (m == 60)
			h++;

		if (h == 24)
			h = 0;

		if (m == 60)
			m = 0;

		if (s == 60)
			s = 0;

		return s;

	}

	int getSecond() {

		if (s == 60)
			s = 0;

		return s;

	}

	int getMinut() {

		return m;

	}

	int getHour() {

		return h;

	}

	void printTimeDigital() {

		cout << setw(2) << setfill('0') << "| " << h << " : " << m << " : " << s << " |" << "\n" << endl;

	}

	void printTimeAnalog() {

		if (h >= 0 && h < 12)
		cout << setw(2) << setfill('0') << "| " << h << " : " << m << " : " << s <<"am" << " |" << "\n" << endl;


		else if (h >= 12 && h < 24) {
			cout << setw(2) << setfill('0') << "| " << h - 12 << " : " << m << " : " << s << " pm" << " |" << "\n" << endl;
		}

		if (h == 24)
			h = 0;

	}

};

int main(void) {

	int hour, minut, second, valg;

	cout << "hvad er klokken?\n" << endl;
	cout << "Time antal: "; cin >> hour;
	cout << "Minut antal: "; cin >> minut;
	cout << "Sekundt antal "; cin >> second;

	Ur tid(hour, minut, second);

	cout << "\nVil du se klokken i digitalt ur eller analogt ur?\n" 
		<< "1 = digital \n2 = analog\n" << "Hvad vaelger du? ";
	cin >> valg;
	
	while (1) {

		switch (valg) {

		case 1:
			tid.printTimeDigital();
			break;

		case 2:
			tid.printTimeAnalog();
			break;
		}

		Sleep(1000);
		second++;
		second = tid.setTime(second);

	}

	return 0;

}
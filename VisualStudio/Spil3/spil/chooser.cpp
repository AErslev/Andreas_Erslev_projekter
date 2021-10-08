#include "chooser.h"

void jobChooser(string* job, int* loen) {

	srand(time(0));

	int wait, chooser;

	cout << "\nLoading job:\n";

	for (int n = 0; n < 5; n++) {
		cout << "Loading... ";
		wait = rand() % 650 + 100;
		chooser = rand() % 5 + 1;
		Sleep(wait);

		switch (chooser) {

		case 1:
			*job = "Kontor arbejder";
			*loen = 120;
			break;

		case 2:
			*job = "Direktør";
			*loen = 240;
			break;

		case 3:
			*job = "Kunstner";
			*loen = 500;
			break;

		case 4:
			*job = "Lektor";
			*loen = 300;
			break;

		case 5:
			*job = "Skole laere";
			*loen = 150;
			break;

		}
	}
	cout << "\n\nYour pre-chosen job is: "
		<< *job << "\nYour salary is: "
		<< *loen << "$ " << "per hour\n"
		<< endl;

}

void setBankAccount(double* saldo, int* pin) {

	srand(time(0));
	int wait;

	cout << "\nLoading bank information:\n";

	for (int n = 0; n < 5; n++) {
		cout << "Loading... ";
		wait = rand() % 650 + 100;
		Sleep(wait);
		*pin = rand() % 9999 + 1000; *saldo = rand() % 25000 + 1;
	}

	cout << endl << "\nYour pre-chosen PIN code is: " << *pin << endl << endl;

}

void setTime(int& hour, int& minut, int& second)
{
	srand(time(0));
	int wait;

	cout << "\nLoading time:\n";

	for (int n = 0; n < 5; n++) {
		cout << "Loading... ";
		wait = rand() % 650 + 100;
		Sleep(wait);
		hour = rand() % 23; minut = rand() % 59; second = rand() % 59;
	}

	cout << "Time is: " << "| " << hour << " : " << minut << " : " << second << " |\n" << endl;

}

void setCar(string* carType, int* carPrice, int* carNotExisting_) {

	srand(time(0));

	int wait, chooser;

	for (int n = 0; n < 5; n++) {
		wait = rand() % 650 + 100;
		chooser = rand() % 14;
		Sleep(wait);


		switch (n) {
		
		case 0: 
			cout << "Loading";
			break;

		case 4:
			cout << " ";
		break;
		
		default:
			cout << ".";
			break;

		}

		switch (chooser) {

		case 1:
			*carType = "Volvo";
			*carPrice = 95000;
			break;

		case 2:
			*carType = "Ferrari";
			*carPrice = 1200000;
			break;

		case 3:
			*carType = "Suzuki";
			*carPrice = 59000;
			break;

		case 4:
			*carType = "Kia";
			*carPrice = 125000;
			break;

		case 5:
			*carType = "Nissan";
			*carPrice = 12500;
			break;

		case 6:
			*carType = "Acura";
			*carPrice = 130000;
			break;

		case 7:
			*carType = "Alfa Romeo";
			*carPrice = 70000;
			break;

		case 8:
			*carType = "Audi";
			*carPrice = 150000;
			break;

		case 9:
			*carType = "BMW";
			*carPrice = 200000;
			break;

		case 10:
			*carType = "Bently";
			*carPrice = 500000;
			break;

		case 11:
			*carType = "Buick";
			*carPrice = 20000;
			break;

		case 12:
			*carType = "Cadillac";
			*carPrice = 100000;
			break;

		case 13:
			*carType = "Chevrolet";
			*carPrice = 140000;
			break;

		default:
			*carType = "Car does not exist";
			*carPrice = 0;
			*carNotExisting_ = 1;
			break;

		}

	}

}
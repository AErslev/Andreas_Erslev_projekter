#include "case.h"

void jobChooser(int Chooser, string *job, int *loen) {

	switch (Chooser) {

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

	cout << "\nYour pre-chosen job is: "
		<< *job << "\nYour salary is: "
		<< *loen << "$ " << "per hour\n"
		<< endl;

}

void setSpecsFunktion(string *carOwnerPtn_, string *typePtn_, int *pricePtn_) {
	
	srand(time(0));
	int wait = rand() % 650 + 100;
	Sleep(wait);
	int Chooser = rand() % 5 + 1;

	string CarOwners[5] = { "Eric", "John", "Tom", "Curt", "Bo" };
	
	if (*carOwnerPtn_ == " ") {

		for (int n = 0; n < Chooser || n == 0; n++) {
			wait = rand() % 300 + 250;
			Sleep(wait);
			Chooser = rand() % 5 + 1;
			// Owner
			switch (Chooser) {

			case 1:
				*carOwnerPtn_ = CarOwners[0];
				break;

			case 2:
				*carOwnerPtn_ = CarOwners[1];
				break;

			case 3:
				*carOwnerPtn_ = CarOwners[2];
				break;

			case 4:
				*carOwnerPtn_ = CarOwners[3];
				break;

			case 5:
				*carOwnerPtn_ = CarOwners[4];
				break;
			}

			//Price / Type
			wait = rand() % 300 + 250;
			Sleep(wait);
			Chooser = rand() % 5 + 1;

			switch (Chooser) {

			case 1:
				*typePtn_ = "Volvo";
				*pricePtn_ = 95000;
				break;

			case 2:
				*typePtn_ = "ferrari";
				*pricePtn_ = 1200000;
				break;

			case 3:
				*typePtn_ = "Suzuki";
				*pricePtn_ = 59000;
				break;

			case 4:
				*typePtn_ = "Kia";
				*pricePtn_ = 125000;
				break;

			case 5:
				*typePtn_ = "Nissan";
				*pricePtn_ = 12500;
				break;
			}
		}

	}

}
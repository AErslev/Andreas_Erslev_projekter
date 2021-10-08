#include "Person.h"
#include "createProfile.h"

int main(void) {
	Person nul;
	Person* People_temp = new Person[Person::getMyStatic() + 1];
	Person* People_list = new Person[Person::getMyStatic() + 1];
	for (int n = 0; n < (Person::getMyStatic()); n++) {
		People_temp[n] = nul;
		People_list[n] = nul;
	}
	int awnser = 1;

	//Personal information
	//string name;
	//int socialSecurityNumber;

	//Birthday
	int year, month, day, i;
	year = 1996; month = 12; day = 4;

	//Bank
	//int saldo, pinCode;

	//Reference
	int& y = year; int& m = month; int& d = day;
	
	//Person** personer = new Person * [Person::getMyStatic()];
	//Person person(y, m, d);
	//Person& people = person;

	//while (awnser == 1) {
	//	cout << "Create new person? For yes, press 1: "; cin >> awnser;
	//	
	//	createProfile(y, m, d);
	//	Person** personer = new Person*[Person::getMyStatic()];
	//	personer[0] = &people;
	//	personer[0]->printDate();
	//	awnser = 0;
	//}

	Person Andreas(y, m, d);
	Andreas.getDate();
	Andreas.printDate();

	return 0;

}
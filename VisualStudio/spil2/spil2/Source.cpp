#include "lotto.h"
#include "karrakter.h"
#include "case.h"
#include "BilForhandler.h"
#include "work.h"

using namespace std;

#define SIZE 6

int main(void)
{

	srand(time(0));

	int t, m, s;  
	t = rand() % 24 + 1; m = rand() % 60 + 1; s = rand() % 60 + 1;
	
	Tid ur(t, m, s);
	ur.clockTime();
	
	string userName, spilLotto, job;
	int age = 0, loen = 0, arbejdsTimer = 9, price, choise, pin;
	int Chooser = rand() % 5 + 1, saldo = rand() % 25000 + 1;
	int lottoTal[SIZE], brugerLottoTal[SIZE], rigtige[SIZE];
	string* jobPtn = &job; int* loenPtn = &loen;

	cout << "Choose your username: "; getline(cin, userName);
	cout << "Choose your age: "; cin >> age;
	cout << "Choose your bank pin code: "; cin >> pin;
	cout << "\nYour pre-chosen saldo is: " << saldo << endl;

	//Job chooser
	jobChooser(Chooser, jobPtn, loenPtn);
	
	Karrakter spiller(userName, age, job, saldo, pin);
	spiller.printOwner();
	spiller.welcome();
	BilForhandler salesMan;
	
	for (int n = 0; n < 5; n++) {
		cout << "\n Loading..." << endl;
		salesMan.selection_[n].setSpecs();
	}

	do {

		do  {
			
			cout << "press key '1' to play lotto | The cost is 100 \n"
				<< "press key '2' to for other options\n" << endl;
			cin >> choise;

			if (choise == 1) {

				price = lotto();
				spiller.moneyEarned(price);

			}

			else if (choise == 2) {

				cout << "Press 1 for bank information" << endl
					<< "Press 2 to go to work" << endl;
				
				cin >> choise;
				
				if (choise == 1) {
					
					spiller.options(pin);

				}

				else if (choise == 2)
					work(&ur, &spiller, loen, arbejdsTimer);

			}

		} while (1);

	} while (1);

	return 0;
}
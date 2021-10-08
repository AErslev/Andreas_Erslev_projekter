#include <iostream>
#include "sorter.h"

#define SIZE 3

int main(void) {

	Sorter<int>* sortInt = new  Sorter<int>;
	Sorter<double>* sortDouble = new  Sorter<double>;
	Sorter<char>* sortChar = new  Sorter<char>;

	int sortArrayInt[SIZE] = { 1, 2, 3 };

	sortInt->sortFunction(sortArrayInt);

	sortInt->print();

	return 0;

}
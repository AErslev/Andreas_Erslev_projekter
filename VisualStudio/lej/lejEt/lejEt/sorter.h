#pragma once
#include <iostream>
using namespace std;

template < typename value >
class Sorter
{
public:
	Sorter();
	~Sorter();
	void sortFunction(value*);
	void print();

private:
	value* arraySorter_;
};

template<typename value>
inline Sorter<value>::Sorter()
{

}

template<typename value>
inline Sorter<value>::~Sorter()
{
	delete[] arraySorter_;
}


template<typename value>
inline void Sorter<value>::sortFunction(value* arrayPtr)
{

	delete[] arraySorter_;

	arraySorter_ = new value[sizeof(arrayPtr) + 1];
	
	for (int n = 0; n < sizeof(arrayPtr); n++)
		arraySorter_[n] = arrayPtr[n];

	for (int n = 0; n < sizeof(arraySorter_); n++) {
	
		if (arrayPtr[n] < arraySorter_[n + 1] && arrayPtr[n] > 0) {
			arraySorter_[n] = arraySorter_[n + 1];
			arraySorter_[n + 1] = arrayPtr[n];
			n = -1;
		}
		
	}
	
}

template<typename value>
inline void Sorter<value>::print()
{
	for (int n = 0; n < (sizeof(arraySorter_) - 1); n++)
		cout << arraySorter_[n] << " ";
}


#pragma once
#include <iostream>
#include <string>
#include "Character.h"
#include "Foes.h"

#include <list>
#include <algorithm>
#include <iterator>

using namespace std;

class Battle
{
public:
	Battle();
	Battle(list<Character>, list<Foes>);
	void attack(double, double);
	void defend(double);
	void setDistance();
	void setTurn();
	void printActionMenu();

private:
	int action_, turn_;
	double health_, shield_;
	list<Character> battleCharacters_; 
	list<Foes> battleFoes_;

};


#pragma once
#include <iostream>
#include <string>

using namespace std;

class Attack
{
public: 
	Attack(double damage, string name);
	Attack(double damage = 0, double mana = 0, string name = "");
	double getDamage() const;
	double getMana() const;
	string getName() const;
	void setID(int ID);
	int getID() const;

private:
	double damage_, mana_;
	string name_;
	int id_;
};


#pragma once
#include <iostream>
#include <string>
#include <time.h>
#include <Windows.h>

using namespace std;

int createCharacter(string& name, string& race, double& health, int& strength, int& mana, double& damage);
void levelUp(string name, double& health, int& strength, int& mana, double& damage, int chosenRace);
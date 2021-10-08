#pragma once
#include "Element.h"

class Song : public Element
{
public:
	Song(string songName = "Unknwon", double length = 0.00, Element empty[] = nullptr, string type = "Song");
	void printInfo() const;

private:
	string name_;
	int length_;
};


#pragma once
#include "Artist.h"

class Band : public Element
{
public:
	Band(string bandName = "Unknown", double empty = 0.00, Element bandMembers[] = nullptr, string type = "Band");
	void printList() const;
	void printInfo() const;
	void printName() const;

private:
	Artist* bandMembers_ = new Artist[0];
};


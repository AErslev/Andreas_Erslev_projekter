#pragma once
#include "Element.h"
#include "Song.h"

class Artist : public Element
{
public:
	Artist(string artistName = "Unknown", double empty = 0.00, Song song[] = nullptr, string type = "Artist");
	void printList() const;
	void printInfo() const;
	void printName() const;

private:

};


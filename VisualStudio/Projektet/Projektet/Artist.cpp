#include "Artist.h"

Artist::Artist(string name, double empty, Song song[], string type) : Element(name, empty, song, type)
{
}

void Artist::printList() const
{
	Element::printList();
}

void Artist::printInfo() const
{
}

void Artist::printName() const
{
}



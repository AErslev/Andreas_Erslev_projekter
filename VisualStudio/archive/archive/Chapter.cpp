#include "Chapter.h"

Chapter::Chapter(string title, int length)
{
	title_ = title;
	length_ = length;
}

void Chapter::setTitle(string title)
{
	title_ = title;
}

string Chapter::getTitle() const
{
	return title_;
}

void Chapter::setLength(int length)
{
	length_ = length;
}

int Chapter::getLength() const
{
	return length_;
}

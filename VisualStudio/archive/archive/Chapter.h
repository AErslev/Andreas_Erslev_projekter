#pragma once
#include <iostream>
#include <string>

using namespace std;

class Chapter
{
public:
	Chapter(string title = "No title", int length = 0);
	void setTitle(string title);
	string getTitle() const;
	void setLength(int length);
	int getLength() const;

private:
	string title_;
	int length_;
};

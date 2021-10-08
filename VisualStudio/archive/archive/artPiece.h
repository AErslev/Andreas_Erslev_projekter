#pragma once
#include <iostream>
#include <string>

using namespace std;

class ArtPiece
{
public:
	ArtPiece(string creator = "Unknown", string title = "Unknown", string type = "No type");
	string getCreator() const;
	void setTitle(string title);
	string getTitle() const;
	string getType() const;
	virtual int getAmount() const;
	virtual void setAmount(int amount);

private:
	string creator_, title_, type_;
	int amount_;
};


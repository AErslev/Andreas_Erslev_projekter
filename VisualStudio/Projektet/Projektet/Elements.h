#pragma once
#include <string>

using namespace std;

class Elements
{
public:
	Elements(string name = "Unknown", double length = 0.00, string type = "Unknown");
	string getName();
	void setName(string name);
	string getType() const;
	void setType(string type);
	void setElementLength(double length);
	double getElementLength() const;
	void setElementSize(int size);
	int getElementSize() const;

private:
	string type_, name_;
	int elementSize_; double length_;
};


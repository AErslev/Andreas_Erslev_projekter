#pragma once
#include <iostream>
#include <string>

using namespace std;

class Element
{
public:
	Element(string name = "Unknown", double length = 0.00, Element elements[] = nullptr, string type = "Unknown");
	string getName();
	void setName(string name);
	string getType() const;
	void setType(string type);
	void setElementLength(int length);
	int getElementLength() const;
	int getElementSize() const;

	void addElement(Element& newElement);
	void removeElement(Element& removeElement, int category);

	void printInfo(int element) const;
	void printList() const;
	void printName() const;

private:
	string type_, name_;
	int elementsSize_; double length_;
	Element* elements_;
};


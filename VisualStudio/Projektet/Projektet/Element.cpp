#include "Element.h"

Element::Element(string name, double length, Element elements[], string type)
{
	name_ = name;
	type_ = type;
	length_ = length;

	elementsSize_ = sizeof(elements) / sizeof(elements[0]);;

	if (elementsSize_ < 1)
		elementsSize_ = 5;

	elements_ = elements;

}


string Element::getName()
{
	return name_;
}

void Element::setName(string name)
{
	name_ = name;
}

string Element::getType() const
{
	return type_;
}

void Element::setType(string type)
{
	type_ = type;
}

void Element::setElementLength(int length)
{
	length_ = length;
}

int Element::getElementLength() const
{
	return length_;
}

int Element::getElementSize() const
{
	return elementsSize_;
}

void Element::addElement(Element& newElement)
{

	elementsSize_++;

	Element* temp = elements_;

	elements_ = new Element[elementsSize_];

	for (int n = 0; n < elementsSize_; n++)
		elements_[n] = temp[n];

	elements_[elementsSize_] = newElement;

	delete[] temp;

}

void Element::removeElement(Element& removeElement, int category)
{
	int tempElementsSize = 0;
	Element* tempElements = elements_;

	for (int n = 0; n < elementsSize_; n++) 
		if ((elements_->getName() != removeElement.getName() && category == 1) || (elements_->getType() != removeElement.getType() && category == 2))
			tempElementsSize++;

	elements_ = new Element[tempElementsSize];

	for (int n = 0, i = 0; n < elementsSize_; n++)
		if ((tempElements->getName() != removeElement.getName() && category == 1) || (tempElements->getType() != removeElement.getType() && category == 2)) {
			elements_[i] = tempElements[n];
			i++;
		}
	
	delete[] tempElements;


}

void Element::printInfo(int element) const
{
	cout << elements_[element].getName() << endl << elements_[element].getType() << endl << endl;
}

void Element::printList() const
{

	for (int n = 0; n < 2; n++) {

		cout << " - " << elements_[n].getName() << endl << " - " << elements_[n].getType() << endl << endl;
	}


}

void Element::printName() const
{
	cout << name_ << endl << endl;
}

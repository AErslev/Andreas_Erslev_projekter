#include "Elements.h"

Elements::Elements(string name, double length, string type)
{
    name_ = name;
    length_ = length;
    type_ = type;
}

string Elements::getName()
{
    return name_;
}

void Elements::setName(string name)
{
    name_ = name;
}

string Elements::getType() const
{
    return type_;
}

void Elements::setType(string type)
{
    type_ = type;
}

void Elements::setElementLength(double length)
{
    length_ = length;
}

double Elements::getElementLength() const
{
    return length_;
}

void Elements::setElementSize(int size)
{
    elementSize_ = size;
}

int Elements::getElementSize() const
{
    return elementSize_;
}

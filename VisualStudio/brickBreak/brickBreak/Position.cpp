#include "includes.h"

Position::Position(char positionX, char positionY)
{

	positionX_ = positionX;
	positionY_ = positionY;

}

void Position::setPositionX(int position)
{
	positionX_ = position;
}

int Position::getPositionX() const
{
	return positionX_;
}

void Position::setPositionY(int position)
{
	positionY_ = position;
}

int Position::getPositionY() const
{
	return positionY_;
}

void Position::printStart() const
{

}

void Position::printDeath() const
{
	cout << endl << "You died!" << endl;
}

#pragma once

class Position
{

public:
	Position(char positionX, char positionY);
	void setPositionX(int position);
	int getPositionX() const;
	void setPositionY(int position);
	int getPositionY() const;
	void printStart() const;
	void printDeath() const;

private:
	int positionX_;
	int positionY_;
	
};


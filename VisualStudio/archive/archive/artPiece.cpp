#include "artPiece.h"

ArtPiece::ArtPiece(string creator, string title, string type)
{
	creator_ = creator;
	title_ = title;
	type_ = type;
}

string ArtPiece::getCreator() const
{
	return creator_;
}

string ArtPiece::getTitle() const
{
	return title_;
}

string ArtPiece::getType() const
{
	return type_;
}

int ArtPiece::getAmount() const
{
	return amount_;
}

void ArtPiece::setAmount(int amount)
{
	amount_ = amount;
}


void ArtPiece::setTitle(string title)
{
	title_ = title;
}



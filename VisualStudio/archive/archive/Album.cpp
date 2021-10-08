#include "Album.h"

Album::Album(string artist, string title, int numberOfSongs) : ArtPiece(artist, title, "Album")
{
	numberOfSongs_ = numberOfSongs;
}

int Album::getAmount()
{
	return numberOfSongs_;
}

void Album::setAmount(int amount)
{
	numberOfSongs_ = amount;
}

void Album::addSong(Song& newSong)
{
	songs_.push_back(newSong);
	numberOfSongs_++;
}


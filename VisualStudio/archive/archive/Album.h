#pragma once
#include <iostream>
#include <string>
#include <vector>
#include <iterator>
#include "Chapter.h"
#include "artPiece.h"
#include <vector>
#include "Song.h"

class Album : public ArtPiece
{
public:
	Album(string artist, string title, int numberOfSongs = 0);
	
	int getAmount();
	void setAmount(int amount);

	void addSong(Song& newSong);

private:
	string title_;
	int numberOfSongs_;
	vector<Song> songs_;
};


#pragma once
#include <iostream>
#include <string>
#include <vector>
#include <iterator>
#include "Chapter.h"
#include "artPiece.h"

using namespace std;

class Book : public ArtPiece
{
public:
	Book(string author, string title, int pageQuantity = 0, int numberOfChapters = 0);
	void addPageQuantity(int pageQuantity);
	int getPageQuantity();
	int getAmount() const;
	void setAmount(int insertChapter);
	void addChapter(Chapter& newChapter);

private:
	int pageQuantity_, numberOfChapters_;
	vector<Chapter> chapters_;
};


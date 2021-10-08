#include "Book.h"

Book::Book(string author, string title, int pageQuantity, int numberOfChapters) : ArtPiece(author, title, "Book")
{
	pageQuantity_ = pageQuantity;
	numberOfChapters_ = numberOfChapters;
}

void Book::addPageQuantity(int pageQuantity)
{
	pageQuantity_ += pageQuantity;
}

int Book::getPageQuantity()
{
	return pageQuantity_;
}

int Book::getAmount() const
{
	return numberOfChapters_;
}

void Book::setAmount(int insertChapter)
{
	numberOfChapters_ = insertChapter;
}

void Book::addChapter(Chapter& newChapter)
{
	chapters_.push_back(newChapter);
	pageQuantity_ += newChapter.getLength();
	numberOfChapters_++;
	
}

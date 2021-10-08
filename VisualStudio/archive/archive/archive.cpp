#include "archive.h"

Archive::Archive()
{
}

string Archive::getCreator(string title)
{
    for (itr = collection_.begin(); itr != collection_.end(); itr++) {
        if (title == (*itr).getTitle())
            return (*itr).getCreator();
    }
}

string Archive::getTitle(string creator)
{
    for (itr = collection_.begin(); itr != collection_.end(); itr++) {
        if (creator == (*itr).getCreator())
            return (*itr).getTitle();
    }
}

void Archive::setTitle(string title, string newTitle)
{
    for (itr = collection_.begin(); itr != collection_.end(); itr++) {
        if (title == (*itr).getTitle())
            (*itr).setTitle(newTitle);
     }
}

string Archive::getType(string creator, string title) 
{
    for (itr = collection_.begin(); itr != collection_.end(); itr++) {
        if (title == (*itr).getTitle() || creator == (*itr).getCreator())
            return (*itr).getType();
            
    }
}

void Archive::printCreator(string title)
{

    for (itr = collection_.begin(); itr != collection_.end(); itr++) {
        if (title == (*itr).getTitle())
            cout << "Creator: " << (*itr).getCreator() << endl << endl;

    }
}

void Archive::printTitle(string creator)
{
    for (itr = collection_.begin(); itr != collection_.end(); itr++) {
        if (creator == (*itr).getCreator())
            cout << "Title: " << (*itr).getTitle() << endl << endl;

    }
}

void Archive::printAmount(string title, string creator)
{
    for (itr = collection_.begin(); itr != collection_.end(); itr++) {
        if (title == (*itr).getTitle() || creator == (*itr).getCreator() || title == (*itr).getCreator())
            cout << (*itr).getAmount() << endl << endl;
    }
}

void Archive::printInfo(string title, string creator)
{
    for (itr = collection_.begin(); itr != collection_.end(); itr++) {
        if (title == (*itr).getTitle() || creator == (*itr).getCreator() || title == (*itr).getCreator())
            cout << "Title: " << (*itr).getTitle() << endl
            << "Creator: " << (*itr).getCreator() << endl
            << "Type: " << (*itr).getType() << endl << endl;
    }
}

void Archive::addArtpiece(ArtPiece& artPiece)
{
    collection_.push_back(artPiece);
}

void Archive::updateArchive(ArtPiece& artPiece)
{
    for (itr = collection_.begin(); itr != collection_.end(); itr++) {
        if ((*itr).getAmount() != artPiece.getAmount())
            (*itr).setAmount(artPiece.getAmount());
    }
}

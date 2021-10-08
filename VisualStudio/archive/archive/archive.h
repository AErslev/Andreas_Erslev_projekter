#pragma once
#include <iostream>
#include <string>
#include <vector>
#include <iterator>
#include "artPiece.h"

using namespace std;

class Archive
{
public:
	Archive();
	string getCreator(string title);
	string getTitle(string creator);
	void setTitle(string title, string newTitle);
	string getType(string creator, string title);

	void printCreator(string title);
	void printTitle(string creator);
	void printAmount(string title = " ", string creator = " ");
	void printInfo(string title = " ", string creator = " ");
	
	void addArtpiece(ArtPiece& artPiece);
	void updateArchive(ArtPiece& artPiece);

private:
	string creator_;
	vector<ArtPiece> collection_;
	vector<ArtPiece>::iterator itr;
	
};


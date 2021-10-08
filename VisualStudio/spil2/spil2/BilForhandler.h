#pragma once
#include <string>
#include <iostream>
#include "bilEjer.h"

using namespace std;

class BilForhandler : public BilEjer {

private:

public:
	explicit BilForhandler();
	BilEjer selection_[5];
	
};


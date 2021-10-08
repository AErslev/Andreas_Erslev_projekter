#include "raspberryPie.h"
#include "screen.h"

class Snake {

public:


private:


};



int main(void)
{
	if (!Open())
	{
		printf("Error with connection\n");
		exit(1);
	}

	printf("Connected to Raspberry Pi\n");
	// To do your code


	screen();

	return 0;
}
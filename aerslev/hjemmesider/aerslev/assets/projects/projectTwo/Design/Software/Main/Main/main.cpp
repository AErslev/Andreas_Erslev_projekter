/*
 * Main.cpp
 *
 * Created: 24-04-2020 12:57:02
 * Author : MadsMorratz
 */ 

#include <avr/io.h>


int main(void)
{
   printMenu();

   while (1) 
    {
		//getch();
		 //while (trueinput = false)
		//{
			//if (getch != 1 | 2 | 3 | 4 | 5)
			//{
				//printwronginput();
			//}
			//else 
			//{
				//int choice_ = getch;
				//trueinput = true;
			//}
		// }
		switch (getch())
		{
			case 1: 
			// code 
			runModeOne();
			printRunModeOne();
			break;
			
			case 2:
			// code
			runModeTwo();
			printRunModeTwo();
			break;
			
			case 3:
			// code
			adjustModeTwo();
			printAdjustModeTwo();
			break;
			
			case 4:
			// code
			deactivateMode();
			printDeactivateMode();
			break;
			
			case 5:
			// code
			exit(1);
			break;
			
			default: 
			printWrongInput();
			break;
		}
		
    }
}


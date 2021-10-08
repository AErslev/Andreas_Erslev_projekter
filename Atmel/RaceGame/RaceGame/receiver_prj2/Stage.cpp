/*
 * Stage.cpp
 *
 * Created: 14-07-2020 15:03:33
 *  Author: andre
 */ 

#include "Stage.h"

void printStage(int& placement, int& goal) {
	
	int stageWidth = 6, stageHeight = 27, carWidth = 7, carHeight = 3; 
	int n, i, k = 0, q;
		
	for (n = 0; n < stageHeight; n++) {
		
		for (i = 0; i < stageWidth - 1; i++) {
			
			Serial.print("*");
			
			if (goal == i) 
				Serial.print("   *   ");
			
			else
				for (k = 0; k < carWidth; k++)
					Serial.print(" ");	
		
		} 
		
		delay(500);
		
		Serial.println("*"); k = 0;
	
	}
	
	for (n = 0; n < carHeight; n++) {
		
		for (i = 0; i < stageWidth - 1; i++ ) {
			
			Serial.print("*");
			
			if (placement == i)
			k++;
			
			switch (k) {
				case 1:
				Serial.print("   *   ");
				k++;
				break;
				
				case 3:
				Serial.print("  * *  ");
				k++;
				break;
				
				case 5:
				Serial.print(" * * * ");
				k = 0;
				break;
				
				default:
				for (q = 0; q < carWidth; q++)
				Serial.print(" ");
				break;
			}
			
		}
		
		Serial.println("*");
		
	}

	
}

/*Begining of Auto generated code by Atmel studio */
#include <Arduino.h>

/*End of auto generated code by Atmel studio */


//Beginning of Auto generated function prototypes by Atmel Studio
//End of Auto generated function prototypes by Atmel Studio

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#include "init.h"
#include "Stage.h"

int placement = 2;
int goal = 2;
int endGame = 1;

//Set interrupts - controls
ISR(INT2_vect) {
	
	if (placement < 4)
		placement++;

}

ISR(INT3_vect) {
	
	if (placement > 0)
		placement--;

}

void setup() {
  // put your setup code here, to run once:
	Serial.begin(9600); // opens serial port, sets data rate to 9600 bps
	initInterrupt();
	initPortB();
	printStage(placement, goal);
}

void loop() {
  // put your main code here, to run repeatedly:
	
	if (endGame != -1){
		goal = rand() % 4;
		printStage(placement, goal);
	}
	
	if (placement != goal && endGame != -1) { 
		Serial.print("\n\nYou lost");
		endGame = -1;
	}
	
}

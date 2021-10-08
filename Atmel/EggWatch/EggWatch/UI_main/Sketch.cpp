/*Begining of Auto generated code by Atmel studio */
#include <Arduino.h>

/*End of auto generated code by Atmel studio */

#include <avr/io.h>
#define  F_CPU 16000000
#include <util/delay.h>
//Beginning of Auto generated function prototypes by Atmel Studio
//End of Auto generated function prototypes by Atmel Studio



int incomingByte = 0; // for incoming serial data

void setup() {
  Serial.begin(9600); // opens serial port, sets data rate to 9600 bps
  Serial1.begin(9600);
  Serial2.begin(9600);
}
volatile unsigned char input = 0;
volatile unsigned int clockSec = 0, clockMin = 0, clockHour = 0;
volatile unsigned char stopTime = 0, mask = 0b00100000;

void initPorts(){
	
	DDRA = 0;
	DDRB = 0xFF;
	PORTB = 0;
	
	TCCR1A = 0b10000011;
	TCCR1B = 0b00000001;
	
}

void serialFlush()  {
	_delay_ms(500);
	while(Serial.available() > 0) {
		char buffer = Serial.read();
	}
}

void eggTimer() {
	
	while (stopTime != '1') {
		PORTB = clockSec;
		_delay_ms(1000);
		clockSec++;
		
	}
	
}

void loop() {
	
	serialFlush();

	initPorts();

	eggTimer();

}

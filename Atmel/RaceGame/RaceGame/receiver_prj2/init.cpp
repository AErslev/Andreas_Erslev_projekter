/*
 * init.cpp
 *
 * Created: 14-07-2020 14:49:14
 *  Author: andre
 */ 

#include "init.h"

void initPortB() {
	DDRB = 255; // Open Port B
	PORTB = 0; // Set PortB to 0
}

void initInterrupt() {
	EIMSK = 0b00001100;    // External interupt, INT2/INT3
	EICRA = 0b11110000;
	EICRB = 0b00000000;    // low level INT interrupt, default
	sei();
}
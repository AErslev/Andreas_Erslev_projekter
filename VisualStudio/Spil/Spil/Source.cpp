#pragma comment(lib, "RaspberryPI.lib")
#include <stdio.h>
#include <stdlib.h>
#include <RaspberryDLL.h>

#include <iostream>
#include <string>
#include <iomanip>
#include <Windows.h>

using namespace std;

class Tid {

private:

	int s, m, t;

public:

	Tid(int sekund, int minut, int time) {

		s = sekund;
		m = minut;
		t = time;

	}

	Tid() {

		s = 0;
		m = 0;
		t = 0;

	}

	void clockTime(){

		s += 1;

		if (s == 60) {
			s = 0;
			m += 1;
		}

		if (m == 60) {
			m = 0;
			t += 1;
		}

		if (t == 24) {
			t = 0;
		}

		Sleep(1000);

	}

	void setTime (int sekund, int minut, int time) {

		s = sekund;

		m = minut;

		t = time;

	}

	int getTime(int anmodning){

		if (anmodning == s)
			return s;

		if (anmodning == m)
			return m;

		if (anmodning == t)
			return t;

	}

	void printTime() const{

		cout << "| " <<
			setfill('0') << setw(2) << t << " : " <<
			setfill('0') << setw(2) << m << " : " <<
			setfill('0') << setw(2) << s << " |\n"
			<< endl;

	}

};

class PersonProfil {

private:

	int PTR; //PTR = Pente Til Rådighed
	string bil, navn;

public:

	PersonProfil(int startPTR, string startBil, string profilNavn) {

	PTR = startPTR;
	bil = startBil;
	navn = profilNavn;

	}

	void setBil(string nyBil) {

		bil = nyBil;

	}

	string getBil() {

		return bil;

	}

	void setSaldo(int nyePTR) {

		PTR = nyePTR;

	}

	int getSaldo() {

		return PTR;

	}

	string getNavn() {

		return navn;

	}

};

class Job {

private:

	int timeLoen;
	string direktoer, HR, arbejder, stilling, navn;


public:

	Job(string startStilling, string PersonNavn) {

		if (startStilling == direktoer)
			timeLoen = 250;
		else if (startStilling == HR)
			timeLoen = 175;

		else if (startStilling == arbejder)
			timeLoen = 115;

		else 
			timeLoen = 100;

		navn = PersonNavn;

	}

	void setLoen(int nyLoen) {
	
		timeLoen = nyLoen;
	
	}

	void setStilling(int nyStilling) {

		stilling = nyStilling;

	}

	string getStilling() {

		return stilling;

	}

	int getLoen() {

		return timeLoen;

	}

	void printNyStilling() const {

		cout << "Tillykke med din nye stilling som " << stilling << endl;

	}

	void printNyLoen() const {

		cout << "Din nye time loen ligger på " << timeLoen << endl;

	}


};

class BilForhandler {

private:

	int pris = 0;
	string maerke;

public:

	BilForhandler(int startBilejer, int startPris) {
	
		if (startBilejer == 0) {
			maerke = "Du ejer ikke en bil i øjeblikket";
			pris = startPris;
		}

		else if (startBilejer == 1) {
			maerke = "Volvo";
			pris = startPris;
		}

		else if (startBilejer == 2) {
			maerke = "Ford";
			pris = startPris;
		}

		else if (startBilejer == 3) {
			maerke = "Kia";
			pris = startPris;
		}

		else if (startBilejer == 3) {
			maerke = "BMW";
			pris = startPris;
		}

		else if (startBilejer == 4) {
			maerke = "Ferrari";
			pris = startPris;
		}

	}

	void bilEjer(int bilEjer) {

		if (bilEjer == 0)
			cout << maerke << endl;

		else if (bilEjer == 1)
			cout << "Din nuvaerende bil er en: " << maerke << endl;

		else if (bilEjer == 2)
			cout << "Din nuvaerende bil er en: " << maerke << endl;

		else if (bilEjer == 3)
			cout << "Din nuvaerende bil er en: " << maerke << endl;

		else if (bilEjer == 3)
			cout << "Din nuvaerende bil er en: " << maerke << endl;

		else if (bilEjer == 4)
			cout << "Din nuvaerende bil er en: " << maerke << endl;

	}

};

class BankKonto {

private:

	int saldo, transaktioner;
	string saldoUdskrift, transaktionerUdskrift;

public:



};

void lavProfiler(string stilling, int PTR, string Navn, int bilMaerke, int pris) {

	PersonProfil profilEtPerson(PTR, stilling, Navn);
	Job profilEtJob(stilling, Navn);
	BilForhandler profilEtBil(bilMaerke, 2500);

}

int main(void)
{
	if (!Open())
	{
		printf("Error with connection\n");
		exit(1);
	}

	int saldo;

	printf("Connected to Raspberry Pi\n");
	// To do your code
	int PTR = 12120, bilMaerke = 2, pris = 121, opretProfiler = 1;
	string job, Navn = "Anders", navn, stilling = "Arbejder";
	Tid ur(5,5,5);


	switch (opretProfiler) {

	case 1:
		lavProfiler(stilling, PTR, Navn, bilMaerke, pris);
		break;

	}

	while (1) {

		ur.printTime();
		ur.clockTime();

	}

	return 0;
}
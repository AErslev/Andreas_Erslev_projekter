#include "Element.h"
#include "Song.h"
#include "Artist.h"
#include "Band.h"

int main() {

	Element test;
	Song testSang("TestSong", 8.2);
	Song testSangTo("TestSangTo", 7.4);
	Song testSange[2];
	testSange[0] = testSang;
	testSange[1] = testSangTo;
	Artist testKunstner("Anders", 0.00, testSange);
	Band testBand;

	testKunstner.printList();

	return 0;

}
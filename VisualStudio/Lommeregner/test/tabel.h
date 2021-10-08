/*VENTETID SCRIPT*/
void delay(int number_of_seconds)
{
	// Converting time into milli_seconds 
	int milli_seconds = 500 * number_of_seconds;

	// Stroing start time 
	clock_t start_time = clock();

	// looping till required time is not acheived 
	while (clock() < start_time + milli_seconds);
}
/*VENTETID AFSLUTNING*/

int tabel() {

	int tabel1, tabel2 = 1, i;

	printf_s("\nHvilken tabel vil du gerne have vist? "); scanf_s("%d", &tabel1);
	printf_s("\nDu for vist %d tabellen\n\n", tabel1);

	for (i = 1; i <= 10; i++) {

		if (i < 10) {
			tabel2 = i * tabel1;
			printf_s("%d : ", tabel2);

			delay(1);
		}

		else {
			tabel2 = i * tabel1;
			printf_s("%d \n\n", tabel2);

			delay(1);
		}
	}

	return tabel2;
}
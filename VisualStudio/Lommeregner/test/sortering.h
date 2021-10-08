int sortering() {

	int antal;

	do {
		printf_s("\nHvor mange tal vil du sortere? Du kan sortere op til 100 tal: ");
		 scanf_s("%d", &antal);

		if (antal > 100) {
			printf_s("\nDu har intastet for mange tal til sortering. Tallet skal vaere mellem 1 og 100. Proev igen.\n");
		}

		else if (antal < 1) {
			printf_s("\nDu har indtastet et 0 eller et negativt tal. Tallet skal vaere mellem 1 og 100. Proev igen.\n");
		}
	} while (antal < 1 || antal > 100);
	
	printf("\nIndtast dit foerste tal: ");

	int i, n, maximum, numbers[100];

	for (i = 0; i < antal; i++)
	{

		scanf_s("%d", &numbers[i]);

		if (i < antal - 1) {
			printf("\nDu har indtastet: %d tal \n", i + 1);
			printf("Indtast dit naeste nummer: ");
		}

		else {
			printf_s("\n\nDu har indtastet %d tal i alt \n\nHer ser du dine tal sorteret fra hoejest til lavest: \n", i + 1);
		}

	}

	for (i = 0; i < antal; i++) {

		maximum = numbers[0];

		for (n = 1; n <= antal; n++) {


			if (numbers[n] > maximum)
			{
				maximum = numbers[n];
			}

		}

		for (n = 0; n < antal; n++) {

			if (maximum == numbers[n]) {
				numbers[n] = 0;
				break;
			}

		}

		if (i < antal - 1) {
			printf_s("%d : ", maximum);
		}

		else {
			printf_s("%d", maximum);
		}

	}

	return 0;

}

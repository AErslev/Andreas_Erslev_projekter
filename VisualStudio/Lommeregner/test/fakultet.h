int fakultet() {

	long long int i, n = 1, antal;

	printf_s("Hvilket tal (n) vil du se fakulteten af? "); scanf_s("%lli", &antal);
	printf_s("Du valgte at se fakulteten af: %lli\n\n", antal);

	printf_s("Se udviklingen: \n\n");

	for (i = antal; i != 0; i--) {

		n *= i;

		printf_s("n = %lli | i = %lli\n\n", n, i);
	}

	printf_s("Fakultet !%lli er lig med %lli", antal, n);

	return 0;
}
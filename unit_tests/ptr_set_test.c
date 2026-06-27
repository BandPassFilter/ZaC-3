void main() {
	char _io *uart = 0;
	int *ptrtest = 1024;
	*ptrtest = 65;
	int loop = 1;
	while (loop == 1) {
		if (*ptrtest > 20) {
			if (*ptrtest < 127) {
				*uart = *ptrtest;
			}
		}
		*ptrtest = *ptrtest + 1;
	}
}

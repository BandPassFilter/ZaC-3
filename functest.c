int func_b(int a) {
	return a + 1;
}

int func_a(int a, int b) {
	int c = 0;
	c = a + b;
	return c;
}

int func_c() {
	return 5;
}

void main() {
	char *debug = 9000000;
	*debug = 0;

	char *test_char_ptr = 3000;
	*test_char_ptr = 4;

	int a;
	func_a(1, 2);
	
}
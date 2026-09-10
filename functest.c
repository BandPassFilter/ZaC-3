int func_b(int a) {
	return a;
}

int func_a(int a) {
	return a;
}

void main() {
	char *debug = 9000000;
	*debug = 0;
	func_a(func_b(5));
}
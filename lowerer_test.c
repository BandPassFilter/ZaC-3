int func(int a, int b) {
    int c = 1;
    return a;
}

void main() {
	char *debug = 9000000;
	*debug = 0;
    int a = 1 + 2 + 3;
    int b = 5;
    int c = 0;
    a = 3 + 4 - b;
    if (a == 1) {
        a = 3;
    }
    c = func(a+123, b);
    func(523+b, a);
    a = func(c, b+a);

    while (a == 0) {
        a = 1;
    }

    for (a = 0; a < 5; a = a + 1) {
        a = 1;
    }
}

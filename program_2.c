int func(int x, int y) {
    int test;
    test = 0;
    test = test + 1;
    func(test, test);
}

int myfunc() {
    int a;
}

void main() {
    int a;
    int b;
    a = 1;
    b = func(a+2, myfunc()+b);
}
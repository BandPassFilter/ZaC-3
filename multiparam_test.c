int add(int a, int b, int c) {
    return a + b + c;
}

void main() {
    int a = 1;
    int b = 2;
    int *ptr = 1000;
    *ptr = 3;
    add(a, b, (*ptr) + (*ptr));
}

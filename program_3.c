void func() {
    int a = 1;
    int b = 1;
    int c = 0;
    int i = 0;
    while (i < 5) {
        c = a + b;
        a = b;
        b = c;
        i = i + 1;
    }
}

void main() {
    func();
}
void func() {
    int a = 1;
    int b = 1;
    int c = 0;
    int i = 0;
    for (int i = 0; i < 5; i = i + 1) {
        c = a + b;
        a = b;
        b = c;
    }
}

void main() {
    func();
}
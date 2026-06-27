void func(char _data *x) {
    char _io *uart = 0;
    int test;
    while (*x != 0) {
        *uart = *x;
        x = x + 1;
    }
}

void main() {
    char _data *string = "hello world\n";
    func(string);
}
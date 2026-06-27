void print(char _data *str) {
    char _io *uart = 0;
    char test;
    char another_test;
    while (*str > 0) {
        *uart = *str;
        str = str + 1;
    }
}

void main() {
    char _data *x = "Hello world\n";
    char _data *y = "Hello again!\n";
    print(x);
    print(y);
}

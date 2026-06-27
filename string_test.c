
void main() {
    char _data *x = "Hello world\n";
    char _io *uart = 0;
    while (*x > 0) {
        *uart = *x;
        x = x + 1;
    }
}

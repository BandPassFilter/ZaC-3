

void main() {
    char *x = "Hello, World!\n";
    char *uart;
    uart = 0;
    while (*x > 0) {
        *uart = *x;
        x = x + 1;
    }
}

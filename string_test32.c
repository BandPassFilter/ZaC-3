char get_char() {
    char *uart = 1245184;
    return *uart;
}

void print_char(char value) {
    char *uart = 1245184;
    *uart = value;
}

void print(char *str) {
    char *uart = 1245184;
    char current_char;
    while (*str > 0) {
        current_char = *str;
        print_char(current_char);
        str = str + 1;
    }
}

void main() {
	char *debug = 9000000;
	
    char *x = "Hello, World!\n";
    char *uart;
    uart = 1245184;
    print(x);
}

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
    char *string = "Test string\n";
    char *string_b = "Test string\n";
    print(string_b);
}

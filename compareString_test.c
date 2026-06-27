int compareString(char _data *str_a, char _data *str_b) {
    int i = 0;
    while (*(str_a + i) == *(str_b + i)) {
        if (*(str_a + i) == 0) {
            return 1;
        }
        i = i + 1;
    }
    return 0;
}

void main() {
    char _data *test_a = "string_a";
    char _data *test_b = "string_a";
    
    compareString(test_a, test_b);
}
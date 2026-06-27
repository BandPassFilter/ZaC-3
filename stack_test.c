void main() {
    int a;
    int b;
    a = 2;
    b = 5;
    a = ((b+2) + 3) - a + 2 - (b + a);
    while (a < 5) {
        a = a + 1;
    }
    char _data *string = "\ntest string\n";
    char _io *c;
    c = 0;
    while (*string > 0) {
        *c = *string;
        string = string + 1;
    }
    char test;
    char *mem_ptr = 0;
    test = 0;
    while (1 == 1) {
        if ((test > 20) && (test < 127)) {
            *c = test;
        }
        test = test + 1;
    }
}

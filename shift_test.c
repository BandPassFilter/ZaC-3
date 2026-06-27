void print_char(char x) {
    char _io *uart = 0;
    *uart = x;
}

void print_hex(int x) {
    char temp;
    char temp_b;
    temp = x >> 12;
    temp = temp & 15;
    temp_b = temp;
    temp = temp_b + 48;
    if (temp_b > 9) {
        temp = temp_b + 55;
    }
    print_char(temp);
    temp = x >> 8;
    temp = temp & 15;
    temp_b = temp;
    temp = temp_b + 48;
    if (temp_b > 9) {
        temp = temp_b + 55;
    }
    print_char(temp);
    temp = x >> 4;
    temp = temp & 15;
    temp_b = temp;
    temp = temp_b + 48;
    if (temp_b > 9) {
        temp = temp_b + 55;
    }
    print_char(temp);
    temp = x;
    temp = temp & 15;
    temp_b = temp;
    temp = temp_b + 48;
    if (temp_b > 9) {
        temp = temp_b + 55;
    }
    print_char(temp);
}



void cr() {
    char temp = 10;
    print_char(temp);
    temp = 13;
    print_char(temp);
}

int multiply(int a, int b) {
    int result = 0;
    for (int i = 0; i < b; i = i + 1) {
        result = result + a;
    }
    return result;
}

int divide(int a, int b) {
    int result = 0;
    int diff = a;
    while (diff < 32768) {
        diff = diff - b;
        result = result + 1;
    }
    return result;
}

int mod(int a, int b) {
    int result = 0;
    int diff = a;
    while (diff < 32768) {
        diff = diff - b;
        result = result + 1;
    }
    result = diff + b;
    return result;
}

void main() {
    int a = 3;
    int b = 2;
    int c = 1;
    cr();
    int not_prime = 0;

    while (a < 20000) {
        not_prime = 0;
        while (b < a) {
            c = mod(a, b);
            if (c == 0) {
                not_prime = 1;
            }
            b = b + 1;
        }
        if (not_prime == 0) {
            print_hex(a);
            cr();
        }
        a = a + 1;
        b = 2;
    }
    cr();
}

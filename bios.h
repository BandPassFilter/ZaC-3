// Emulator BIOS

void print_char(char value) {
    char *uart = 1245184;
    *uart = value;
}

char get_char() {
    char *uart = 1245184;
    return *uart;
}

int get_hex_int(char c) {
    char *hex_to_dec = "0123456789       :;<=>?";
    int number = *(hex_to_dec + c - 48) - 48;
    return number;
}

void cr() {
    char temp = 10;
    print_char(temp);
    temp = 13;
    print_char(temp);
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

void print_hex_byte(char x) {
    char temp;
    char temp_b;
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

void print_hex(int x) {
    char temp;
    char temp_b;
    for (int i = 16; i > 0; i = i - 4) {
        temp = x >> (i - 4);
        temp = temp & 15;
        temp_b = temp;
        temp = temp_b + 48;
        if (temp_b > 9) {
            temp = temp_b + 55;
        }
        print_char(temp);
    }
}

void print_int_hex(int x) {
    print_hex(x >> 16);
    print_hex(x & 65535);
}

void print_bcd(int x) {
    int bcd_a;
    int bcd_b;
    int temp_x;

    temp_x = x;
    bcd_a = 0;
    bcd_b = 0;

    int bcd_a_carry = 0;
    int bcd_b_carry = 0;

    for (int i = 0; i < 16; i = i + 1) {
        if ((bcd_a & 15) > 4) {
            bcd_a = bcd_a + 3;
        }
        if ((bcd_a & 240) > 64) {
            bcd_a = bcd_a + 48;
        }
        if ((bcd_a & 3840) > 1024) {
            bcd_a = bcd_a + 768;
        }
        if ((bcd_a & 61440) > 16384) {
            bcd_a = bcd_a + 12288;
        }
        if ((bcd_b & 15) > 4) {
            bcd_b = bcd_b + 3;
        }
        
        if ((temp_x & 32768) == 32768) {
            bcd_a_carry = 1;
        }
        if ((temp_x & 32768) == 0) {
            bcd_a_carry = 0;
        }
        if ((bcd_a & 32768) == 32768) {
            bcd_b_carry = 1;
        }
        if ((bcd_a & 32768) == 0) {
            bcd_b_carry = 0;
        }
        temp_x = temp_x << 1;
        bcd_a = bcd_a << 1;
        bcd_a = bcd_a | bcd_a_carry;
        bcd_b = bcd_b << 1;
        bcd_b = bcd_b | bcd_b_carry;
        

    }
        
    char temp_print = 0;
    int not_leading_zero = 0;

    temp_print = (bcd_b & 15) + 48;
    if (temp_print != 48) {
        not_leading_zero = 1;
        print_char(temp_print);
    }
    if (temp_print == 48 && not_leading_zero == 1) {
        print_char(temp_print);
    }

    for (i = 16; i > 0; i = i - 4) {
        temp_print = ((bcd_a >> (i - 4)) & 15) + 48;
        if (temp_print != 48) {
            not_leading_zero = 1;
            print_char(temp_print);
        }
        if (temp_print == 48 && not_leading_zero == 1) {
            print_char(temp_print);
        }
    }
    if (not_leading_zero == 0) {
        print_char(48);
    }
}

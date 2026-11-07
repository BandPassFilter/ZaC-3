int syscall_execute(int func_number, int arg0, int arg1, int arg2, int arg3) {
    // R16 - R20 = Syscall arguments / returns
    // R16 = function number
    char *debug = 9000000;
    //*debug = 0;

    static int sfunc = func_number;
    static int sarg0 = arg0;
    static int sarg1 = arg1;
    static int sarg2 = arg2;
    static int sarg3 = arg3;
    static int return_value = 0;

    asm("movi r16, [dp + syscall_execute_sfunc] ;GET");
    asm("movi r17, [dp + syscall_execute_sarg0] ;GET");
    asm("movi r18, [dp + syscall_execute_sarg1] ;GET");
    asm("movi r19, [dp + syscall_execute_sarg2] ;GET");
    asm("movi r20, [dp + syscall_execute_sarg3] ;GET");
    asm("syscall");
    asm("movi [dp + syscall_execute_return_value], r17 ;GET");

    return return_value;
}

void printChar(char value) {
    syscall_execute(0, value, 0, 0, 0);
}

char getChar() {
    return syscall_execute(1, 0, 0, 0, 0);
}

void _printString(char *str) {
    syscall_execute(2, str, 0, 0, 0);
}

void exit() {
    syscall_execute(10, 0, 0, 0, 0);
}


int get_hex_int(char c) {
    char *hex_to_dec = "0123456789       :;<=>?";
    int number = *(hex_to_dec + c - 48) - 48;
    return number;
}

void cr() {
    char temp = 10;
    printChar(temp);
    temp = 13;
    printChar(temp);
}


void printString(char *str) {
    char *uart = 1245184;
    char current_char;
    while (*str > 0) {
        current_char = *str;
        printChar(current_char);
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
    printChar(temp);
    temp = x;
    temp = temp & 15;
    temp_b = temp;
    temp = temp_b + 48;
    if (temp_b > 9) {
        temp = temp_b + 55;
    }
    printChar(temp);
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
        printChar(temp);
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
        printChar(temp_print);
    }
    if (temp_print == 48 && not_leading_zero == 1) {
        printChar(temp_print);
    }

    for (i = 16; i > 0; i = i - 4) {
        temp_print = ((bcd_a >> (i - 4)) & 15) + 48;
        if (temp_print != 48) {
            not_leading_zero = 1;
            printChar(temp_print);
        }
        if (temp_print == 48 && not_leading_zero == 1) {
            printChar(temp_print);
        }
    }
    if (not_leading_zero == 0) {
        printChar(48);
    }
}

void debug() {
    char *debug_ptr = 9000000;
    *debug_ptr = 0;
}

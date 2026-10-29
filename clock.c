void print_char(char x) {
    char *uart = 1245184;
    *uart = x;
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

void cr() {
    char temp = 10;
    print_char(temp);
    temp = 13;
    print_char(temp);
}


void main() {
    int time = 0;
    int seconds = 0;
    int minutes = 0;
    int hours = 0;
    int dummy = 0;
    while (time < 99999) {
        for (int i = 0; i < 4650000; i = i + 1) {
            dummy = 0;
        }
        if (seconds < 60) {
            seconds = seconds + 1;
        }
        if (seconds == 60) {
            seconds = 0;
            minutes = minutes + 1;
        }
        if (minutes == 60) {
            minutes = 0;
            hours = hours + 1;
        }
        if (hours == 24) {
            hours = 0;
        }
        print_bcd(hours);
        print_char(32);
        print_bcd(minutes);
        print_char(32);
        print_bcd(seconds);
        cr();
        time = time + 1;
    }
}
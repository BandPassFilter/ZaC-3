// Disk test for ZaC-3 emulator

// 0x0100 - 0x0200: Hard disk
// 0x0100 = Hard disk LBA address (32-bit but only low 24-bits used)
// 0x0104 = Hard disk 512-byte address pointer in memory
// 0x0108 = Start read 512 block command
// 0x010C = Start write 512 block command
// 0x0110 = Read 32-bit word from disk (128 32-bit words per seconds, or 512 bytes) (io_in)
// 0x0110 = Write 32-bit word to disk (128 32-bit words per seconds, or 512 bytes) (io_out)
// 0x0114 = Read status register

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

void print(char *str) {
    char *uart = 1245184;
    char current_char;
    while (*str > 0) {
        current_char = *str;
        print_char(current_char);
        str = str + 1;
    }
}

void print_hex(uint8_t x) {
    char temp;
    char temp_b;
    for (int i = 8; i > 0; i = i - 4) {
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

void main() {
    int *disk_io = 1245440;
    int *disk_test_buffer = 65536;
    char *disk_test_buffer_char = disk_test_buffer;
    char *output_str = "Disk test\n";
    print(output_str);


    *disk_io = 117; // LBA to 0
    //*(disk_io + 3) = 1; // start write to disk
    //for (int i = 0; i < 128; i = i + 1) {
     //   *(disk_io + 4) = i;
    //}
    *disk_io = 2; // LBA to 0
    *(disk_io + 2) = 1; // start read to disk
    for (int i = 0; i < 128; i = i + 1) {
        *(disk_test_buffer + i) = *(disk_io + 4);
    }



    int col = 0;
    for (i = 0; i < 512; i = i + 1) {
        print_hex(*(disk_test_buffer_char + i));
        print_char(32);
        col = col + 1;
        if (col == 16) {
            for (int j = i - 16; j < i; j = j + 1) {
                uint8_t current_byte = *(disk_test_buffer_char + j + 1);
                int show_dot = 1;
                if (current_byte > 31 && current_byte < 127) {
                    print_char(current_byte);
                    show_dot = 0;
                }
                if (show_dot == 1) {
                    print_char(46);
                    show_dot = 0;
                }

            }
            cr();
            col = 0;
        }
    }



}

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

void print_int_hex(int x) {
    print_hex(x >> 16);
    print_hex(x & 65535);
}

int compare_string(char *str_a, char *str_b) {
    int i = 0;

    while (*(str_a + i) == *(str_b + i)) {
        i = i + 1;
        if (*(str_b + i) == 0) {
            return 1;
        }
        
        if (*(str_a + i) == 32) {
            return 1;
        }
    }
    return 0;
}

void reset_shell(char *shell_buf) {
    int shell_buf_offset = 0;
    while (shell_buf_offset < 256) {
        *(shell_buf + shell_buf_offset) = 0;
        shell_buf_offset = shell_buf_offset + 1;
    }
    char *prompt = ">";
    print(prompt);
}

int read_halfword_hex(char *string_buf) {
    int offset = 0;
    offset = offset + 1;
    int input_a = 0;
    char current_char = *(string_buf + offset);
    input_a = (*(string_buf + offset) - 48) << 12;
    offset = offset + 1;
    input_a = input_a + ((*(string_buf + offset) - 48) << 8);
    offset = offset + 1;
    input_a = input_a + ((*(string_buf + offset) - 48) << 4);
    offset = offset + 1;
    input_a = input_a + (*(string_buf + offset) - 48);
    offset = offset + 1;
    return input_a;
}

void dump_command(char *shell_buf, int shell_buf_offset) {
    char *cr = "\n";
    char *space = " ";
    char *dump_success = "dump command detected\n";
    char *offset_str = "shell_buf_offset: ";
    char *debug = 9000000;
    //print(dump_success);
    //print(offset_str);
    //print_hex(shell_buf_offset);
    //print(cr);
    shell_buf_offset = shell_buf_offset + 1;
    int input_a = 0;
    char current_char = *(shell_buf + shell_buf_offset);
    input_a = get_hex_int(*(shell_buf + shell_buf_offset)) << 12;
    shell_buf_offset = shell_buf_offset + 1;
    input_a = input_a + (get_hex_int(*(shell_buf + shell_buf_offset)) << 8);
    shell_buf_offset = shell_buf_offset + 1;
    input_a = input_a + (get_hex_int(*(shell_buf + shell_buf_offset)) << 4);
    shell_buf_offset = shell_buf_offset + 1;
    input_a = input_a + (get_hex_int(*(shell_buf + shell_buf_offset)));
    shell_buf_offset = shell_buf_offset + 1;
    //print_hex(input_a);
    int input_b = 0;
    shell_buf_offset = shell_buf_offset + 1;
    input_b = get_hex_int(*(shell_buf + shell_buf_offset)) << 12;
    shell_buf_offset = shell_buf_offset + 1;
    input_b = input_b + (get_hex_int(*(shell_buf + shell_buf_offset)) << 8);
    shell_buf_offset = shell_buf_offset + 1;
    input_b = input_b + (get_hex_int(*(shell_buf + shell_buf_offset)) << 4);
    shell_buf_offset = shell_buf_offset + 1;
    input_b = input_b + (get_hex_int(*(shell_buf + shell_buf_offset)));
    //print_char(32);
    //print_hex(input_b);
    //print(cr);
    char *dump_ptr = input_a;
    int col_ctr = 0;
    while (dump_ptr < input_b) {
        if ((col_ctr - 1) & 7 == 7) {
            print_char(32);
        }
        if ((col_ctr - 1) & 15 == 15) {
            print(cr);
            print_hex(dump_ptr);
            print_char(58);
            print_char(32);
            print_char(32);
            
        }
        print_hex_byte(*dump_ptr);
        print_char(32);
        col_ctr = col_ctr + 1;
        dump_ptr = dump_ptr + 1;
        if (dump_ptr > input_a) {
            if ((col_ctr - 1) & 15 == 15) {
                //print(cr);
                col_ctr = 0;
                while (col_ctr < 16) {
                    char dump_char = *(dump_ptr + col_ctr - 16);
                    if (dump_char > 31 && dump_char < 127) {
                        print_char(dump_char);
                    }
                    if (dump_char < 32 || dump_char > 126) {
                        print_char(46);
                    }
                    col_ctr = col_ctr + 1;
                }
            }
        }
    }
    print(cr);
}

void write_command(char *shell_buf, int shell_buf_offset) {
    char *write_str = "write command detected\n";
    char *cr = "\n";
    print(write_str);
    shell_buf_offset = shell_buf_offset + 1;
    int input_a = 0;
    char current_char = *(shell_buf + shell_buf_offset);
    // 32-bit address input
    input_a = get_hex_int(*(shell_buf + shell_buf_offset)) << 28;
    shell_buf_offset = shell_buf_offset + 1;
    input_a = input_a + (get_hex_int(*(shell_buf + shell_buf_offset)) << 24);
    shell_buf_offset = shell_buf_offset + 1;
    input_a = input_a + (get_hex_int(*(shell_buf + shell_buf_offset)) << 20);
    shell_buf_offset = shell_buf_offset + 1;
    input_a = input_a + (get_hex_int(*(shell_buf + shell_buf_offset)) << 16);
    shell_buf_offset = shell_buf_offset + 1;
    input_a = input_a + (get_hex_int(*(shell_buf + shell_buf_offset)) << 12);
    shell_buf_offset = shell_buf_offset + 1;
    input_a = input_a + (get_hex_int(*(shell_buf + shell_buf_offset)) << 8);
    shell_buf_offset = shell_buf_offset + 1;
    input_a = input_a + (get_hex_int(*(shell_buf + shell_buf_offset)) << 4);
    shell_buf_offset = shell_buf_offset + 1;
    input_a = input_a + (get_hex_int(*(shell_buf + shell_buf_offset)));
    shell_buf_offset = shell_buf_offset + 1;
    char *write_ptr = input_a;
    int display_ptr = write_ptr;
    char write_value = 0;
    int run = 1;
    char input_char_a = 0;
    char input_char_b = 0;
    char *hex_to_dec = "0123456789       :;<=>?";
    while (run == 1) {
        display_ptr = write_ptr;
        print_int_hex(display_ptr);
        print_char(58);
        print_char(32);
        if (run == 1) {
            input_char_a = get_char();
        }
        if (input_char_a == 13) {
            run = 0;
        }
        if (run == 1) {
            print_char(input_char_a);
            input_char_b = get_char();
        }
        if (input_char_b == 13) {
            run = 0;
        }
        if (run == 1) {
            print_char(input_char_b);
            write_value = 0;
            write_value = get_hex_int(input_char_a) << 4;
            write_value = write_value + get_hex_int(input_char_b);
            *write_ptr = write_value;
            write_ptr = write_ptr + 1;
        }


        //print_hex_byte(write_value);
        print(cr);
    }
}

void run_command() {
    char *run_str = "run command detected\n";
    print(run_str);
}

void main() {
    char *x = "\nZaC-3 OS\n";
	char *dump = "dump";
    char *write = "write";
    char *run = "run";
    
    print(x);

    char *output_str = "Typed string is: ";
    char *invalid_command_str = "Invalid command\n";
    char *cr_string = "\ncarriage return\n";
	char *shell_buf = 400000;
    char *cr = "\n";
    char space = 32;
    char bs = 8;

	int SHELL_BUF_SIZE = 256;

    int shell_buf_offset = 0;
	
    int do_loop = 1;
    reset_shell(shell_buf);
    while (do_loop == 1) {
        char temp = get_char();
        if (temp > 31) {
		    *(shell_buf + shell_buf_offset) = temp;
            print_char(temp);
            shell_buf_offset = shell_buf_offset + 1;
        }
        if (shell_buf_offset > 255) {
            shell_buf_offset = 0;
        }
        if (temp == 8) {
            if (shell_buf_offset > 0) {
                shell_buf_offset = shell_buf_offset - 1;
                *(shell_buf + shell_buf_offset) = 0;
                print_char(bs);
                print_char(space);
                print_char(bs);
            }
        }
        if (temp == 13) {
            int result = 0;
            int command_success = 0;
            shell_buf = 400000;
            
            print(cr);
            if (shell_buf_offset > 0) {
                
                result = compare_string(shell_buf, dump);
                if (result == 1) {
                    shell_buf_offset = 4;
                    dump_command(shell_buf, shell_buf_offset);
                    command_success = 1;
                }
                result = compare_string(shell_buf, write);
                if (result == 1) {
                    shell_buf_offset = 5;
                    write_command(shell_buf, shell_buf_offset);
                    command_success = 1;
                }
                result = compare_string(shell_buf, run);
                if (result == 1) {
                    shell_buf_offset = 3;
                    run_command();
                    command_success = 1;
                }
                if (command_success == 0) {
                    print(invalid_command_str);
                }
            }
            shell_buf_offset = 0;
            reset_shell(shell_buf);
        }
    }
    char *end = "end\n";
    print(end);
}

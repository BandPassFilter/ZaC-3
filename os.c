// OS for ZaC-3

// Todo:
// - When in the write command, only accept number-letter inputs, if it's a space or enter or whatever, then skip it. This is to allow simple
//   copy-pasting of HEX files into the terminal if you want to quickly load programs and data.
//
// - Change the "exit" key from write command from an enter to esc.
//
// - Implement run command, this would use my C-compiler specific "run" keyword which sets the program counter to the specified address.
//   Normally in modern C you would use a function pointer, but I don't have function pointers implemented in my C compiler, so I use this
//   method instead of just making my own special keywords.

#include "bios.h"

int get_int(char *shell_buf) {
    int shell_buf_offset = 0;
    int result = 0;
    int int_length = 0;
    while (*(shell_buf + shell_buf_offset) > 32) {
        //print_char(*(shell_buf + shell_buf_offset));
        shell_buf_offset = shell_buf_offset + 1;
        int_length = int_length + 1;
    }
    //cr();
    int_length = int_length << 2;
    for (int i = 0; i < int_length; i = i + 4) {
        shell_buf_offset = shell_buf_offset - 1;
        result = result + get_hex_int(*(shell_buf + shell_buf_offset)) << (i);
        
    }
    return result;
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

int skip_space(char *shell_buf) {
    int offset = 0;
    while (*(shell_buf + offset) < 33) {
        offset = offset + 1;
    }
    return offset;
}

int skip_non_space(char *shell_buf) {
    int offset = 0;
    while (*(shell_buf + offset) > 32) {
        offset = offset + 1;
    }
    return offset;
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

    
    input_a = get_int(shell_buf + shell_buf_offset);
    shell_buf_offset = shell_buf_offset + skip_non_space(shell_buf + shell_buf_offset);
    //print_int_hex(input_a);
    shell_buf_offset = shell_buf_offset + 1;

    int input_b = 0;
    input_b = get_int(shell_buf + shell_buf_offset);
    //cr();
    //print_int_hex(input_b);
    //cr();
    char *dump_ptr = input_a;
    int col_ctr = 0;
    while (dump_ptr < input_a + input_b) {
        if (((col_ctr - 1) & 7) == 7) {
            print_char(32);
        }
        if (((col_ctr - 1) & 15) == 15) {
            print(cr);
            print_int_hex(dump_ptr);
            print_char(58);
            print_char(32);
            print_char(32);
            
        }
        print_hex_byte(*dump_ptr);
        print_char(32);
        col_ctr = col_ctr + 1;
        dump_ptr = dump_ptr + 1;
        if ((dump_ptr > input_a) && (((col_ctr - 1) & 15) == 15)) {
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

    //for (int i = 32; i > 0; i = i - 4) {
    //    input_a = input_a + get_hex_int(*(shell_buf + shell_buf_offset)) << (i - 4);
    //    shell_buf_offset = shell_buf_offset + 1;
    //}

    input_a = get_int(shell_buf + shell_buf_offset);

    char *write_ptr = input_a;
    int display_ptr = write_ptr;
    char write_value = 0;
    int run = 1;
    char input_char_a = 0;
    char input_char_b = 0;
    char input_char_c = 0;
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
            print_char(input_char_b);
        }
        input_char_c = get_char();
        if (input_char_c == 13) {
            run = 0;
        }
        if (run == 1) {
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

void run_command(char *shell_buf, int shell_buf_offset) {
    char *run_str = "run command detected\n";
    int run_address = 131072;
    //char *debug = 9000000;
    print(run_str);
    //$run run_address;
    asm("addi r1, r0, 0");
    asm("lui r1, 2");
    asm("jr r1");
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



void system_call() {
    //print_bcd(func_number);
    //char *syscall_str = "System call test\n";
    //char *print_test_str = "print call test\n";
    //print(syscall_str);
    // function_number in r17
    // arguments and returns in r17,r18,r19,r20

    

    static int func_number;
    static int arg0;
    static int arg1;
    static int arg2;
    static int arg3;
    asm("movi [dp + system_call_func_number], r16");
    asm("movi [dp + system_call_arg0], r17");
    asm("movi [dp + system_call_arg1], r18");
    asm("movi [dp + system_call_arg2], r19");
    asm("movi [dp + system_call_arg3], r20");

    char *debug = 9000000;
    //*debug = 0;

    static int return_value = 0;

    if (func_number == 0) {
        print_char(arg0);
    }
    if (func_number == 1) {
        return_value = get_char();
    }
    if (func_number == 2) {
        print(arg0);
    }

    if (func_number == 10) {
        //char *reset_str = "Return to system call\n";
        //print(reset_str);
        asm("addi r1, r0, _shell");
        asm("jr r1");
    }

    asm("movi r17, [dp + system_call_return_value]"); // return int goes into r17
}

void shell() {
	char *dump = "dump";
    char *write = "write";
    char *run = "run";


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


void main() {
    asm("addi sys, r0, _system_call");
    char *x = "\nZaC-3 OS\n";
    print(x);
	shell();
}

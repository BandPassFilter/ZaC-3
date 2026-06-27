void print_char(char value) {
    char _io *uart = 0;
    *uart = value;
}

char get_char() {
    char _io *uart = 0;
    return *uart;
}

void print(char _data *str) {
    char _io *uart = 0;
    char current_char;
    while (*str > 0) {
        current_char = *str;
        print_char(current_char);
        str = str + 1;
    }
}

int compare_string(char _data *str_a, char _data *str_b) {
    int i = 0;
    while (*(str_a + i) == *(str_b + i)) {
        if (*(str_a + i) == 0) {
            return 1;
        }
        i = i + 1;
        if (*(str_a + i) == 32) {
            return 1;
        }
    }
    return 0;
}

void reset_shell(char _data *shell_buf) {
    int shell_buf_offset = 0;
    while (shell_buf_offset < 256) {
        *(shell_buf + shell_buf_offset) = 0;
        shell_buf_offset = shell_buf_offset + 1;
    }
    char _data *prompt = ">";
    print(prompt);
}

void dump_command() {
    char _data *dump_success = "dump command detected\n";
    print(dump_success);

}

void main() {
    char _data *x = "Z\n";
	char _data *dump = "dump";
    
    print(x);

    char _data *output_str = "Typed string is: ";
    char _data *cr_string = "\ncarriage return\n";
	char _data *shell_buf = 1024;
    char _data *cr = "\n";
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
            print(cr_string);
            shell_buf = 1024;
            shell_buf_offset = 0;
            print(output_str);
            print(shell_buf);
            print(cr);
            
            char result = 0;
            result = compare_string(shell_buf, dump);
            if (result == 1) {
                dump_command();
            }
            reset_shell(shell_buf);
        }
    }
    char *end = "end\n";
    print(end);
}

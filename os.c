void print_char(char value) {
    char *uart = 1245184;
    *uart = value;
}

char get_char() {
    char *uart = 1245184;
    return *uart;
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

int compare_string(char *str_a, char *str_b) {
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

void reset_shell(char *shell_buf) {
    int shell_buf_offset = 0;
    while (shell_buf_offset < 256) {
        *(shell_buf + shell_buf_offset) = 0;
        shell_buf_offset = shell_buf_offset + 1;
    }
    char *prompt = ">";
    print(prompt);
}

void dump_command() {
    char *dump_success = "dump command detected\n";
    print(dump_success);

}

void main() {
    char *x = "Z\n";
	char *dump = "dump";
    
    print(x);

    char *output_str = "Typed string is: ";
    char *cr_string = "\ncarriage return\n";
	char *shell_buf = 1024;
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

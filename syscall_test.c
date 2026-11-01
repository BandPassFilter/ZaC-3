asm(".org 131072");

void print_char(char x) {
    char *uart = 1245184;
    *uart = x;
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

void syscall_func() {
    asm("subi sp, sp, 4");
    asm("addi r4, r0, 10 ;SYSCALL_GET");
    asm("movi [sp + 0], r4 ;SYSCALL_SET");
    asm("syscall");
    asm("addi sp, sp, 4 ;SYSCALL_POP_PARAM");
}


void main() {
    char *debug = 9000000;
    syscall_func();
    char *syscall_success = "Syscall return\n";
    print(syscall_success);
}
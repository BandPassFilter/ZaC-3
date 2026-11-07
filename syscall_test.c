#include "stdio.h"

asm(".org 131072");

void main() {
    char *debug = 9000000;
    char *syscall_success = "Syscall print string test\n";
    printString(syscall_success);
    exit();
}

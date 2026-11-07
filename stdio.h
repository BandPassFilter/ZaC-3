void syscall_execute(int func_number, int arg0, int arg1, int arg2, int arg3) {
    // R16 - R20 = Syscall arguments / returns
    // R16 = function number
    char *debug = 9000000;
    //*debug = 0;

    static int sfunc = func_number;
    static int sarg0 = arg0;
    static int sarg1 = arg1;
    static int sarg2 = arg2;
    static int sarg3 = arg3;

    asm("movi r16, [dp + syscall_execute_sfunc] ;GET");
    asm("movi r17, [dp + syscall_execute_sarg0] ;GET");
    asm("movi r18, [dp + syscall_execute_sarg1] ;GET");
    asm("movi r19, [dp + syscall_execute_sarg2] ;GET");
    asm("movi r20, [dp + syscall_execute_sarg3] ;GET");
    asm("syscall");
}

void printString(char *str) {
    syscall_execute(0, str, 0, 0, 0);
}

void exit() {
    syscall_execute(10, 0, 0, 0, 0);
}

.define UART 0
.define shell_buffer_base 4096
.define shell_buffer_size 256
.define CR 13
.define LF 10

jmp reset



reset:
    movi [dp + shell_buffer_offset], r0
    addi r1, r0, 62
    movi [io + UART], r1
    jmp idle_loop

; user input loop
idle_loop:
    ; read character and save to buffer
    movi r1, [io + UART]
    ; check if enter key
    subi r0, r1, CR
    jz enter_key
    movi r2, [dp + shell_buffer_offset]
    addi r2, r2, shell_buffer_base
    mvbi [r2 + 0], r1
    addi r1, r0, 0

    ; output curret buffer character to verify input
    movi r2, [dp + shell_buffer_offset]
    addi r2, r2, shell_buffer_base
    mvbi r3, [r2 + 0]
    movi [io + UART], r3

    ; increment shell buffer offset
    movi r2, [dp + shell_buffer_offset]
    addi r2, r2, 1
    movi [dp + shell_buffer_offset], r2
    
    jmp idle_loop

enter_key:
    addi r1, r0, CR
    movi [io + UART], r1
    addi r1, r0, LF
    movi [io + UART], r1

    ; skip if no command entered
    movi r1, [dp + shell_buffer_offset]
    sub r0, r0, r1
    jz read_buffer_loop_end_skip

    ; reset buffer offset
    movi [dp + shell_buffer_offset], r0
    ; now read buffer to verify command

    read_buffer_loop:
        movi r1, [dp + shell_buffer_offset]
        addi r1, r1, shell_buffer_base
        mvbi r2, [r1 + 0]
        sub r0, r0, r2
        jz read_buffer_loop_end
        mvbi [io + UART], r2
        movi r1, [dp + shell_buffer_offset]
        addi r1, r1, 1
        movi [dp + shell_buffer_offset], r1
        jmp read_buffer_loop
    read_buffer_loop_end:
    addi r1, r0, CR
    movi [io + UART], r1
    addi r1, r0, LF
    movi [io + UART], r1
    read_buffer_loop_end_skip:
    jmp reset


.word shell_buffer_offset = 0
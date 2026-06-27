addi r1, r0, 1
addi r2, r0, 1

loop:
    add r3, r1, r2
    mov r1, r2
    mov r2, r3 ; test

    mov r4, r1
    jal print_hex

    add r4, r1, r2
    jnc loop

movi [dp + test_byte_2], r1
movi r2, [dp + test_byte]
halt

print_hex:
    movi [sp + 0], ra
    addi sp, sp, -2
    mov r4, r1
    sri r4, r4, 12
    addi r4, r4, 48
    movi [io + 0], r4

    mov r4, r1
    sri r4, r4, 8
    andi r4, r4, 15
    addi r4, r4, 48
    movi [io + 0], r4

    mov r4, r1
    sri r4, r4, 4
    andi r4, r4, 15
    addi r4, r4, 48
    movi [io + 0], r4

    mov r4, r1
    andi r4, r4, 15
    addi r4, r4, 48
    movi [io + 0], r4
    jal print_space
    addi sp, sp, 2
    movi ra, [sp + 0]
    jr ra

print_space:
    movi [sp + 0], ra
    addi sp, sp, -2
    mov r7, r1
    addi r1, r0, 32
    movi [io + 0], r1
    mov r1, r7
    addi sp, sp, 2
    movi ra, [sp + 0]
    jr ra

.word test_byte = 15
.word test_byte_2 = 0
.word test_byte_3 = 13

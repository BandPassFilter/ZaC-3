lui fp, 18
addi sp, r0, 65532
lui sp, 18
addi ssp, r0, 65532
lui ssp, 17
lui dp, 4
lui io, 19

jmp _main

_print_char:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r4, r0, 0 ;GET_32
lui r4, 19 ;GET_32
movi [fp + 0], r4 ;SET

mvbi r4, [fp + 8] ;/GET
movi r5, [fp + 0] ;GET
mvbi [r5 + 0], r4 ;SET

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_get_char:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r5, r0, 0 ;GET_32
lui r5, 19 ;GET_32
movi [fp + 0], r5 ;SET

movi r5, [fp + 0] ;GET
mvbi r6, [r5 + 0] ;GET
add r1, r0, r6
addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
add fp, r0, sp
jr ra

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_print:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
addi r7, r0, 0 ;GET_32
lui r7, 19 ;GET_32
movi [fp + 0], r7 ;SET


0_start:
movi r7, [fp + 12] ;GET
mvbi r8, [r7 + 0] ;GET
addi r9, r0, 0 ;GET
sub r1, r9, r8
jc 0_true
jz 0_false
addi r8, r0, 1
jmp 0_end
0_true:
addi r8, r0, 0
jmp 0_end
0_end:
sub r8, r8, r0
jz 0_false
movi r8, [fp + 12] ;GET
mvbi r9, [r8 + 0] ;GET
mvbi [fp + 4], r9 ;SET

subi sp, sp, 4
mvbi r9, [fp + 4] ;GET_MEMORY
mvbi [sp + 0], r9 ;SET
jal _print_char
add r9, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

movi r9, [fp + 12] ;GET
addi r10, r0, 1 ;GET
add r2, r0, r10
add r1, r0, r9
add r1, r1, r2
add r9, r0, r1 ;ADD_POINTER

movi [fp + 12], r9 ;SET

jmp 0_start
0_false:

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_print_hex_byte:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp


mvbi r4, [fp + 12] ;/GET
addi r5, r0, 4 ;GET
add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 0] ;/GET
addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 0] ;/GET
mvbi [fp + 4], r4 ;SET

mvbi r4, [fp + 4] ;/GET
addi r5, r0, 48 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 4] ;/GET
addi r5, r0, 9 ;GET
sub r1, r5, r4
jc 1_true
jz 1_false
addi r4, r0, 1
jmp 1_end
1_true:
addi r4, r0, 0
jmp 1_end
1_end:
sub r4, r4, r0
jz 1_false
mvbi r4, [fp + 4] ;/GET
addi r5, r0, 55 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 0], r4 ;SET

1_false:

subi sp, sp, 4
mvbi r4, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
jal _print_char
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

mvbi r4, [fp + 12] ;/GET
mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 0] ;/GET
addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 0] ;/GET
mvbi [fp + 4], r4 ;SET

mvbi r4, [fp + 4] ;/GET
addi r5, r0, 48 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 4] ;/GET
addi r5, r0, 9 ;GET
sub r1, r5, r4
jc 2_true
jz 2_false
addi r4, r0, 1
jmp 2_end
2_true:
addi r4, r0, 0
jmp 2_end
2_end:
sub r4, r4, r0
jz 2_false
mvbi r4, [fp + 4] ;/GET
addi r5, r0, 55 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 0], r4 ;SET

2_false:

subi sp, sp, 4
mvbi r4, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
jal _print_char
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_print_hex:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp


movi r4, [fp + 12] ;GET
addi r5, r0, 12 ;GET
add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 0] ;/GET
addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 0] ;/GET
mvbi [fp + 4], r4 ;SET

mvbi r4, [fp + 4] ;/GET
addi r5, r0, 48 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 4] ;/GET
addi r5, r0, 9 ;GET
sub r1, r5, r4
jc 3_true
jz 3_false
addi r4, r0, 1
jmp 3_end
3_true:
addi r4, r0, 0
jmp 3_end
3_end:
sub r4, r4, r0
jz 3_false
mvbi r4, [fp + 4] ;/GET
addi r5, r0, 55 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 0], r4 ;SET

3_false:

subi sp, sp, 4
mvbi r4, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
jal _print_char
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

movi r4, [fp + 12] ;GET
addi r5, r0, 8 ;GET
add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 0] ;/GET
addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 0] ;/GET
mvbi [fp + 4], r4 ;SET

mvbi r4, [fp + 4] ;/GET
addi r5, r0, 48 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 4] ;/GET
addi r5, r0, 9 ;GET
sub r1, r5, r4
jc 4_true
jz 4_false
addi r4, r0, 1
jmp 4_end
4_true:
addi r4, r0, 0
jmp 4_end
4_end:
sub r4, r4, r0
jz 4_false
mvbi r4, [fp + 4] ;/GET
addi r5, r0, 55 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 0], r4 ;SET

4_false:

subi sp, sp, 4
mvbi r4, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
jal _print_char
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

movi r4, [fp + 12] ;GET
addi r5, r0, 4 ;GET
add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 0] ;/GET
addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 0] ;/GET
mvbi [fp + 4], r4 ;SET

mvbi r4, [fp + 4] ;/GET
addi r5, r0, 48 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 4] ;/GET
addi r5, r0, 9 ;GET
sub r1, r5, r4
jc 5_true
jz 5_false
addi r4, r0, 1
jmp 5_end
5_true:
addi r4, r0, 0
jmp 5_end
5_end:
sub r4, r4, r0
jz 5_false
mvbi r4, [fp + 4] ;/GET
addi r5, r0, 55 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 0], r4 ;SET

5_false:

subi sp, sp, 4
mvbi r4, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
jal _print_char
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

movi r4, [fp + 12] ;GET
mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 0] ;/GET
addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 0] ;/GET
mvbi [fp + 4], r4 ;SET

mvbi r4, [fp + 4] ;/GET
addi r5, r0, 48 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 0], r4 ;SET

mvbi r4, [fp + 4] ;/GET
addi r5, r0, 9 ;GET
sub r1, r5, r4
jc 6_true
jz 6_false
addi r4, r0, 1
jmp 6_end
6_true:
addi r4, r0, 0
jmp 6_end
6_end:
sub r4, r4, r0
jz 6_false
mvbi r4, [fp + 4] ;/GET
addi r5, r0, 55 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 0], r4 ;SET

6_false:

subi sp, sp, 4
mvbi r4, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
jal _print_char
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_compare_string:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r4, r0, 0 ;GET
movi [fp + 0], r4 ;SET

7_start:
movi r4, [fp + 8] ;GET
movi r5, [fp + 0] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r5, [r4 + 0] ;GET
movi r6, [fp + 12] ;GET
movi r7, [fp + 0] ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi r7, [r6 + 0] ;GET
sub r1, r5, r7
jz 7_true
addi r6, r0, 0
jmp 7_end
7_true:
addi r6, r0, 1
jmp 7_end
7_end:
sub r6, r6, r0
jz 7_false
movi r6, [fp + 0] ;GET
addi r7, r0, 1 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 0], r6 ;SET

movi r6, [fp + 12] ;GET
movi r7, [fp + 0] ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi r7, [r6 + 0] ;GET
addi r8, r0, 0 ;GET
sub r1, r7, r8
jz 8_true
addi r7, r0, 0
jmp 8_end
8_true:
addi r7, r0, 1
jmp 8_end
8_end:
sub r7, r7, r0
jz 8_false
addi r7, r0, 1 ;GET
add r1, r0, r7
addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
add fp, r0, sp
jr ra

8_false:

movi r8, [fp + 8] ;GET
movi r9, [fp + 0] ;GET
add r2, r0, r9
add r1, r0, r8
add r1, r1, r2
add r8, r0, r1 ;ADD_POINTER

mvbi r9, [r8 + 0] ;GET
addi r10, r0, 32 ;GET
sub r1, r9, r10
jz 9_true
addi r9, r0, 0
jmp 9_end
9_true:
addi r9, r0, 1
jmp 9_end
9_end:
sub r9, r9, r0
jz 9_false
addi r9, r0, 1 ;GET
add r1, r0, r9
addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
add fp, r0, sp
jr ra

9_false:

jmp 7_start
7_false:

addi r4, r0, 0 ;GET
add r1, r0, r4
addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
add fp, r0, sp
jr ra

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_reset_shell:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
addi r5, r0, 0 ;GET
movi [fp + 0], r5 ;SET

10_start:
movi r5, [fp + 0] ;GET
addi r6, r0, 256 ;GET
sub r1, r5, r6
jc 10_true
jz 10_false
addi r5, r0, 1
jmp 10_end
10_true:
addi r5, r0, 0
jmp 10_end
10_end:
sub r5, r5, r0
jz 10_false
addi r5, r0, 0 ;GET
movi r6, [fp + 12] ;GET
movi r7, [fp + 0] ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi [r6 + 0], r5 ;SET

movi r6, [fp + 0] ;GET
addi r7, r0, 1 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 0], r6 ;SET

jmp 10_start
10_false:

.asciiz string_0 = ">"
addi r4, r0, string_0
lui r4, 4 ;GET_32
movi [fp + 4], r4 ;SET

subi sp, sp, 4
movi r4, [fp + 4] ;GET_MEMORY
movi [sp + 0], r4 ;SET
jal _print
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_dump_command:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
.asciiz string_1 = "dump command detected\n"
addi r4, r0, string_1
lui r4, 4 ;GET_32
movi [fp + 0], r4 ;SET

subi sp, sp, 4
movi r4, [fp + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
jal _print
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

movi r4, [fp + 12] ;GET
movi r5, [fp + 16] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r5, [r4 + 0] ;GET
mvbi [fp + 4], r5 ;SET

subi sp, sp, 4
mvbi r5, [fp + 4] ;GET_MEMORY
mvbi [sp + 0], r5 ;SET
jal _print_hex_byte
add r5, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_write_command:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
.asciiz string_2 = "write command detected\n"
addi r5, r0, string_2
lui r5, 4 ;GET_32
movi [fp + 0], r5 ;SET

subi sp, sp, 4
movi r5, [fp + 0] ;GET_MEMORY
movi [sp + 0], r5 ;SET
jal _print
add r5, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_run_command:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
.asciiz string_3 = "run command detected\n"
addi r5, r0, string_3
lui r5, 4 ;GET_32
movi [fp + 0], r5 ;SET

subi sp, sp, 4
movi r5, [fp + 0] ;GET_MEMORY
movi [sp + 0], r5 ;SET
jal _print
add r5, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_main:
subi sp, sp, 72
add fp, r0, sp
.asciiz string_4 = "\nZaC-3 OS\n"
addi r5, r0, string_4
lui r5, 4 ;GET_32
movi [fp + 0], r5 ;SET

.asciiz string_5 = "dump"
addi r5, r0, string_5
lui r5, 4 ;GET_32
movi [fp + 4], r5 ;SET

.asciiz string_6 = "write"
addi r5, r0, string_6
lui r5, 4 ;GET_32
movi [fp + 8], r5 ;SET

.asciiz string_7 = "run"
addi r5, r0, string_7
lui r5, 4 ;GET_32
movi [fp + 12], r5 ;SET

subi sp, sp, 4
movi r5, [fp + 0] ;GET_MEMORY
movi [sp + 0], r5 ;SET
jal _print
add r5, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

.asciiz string_8 = "Typed string is: "
addi r5, r0, string_8
lui r5, 4 ;GET_32
movi [fp + 16], r5 ;SET

.asciiz string_9 = "Invalid command\n"
addi r5, r0, string_9
lui r5, 4 ;GET_32
movi [fp + 20], r5 ;SET

.asciiz string_10 = "\ncarriage return\n"
addi r5, r0, string_10
lui r5, 4 ;GET_32
movi [fp + 24], r5 ;SET

addi r5, r0, 6784 ;GET_32
lui r5, 6 ;GET_32
movi [fp + 28], r5 ;SET

.asciiz string_11 = "\n"
addi r5, r0, string_11
lui r5, 4 ;GET_32
movi [fp + 32], r5 ;SET

addi r5, r0, 32 ;GET
mvbi [fp + 36], r5 ;SET

addi r5, r0, 8 ;GET
mvbi [fp + 40], r5 ;SET

addi r5, r0, 256 ;GET
movi [fp + 44], r5 ;SET

addi r5, r0, 0 ;GET
movi [fp + 48], r5 ;SET

addi r5, r0, 1 ;GET
movi [fp + 52], r5 ;SET

subi sp, sp, 4
movi r5, [fp + 28] ;GET_MEMORY
movi [sp + 0], r5 ;SET
jal _reset_shell
add r5, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

11_start:
movi r5, [fp + 52] ;GET
addi r6, r0, 1 ;GET
sub r1, r5, r6
jz 11_true
addi r5, r0, 0
jmp 11_end
11_true:
addi r5, r0, 1
jmp 11_end
11_end:
sub r5, r5, r0
jz 11_false
jal _get_char
add r5, r0, r1 ;RETURN_SET
add fp, r0, sp
mvbi [fp + 56], r5 ;SET

mvbi r5, [fp + 56] ;/GET
addi r6, r0, 31 ;GET
sub r1, r6, r5
jc 12_true
jz 12_false
addi r5, r0, 1
jmp 12_end
12_true:
addi r5, r0, 0
jmp 12_end
12_end:
sub r5, r5, r0
jz 12_false
mvbi r5, [fp + 56] ;/GET
movi r6, [fp + 28] ;GET
movi r7, [fp + 48] ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi [r6 + 0], r5 ;SET

subi sp, sp, 4
mvbi r6, [fp + 56] ;GET_MEMORY
mvbi [sp + 0], r6 ;SET
jal _print_char
add r6, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

movi r6, [fp + 48] ;GET
addi r7, r0, 1 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 48], r6 ;SET

12_false:

movi r6, [fp + 48] ;GET
addi r7, r0, 255 ;GET
sub r1, r7, r6
jc 13_true
jz 13_false
addi r6, r0, 1
jmp 13_end
13_true:
addi r6, r0, 0
jmp 13_end
13_end:
sub r6, r6, r0
jz 13_false
addi r6, r0, 0 ;GET
movi [fp + 48], r6 ;SET

13_false:

mvbi r6, [fp + 56] ;/GET
addi r7, r0, 8 ;GET
sub r1, r6, r7
jz 14_true
addi r6, r0, 0
jmp 14_end
14_true:
addi r6, r0, 1
jmp 14_end
14_end:
sub r6, r6, r0
jz 14_false
movi r6, [fp + 48] ;GET
addi r7, r0, 0 ;GET
sub r1, r7, r6
jc 15_true
jz 15_false
addi r6, r0, 1
jmp 15_end
15_true:
addi r6, r0, 0
jmp 15_end
15_end:
sub r6, r6, r0
jz 15_false
movi r6, [fp + 48] ;GET
addi r7, r0, 1 ;GET
add r2, r0, r7
add r1, r0, r6
sub r1, r1, r2
add r6, r0, r1 ;SUB

movi [fp + 48], r6 ;SET

addi r6, r0, 0 ;GET
movi r7, [fp + 28] ;GET
movi r8, [fp + 48] ;GET
add r2, r0, r8
add r1, r0, r7
add r1, r1, r2
add r7, r0, r1 ;ADD_POINTER

mvbi [r7 + 0], r6 ;SET

subi sp, sp, 4
mvbi r7, [fp + 40] ;GET_MEMORY
mvbi [sp + 0], r7 ;SET
jal _print_char
add r7, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

subi sp, sp, 4
mvbi r7, [fp + 36] ;GET_MEMORY
mvbi [sp + 0], r7 ;SET
jal _print_char
add r7, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

subi sp, sp, 4
mvbi r7, [fp + 40] ;GET_MEMORY
mvbi [sp + 0], r7 ;SET
jal _print_char
add r7, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

15_false:

14_false:

mvbi r7, [fp + 56] ;/GET
addi r8, r0, 13 ;GET
sub r1, r7, r8
jz 16_true
addi r7, r0, 0
jmp 16_end
16_true:
addi r7, r0, 1
jmp 16_end
16_end:
sub r7, r7, r0
jz 16_false
addi r7, r0, 0 ;GET
movi [fp + 60], r7 ;SET

addi r7, r0, 0 ;GET
movi [fp + 64], r7 ;SET

addi r7, r0, 6784 ;GET_32
lui r7, 6 ;GET_32
movi [fp + 28], r7 ;SET

subi sp, sp, 4
movi r7, [fp + 32] ;GET_MEMORY
movi [sp + 0], r7 ;SET
jal _print
add r7, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

movi r7, [fp + 48] ;GET
addi r8, r0, 0 ;GET
sub r1, r8, r7
jc 17_true
jz 17_false
addi r7, r0, 1
jmp 17_end
17_true:
addi r7, r0, 0
jmp 17_end
17_end:
sub r7, r7, r0
jz 17_false
addi r7, r0, 0 ;GET
movi [fp + 48], r7 ;SET

subi sp, sp, 4
movi r7, [fp + 4] ;GET_MEMORY
movi [sp + 0], r7 ;SET
subi sp, sp, 4
movi r7, [fp + 28] ;GET_MEMORY
movi [sp + 0], r7 ;SET
jal _compare_string
add r7, r0, r1 ;RETURN_SET
addi sp, sp, 8
add fp, r0, sp
movi [fp + 60], r7 ;SET

movi r7, [fp + 60] ;GET
addi r8, r0, 1 ;GET
sub r1, r7, r8
jz 18_true
addi r7, r0, 0
jmp 18_end
18_true:
addi r7, r0, 1
jmp 18_end
18_end:
sub r7, r7, r0
jz 18_false
subi sp, sp, 4
movi r7, [fp + 48] ;GET_MEMORY
movi [sp + 0], r7 ;SET
subi sp, sp, 4
movi r7, [fp + 28] ;GET_MEMORY
movi [sp + 0], r7 ;SET
jal _dump_command
add r7, r0, r1 ;RETURN_SET
addi sp, sp, 8
add fp, r0, sp

addi r7, r0, 1 ;GET
movi [fp + 64], r7 ;SET

18_false:

subi sp, sp, 4
movi r7, [fp + 8] ;GET_MEMORY
movi [sp + 0], r7 ;SET
subi sp, sp, 4
movi r7, [fp + 28] ;GET_MEMORY
movi [sp + 0], r7 ;SET
jal _compare_string
add r7, r0, r1 ;RETURN_SET
addi sp, sp, 8
add fp, r0, sp
movi [fp + 60], r7 ;SET

movi r7, [fp + 60] ;GET
addi r8, r0, 1 ;GET
sub r1, r7, r8
jz 19_true
addi r7, r0, 0
jmp 19_end
19_true:
addi r7, r0, 1
jmp 19_end
19_end:
sub r7, r7, r0
jz 19_false
jal _write_command
add r7, r0, r1 ;RETURN_SET
add fp, r0, sp

addi r7, r0, 1 ;GET
movi [fp + 64], r7 ;SET

19_false:

subi sp, sp, 4
movi r7, [fp + 12] ;GET_MEMORY
movi [sp + 0], r7 ;SET
subi sp, sp, 4
movi r7, [fp + 28] ;GET_MEMORY
movi [sp + 0], r7 ;SET
jal _compare_string
add r7, r0, r1 ;RETURN_SET
addi sp, sp, 8
add fp, r0, sp
movi [fp + 60], r7 ;SET

movi r7, [fp + 60] ;GET
addi r8, r0, 1 ;GET
sub r1, r7, r8
jz 20_true
addi r7, r0, 0
jmp 20_end
20_true:
addi r7, r0, 1
jmp 20_end
20_end:
sub r7, r7, r0
jz 20_false
jal _run_command
add r7, r0, r1 ;RETURN_SET
add fp, r0, sp

addi r7, r0, 1 ;GET
movi [fp + 64], r7 ;SET

20_false:

movi r7, [fp + 64] ;GET
addi r8, r0, 0 ;GET
sub r1, r7, r8
jz 21_true
addi r7, r0, 0
jmp 21_end
21_true:
addi r7, r0, 1
jmp 21_end
21_end:
sub r7, r7, r0
jz 21_false
subi sp, sp, 4
movi r7, [fp + 20] ;GET_MEMORY
movi [sp + 0], r7 ;SET
jal _print
add r7, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

21_false:

17_false:

subi sp, sp, 4
movi r7, [fp + 28] ;GET_MEMORY
movi [sp + 0], r7 ;SET
jal _reset_shell
add r7, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

16_false:

jmp 11_start
11_false:

.asciiz string_12 = "end\n"
addi r4, r0, string_12
lui r4, 4 ;GET_32
movi [fp + 68], r4 ;SET

subi sp, sp, 4
movi r4, [fp + 68] ;GET_MEMORY
movi [sp + 0], r4 ;SET
jal _print
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

halt

halt

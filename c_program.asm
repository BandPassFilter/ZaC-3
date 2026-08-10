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
addi r3, r0, 0 ;GET_32
lui r3, 19 ;GET_32
movi [fp + 0], r3 ;SET

mvbi r4, [fp + 8] ;/GET
movi r5, [fp + 0] ;GET
mvbi [r5 + 0], r4 ;SET

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_cr:
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
subi sp, sp, 4
addi r5, r0, 13 ;GET
movi [sp + 0], r5 ;SET
jal _print_char
add r5, r0, r1
addi sp, sp, 4
add fp, r0, sp

subi sp, sp, 4
addi r5, r0, 10 ;GET
movi [sp + 0], r5 ;SET
jal _print_char
add r5, r0, r1
addi sp, sp, 4
add fp, r0, sp

addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_function:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp

;for_init
movi r4, [fp + 8] ;GET
movi [fp + 0], r4 ;SET
0_start:

;for_condition
movi r5, [fp + 0] ;GET
movi r6, [fp + 12] ;GET
sub r1, r5, r6
jc 0_true
jz 0_false
addi r5, r0, 1
jmp 0_end
0_true:
addi r5, r0, 0
jmp 0_end
0_end:
sub r1, r1, r0
jz 0_false

;for_body
subi sp, sp, 4
movi r6, [fp + 0] ;GET_MEMORY
movi [sp + 0], r6 ;SET
jal _print_char
add r6, r0, r1
addi sp, sp, 4
add fp, r0, sp


;for_iter
movi r5, [fp + 0] ;GET
addi r6, r0, 1 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

movi [fp + 0], r5 ;SET
jmp 0_start
0_false:

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_fibonacci:
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_print_hex:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp


movi r5, [fp + 12] ;GET
addi r6, r0, 12 ;GET
add r2, r0, r6
add r1, r0, r5
sr r1, r1, r2
add r5, r0, r1 ;RIGHT_SHIFT

mvbi [fp + 0], r5 ;SET

mvbi r5, [fp + 0] ;/GET
addi r6, r0, 15 ;GET
add r2, r0, r6
add r1, r0, r5
and r1, r1, r2
add r5, r0, r1 ;BITWISE_AND

mvbi [fp + 0], r5 ;SET

mvbi r5, [fp + 0] ;/GET
mvbi [fp + 4], r5 ;SET

mvbi r5, [fp + 4] ;/GET
addi r6, r0, 48 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [fp + 0], r5 ;SET

mvbi r6, [fp + 4] ;/GET
addi r7, r0, 9 ;GET
sub r1, r7, r6
jc 1_true
jz 1_false
addi r6, r0, 1
jmp 1_end
1_true:
addi r6, r0, 0
jmp 1_end
1_end:
sub r6, r6, r0
jz 1_false
mvbi r5, [fp + 4] ;/GET
addi r6, r0, 55 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [fp + 0], r5 ;SET

1_false:

subi sp, sp, 4
mvbi r6, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r6 ;SET
jal _print_char
add r6, r0, r1
addi sp, sp, 4
add fp, r0, sp

movi r5, [fp + 12] ;GET
addi r6, r0, 8 ;GET
add r2, r0, r6
add r1, r0, r5
sr r1, r1, r2
add r5, r0, r1 ;RIGHT_SHIFT

mvbi [fp + 0], r5 ;SET

mvbi r5, [fp + 0] ;/GET
addi r6, r0, 15 ;GET
add r2, r0, r6
add r1, r0, r5
and r1, r1, r2
add r5, r0, r1 ;BITWISE_AND

mvbi [fp + 0], r5 ;SET

mvbi r5, [fp + 0] ;/GET
mvbi [fp + 4], r5 ;SET

mvbi r5, [fp + 4] ;/GET
addi r6, r0, 48 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [fp + 0], r5 ;SET

mvbi r6, [fp + 4] ;/GET
addi r7, r0, 9 ;GET
sub r1, r7, r6
jc 2_true
jz 2_false
addi r6, r0, 1
jmp 2_end
2_true:
addi r6, r0, 0
jmp 2_end
2_end:
sub r6, r6, r0
jz 2_false
mvbi r5, [fp + 4] ;/GET
addi r6, r0, 55 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [fp + 0], r5 ;SET

2_false:

subi sp, sp, 4
mvbi r6, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r6 ;SET
jal _print_char
add r6, r0, r1
addi sp, sp, 4
add fp, r0, sp

movi r5, [fp + 12] ;GET
addi r6, r0, 4 ;GET
add r2, r0, r6
add r1, r0, r5
sr r1, r1, r2
add r5, r0, r1 ;RIGHT_SHIFT

mvbi [fp + 0], r5 ;SET

mvbi r5, [fp + 0] ;/GET
addi r6, r0, 15 ;GET
add r2, r0, r6
add r1, r0, r5
and r1, r1, r2
add r5, r0, r1 ;BITWISE_AND

mvbi [fp + 0], r5 ;SET

mvbi r5, [fp + 0] ;/GET
mvbi [fp + 4], r5 ;SET

mvbi r5, [fp + 4] ;/GET
addi r6, r0, 48 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [fp + 0], r5 ;SET

mvbi r6, [fp + 4] ;/GET
addi r7, r0, 9 ;GET
sub r1, r7, r6
jc 3_true
jz 3_false
addi r6, r0, 1
jmp 3_end
3_true:
addi r6, r0, 0
jmp 3_end
3_end:
sub r6, r6, r0
jz 3_false
mvbi r5, [fp + 4] ;/GET
addi r6, r0, 55 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [fp + 0], r5 ;SET

3_false:

subi sp, sp, 4
mvbi r6, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r6 ;SET
jal _print_char
add r6, r0, r1
addi sp, sp, 4
add fp, r0, sp

movi r5, [fp + 12] ;GET
mvbi [fp + 0], r5 ;SET

mvbi r5, [fp + 0] ;/GET
addi r6, r0, 15 ;GET
add r2, r0, r6
add r1, r0, r5
and r1, r1, r2
add r5, r0, r1 ;BITWISE_AND

mvbi [fp + 0], r5 ;SET

mvbi r5, [fp + 0] ;/GET
mvbi [fp + 4], r5 ;SET

mvbi r5, [fp + 4] ;/GET
addi r6, r0, 48 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [fp + 0], r5 ;SET

mvbi r6, [fp + 4] ;/GET
addi r7, r0, 9 ;GET
sub r1, r7, r6
jc 4_true
jz 4_false
addi r6, r0, 1
jmp 4_end
4_true:
addi r6, r0, 0
jmp 4_end
4_end:
sub r6, r6, r0
jz 4_false
mvbi r5, [fp + 4] ;/GET
addi r6, r0, 55 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [fp + 0], r5 ;SET

4_false:

subi sp, sp, 4
mvbi r6, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r6 ;SET
jal _print_char
add r6, r0, r1
addi sp, sp, 4
add fp, r0, sp

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_print_bcd:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 52
add fp, r0, sp



movi r5, [fp + 56] ;GET
movi [fp + 8], r5 ;SET

addi r5, r0, 0 ;GET
movi [fp + 0], r5 ;SET

addi r5, r0, 0 ;GET
movi [fp + 4], r5 ;SET

addi r5, r0, 0 ;GET
movi [fp + 12], r5 ;SET

addi r5, r0, 0 ;GET
movi [fp + 16], r5 ;SET


;for_init
addi r5, r0, 0 ;GET
movi [fp + 20], r5 ;SET
5_start:

;for_condition
movi r6, [fp + 20] ;GET
addi r7, r0, 16 ;GET
sub r1, r6, r7
jc 5_true
jz 5_false
addi r6, r0, 1
jmp 5_end
5_true:
addi r6, r0, 0
jmp 5_end
5_end:
sub r1, r1, r0
jz 5_false

;for_body
movi r7, [fp + 0] ;GET
addi r8, r0, 15 ;GET
add r2, r0, r8
add r1, r0, r7
and r1, r1, r2
add r7, r0, r1 ;BITWISE_AND

addi r8, r0, 4 ;GET
sub r1, r8, r7
jc 6_true
jz 6_false
addi r7, r0, 1
jmp 6_end
6_true:
addi r7, r0, 0
jmp 6_end
6_end:
sub r7, r7, r0
jz 6_false
movi r6, [fp + 0] ;GET
addi r7, r0, 3 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 0], r6 ;SET

6_false:

movi r7, [fp + 0] ;GET
addi r8, r0, 240 ;GET
add r2, r0, r8
add r1, r0, r7
and r1, r1, r2
add r7, r0, r1 ;BITWISE_AND

addi r8, r0, 64 ;GET
sub r1, r8, r7
jc 7_true
jz 7_false
addi r7, r0, 1
jmp 7_end
7_true:
addi r7, r0, 0
jmp 7_end
7_end:
sub r7, r7, r0
jz 7_false
movi r6, [fp + 0] ;GET
addi r7, r0, 48 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 0], r6 ;SET

7_false:

movi r7, [fp + 0] ;GET
addi r8, r0, 3840 ;GET
add r2, r0, r8
add r1, r0, r7
and r1, r1, r2
add r7, r0, r1 ;BITWISE_AND

addi r8, r0, 1024 ;GET
sub r1, r8, r7
jc 8_true
jz 8_false
addi r7, r0, 1
jmp 8_end
8_true:
addi r7, r0, 0
jmp 8_end
8_end:
sub r7, r7, r0
jz 8_false
movi r6, [fp + 0] ;GET
addi r7, r0, 768 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 0], r6 ;SET

8_false:

movi r7, [fp + 0] ;GET
addi r8, r0, 61440 ;GET
add r2, r0, r8
add r1, r0, r7
and r1, r1, r2
add r7, r0, r1 ;BITWISE_AND

addi r8, r0, 16384 ;GET
sub r1, r8, r7
jc 9_true
jz 9_false
addi r7, r0, 1
jmp 9_end
9_true:
addi r7, r0, 0
jmp 9_end
9_end:
sub r7, r7, r0
jz 9_false
movi r6, [fp + 0] ;GET
addi r7, r0, 12288 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 0], r6 ;SET

9_false:

movi r7, [fp + 4] ;GET
addi r8, r0, 15 ;GET
add r2, r0, r8
add r1, r0, r7
and r1, r1, r2
add r7, r0, r1 ;BITWISE_AND

addi r8, r0, 4 ;GET
sub r1, r8, r7
jc 10_true
jz 10_false
addi r7, r0, 1
jmp 10_end
10_true:
addi r7, r0, 0
jmp 10_end
10_end:
sub r7, r7, r0
jz 10_false
movi r6, [fp + 4] ;GET
addi r7, r0, 3 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 4], r6 ;SET

10_false:

movi r7, [fp + 8] ;GET
addi r8, r0, 32768 ;GET
add r2, r0, r8
add r1, r0, r7
and r1, r1, r2
add r7, r0, r1 ;BITWISE_AND

addi r8, r0, 32768 ;GET
sub r1, r8, r7
jz 11_true
addi r7, r0, 0
jmp 11_end
11_true:
addi r7, r0, 1
jmp 11_end
11_end:
sub r7, r7, r0
jz 11_false
addi r6, r0, 1 ;GET
movi [fp + 12], r6 ;SET

11_false:

movi r7, [fp + 8] ;GET
addi r8, r0, 32768 ;GET
add r2, r0, r8
add r1, r0, r7
and r1, r1, r2
add r7, r0, r1 ;BITWISE_AND

addi r8, r0, 0 ;GET
sub r1, r8, r7
jz 12_true
addi r7, r0, 0
jmp 12_end
12_true:
addi r7, r0, 1
jmp 12_end
12_end:
sub r7, r7, r0
jz 12_false
addi r6, r0, 0 ;GET
movi [fp + 12], r6 ;SET

12_false:

movi r7, [fp + 0] ;GET
addi r8, r0, 32768 ;GET
add r2, r0, r8
add r1, r0, r7
and r1, r1, r2
add r7, r0, r1 ;BITWISE_AND

addi r8, r0, 32768 ;GET
sub r1, r8, r7
jz 13_true
addi r7, r0, 0
jmp 13_end
13_true:
addi r7, r0, 1
jmp 13_end
13_end:
sub r7, r7, r0
jz 13_false
addi r6, r0, 1 ;GET
movi [fp + 16], r6 ;SET

13_false:

movi r7, [fp + 0] ;GET
addi r8, r0, 32768 ;GET
add r2, r0, r8
add r1, r0, r7
and r1, r1, r2
add r7, r0, r1 ;BITWISE_AND

addi r8, r0, 0 ;GET
sub r1, r8, r7
jz 14_true
addi r7, r0, 0
jmp 14_end
14_true:
addi r7, r0, 1
jmp 14_end
14_end:
sub r7, r7, r0
jz 14_false
addi r6, r0, 0 ;GET
movi [fp + 16], r6 ;SET

14_false:

movi r6, [fp + 8] ;GET
addi r7, r0, 1 ;GET
add r2, r0, r7
add r1, r0, r6
sl r1, r1, r2
add r6, r0, r1 ;LEFT_SHIFT

movi [fp + 8], r6 ;SET

movi r6, [fp + 0] ;GET
addi r7, r0, 1 ;GET
add r2, r0, r7
add r1, r0, r6
sl r1, r1, r2
add r6, r0, r1 ;LEFT_SHIFT

movi [fp + 0], r6 ;SET

movi r6, [fp + 0] ;GET
movi r7, [fp + 12] ;GET
add r2, r0, r7
add r1, r0, r6
or r1, r1, r2
add r6, r0, r1 ;LOGICAL_OR

movi [fp + 0], r6 ;SET

movi r6, [fp + 4] ;GET
addi r7, r0, 1 ;GET
add r2, r0, r7
add r1, r0, r6
sl r1, r1, r2
add r6, r0, r1 ;LEFT_SHIFT

movi [fp + 4], r6 ;SET

movi r6, [fp + 4] ;GET
movi r7, [fp + 16] ;GET
add r2, r0, r7
add r1, r0, r6
or r1, r1, r2
add r6, r0, r1 ;LOGICAL_OR

movi [fp + 4], r6 ;SET


;for_iter
movi r6, [fp + 20] ;GET
addi r7, r0, 1 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 20], r6 ;SET
jmp 5_start
5_false:

addi r6, r0, 0 ;GET
movi [fp + 24], r6 ;SET

addi r6, r0, 0 ;GET
mvbi [fp + 28], r6 ;SET

movi r6, [fp + 4] ;GET
addi r7, r0, 15 ;GET
add r2, r0, r7
add r1, r0, r6
and r1, r1, r2
add r6, r0, r1 ;BITWISE_AND

addi r7, r0, 48 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 32], r6 ;SET

movi r6, [fp + 0] ;GET
addi r7, r0, 12 ;GET
add r2, r0, r7
add r1, r0, r6
sr r1, r1, r2
add r6, r0, r1 ;RIGHT_SHIFT

addi r7, r0, 15 ;GET
add r2, r0, r7
add r1, r0, r6
and r1, r1, r2
add r6, r0, r1 ;BITWISE_AND

addi r7, r0, 48 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 36], r6 ;SET

movi r6, [fp + 0] ;GET
addi r7, r0, 8 ;GET
add r2, r0, r7
add r1, r0, r6
sr r1, r1, r2
add r6, r0, r1 ;RIGHT_SHIFT

addi r7, r0, 15 ;GET
add r2, r0, r7
add r1, r0, r6
and r1, r1, r2
add r6, r0, r1 ;BITWISE_AND

addi r7, r0, 48 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 40], r6 ;SET

movi r6, [fp + 0] ;GET
addi r7, r0, 4 ;GET
add r2, r0, r7
add r1, r0, r6
sr r1, r1, r2
add r6, r0, r1 ;RIGHT_SHIFT

addi r7, r0, 15 ;GET
add r2, r0, r7
add r1, r0, r6
and r1, r1, r2
add r6, r0, r1 ;BITWISE_AND

addi r7, r0, 48 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 44], r6 ;SET

movi r6, [fp + 0] ;GET
addi r7, r0, 15 ;GET
add r2, r0, r7
add r1, r0, r6
and r1, r1, r2
add r6, r0, r1 ;BITWISE_AND

addi r7, r0, 48 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

movi [fp + 48], r6 ;SET

movi r7, [fp + 32] ;GET
addi r8, r0, 48 ;GET
sub r1, r8, r7
jc 15_true
jz 15_false
addi r7, r0, 1
jmp 15_end
15_true:
addi r7, r0, 0
jmp 15_end
15_end:
sub r7, r7, r0
jz 15_false
addi r6, r0, 1 ;GET
movi [fp + 24], r6 ;SET

subi sp, sp, 4
movi r7, [fp + 32] ;GET_MEMORY
movi [sp + 0], r7 ;SET
jal _print_char
add r7, r0, r1
addi sp, sp, 4
add fp, r0, sp

15_false:

movi r7, [fp + 24] ;GET
addi r8, r0, 1 ;GET
sub r1, r8, r7
jz 16_true
addi r7, r0, 0
jmp 16_end
16_true:
addi r7, r0, 1
jmp 16_end
16_end:
movi r8, [fp + 36] ;GET
addi r9, r0, 48 ;GET
sub r1, r9, r8
jc 17_true
jz 17_false
addi r8, r0, 1
jmp 17_end
17_true:
addi r8, r0, 0
jmp 17_end
17_end:
add r2, r0, r8
add r1, r0, r7
or r1, r1, r2
add r7, r0, r1 ;LOGICAL_OR

sub r7, r7, r0
jz 16_false
addi r6, r0, 1 ;GET
movi [fp + 24], r6 ;SET

subi sp, sp, 4
movi r7, [fp + 36] ;GET_MEMORY
movi [sp + 0], r7 ;SET
jal _print_char
add r7, r0, r1
addi sp, sp, 4
add fp, r0, sp

16_false:

movi r7, [fp + 24] ;GET
addi r8, r0, 1 ;GET
sub r1, r8, r7
jz 18_true
addi r7, r0, 0
jmp 18_end
18_true:
addi r7, r0, 1
jmp 18_end
18_end:
movi r8, [fp + 40] ;GET
addi r9, r0, 48 ;GET
sub r1, r9, r8
jc 19_true
jz 19_false
addi r8, r0, 1
jmp 19_end
19_true:
addi r8, r0, 0
jmp 19_end
19_end:
add r2, r0, r8
add r1, r0, r7
or r1, r1, r2
add r7, r0, r1 ;LOGICAL_OR

sub r7, r7, r0
jz 18_false
addi r6, r0, 1 ;GET
movi [fp + 24], r6 ;SET

subi sp, sp, 4
movi r7, [fp + 40] ;GET_MEMORY
movi [sp + 0], r7 ;SET
jal _print_char
add r7, r0, r1
addi sp, sp, 4
add fp, r0, sp

18_false:

movi r7, [fp + 24] ;GET
addi r8, r0, 1 ;GET
sub r1, r8, r7
jz 20_true
addi r7, r0, 0
jmp 20_end
20_true:
addi r7, r0, 1
jmp 20_end
20_end:
movi r8, [fp + 44] ;GET
addi r9, r0, 48 ;GET
sub r1, r9, r8
jc 21_true
jz 21_false
addi r8, r0, 1
jmp 21_end
21_true:
addi r8, r0, 0
jmp 21_end
21_end:
add r2, r0, r8
add r1, r0, r7
or r1, r1, r2
add r7, r0, r1 ;LOGICAL_OR

sub r7, r7, r0
jz 20_false
addi r6, r0, 1 ;GET
movi [fp + 24], r6 ;SET

subi sp, sp, 4
movi r7, [fp + 44] ;GET_MEMORY
movi [sp + 0], r7 ;SET
jal _print_char
add r7, r0, r1
addi sp, sp, 4
add fp, r0, sp

20_false:

movi r7, [fp + 24] ;GET
addi r8, r0, 1 ;GET
sub r1, r8, r7
jz 22_true
addi r7, r0, 0
jmp 22_end
22_true:
addi r7, r0, 1
jmp 22_end
22_end:
movi r8, [fp + 48] ;GET
addi r9, r0, 48 ;GET
sub r1, r9, r8
jc 23_true
jz 23_false
addi r8, r0, 1
jmp 23_end
23_true:
addi r8, r0, 0
jmp 23_end
23_end:
add r2, r0, r8
add r1, r0, r7
or r1, r1, r2
add r7, r0, r1 ;LOGICAL_OR

sub r7, r7, r0
jz 22_false
addi r6, r0, 1 ;GET
movi [fp + 24], r6 ;SET

subi sp, sp, 4
movi r7, [fp + 48] ;GET_MEMORY
movi [sp + 0], r7 ;SET
jal _print_char
add r7, r0, r1
addi sp, sp, 4
add fp, r0, sp

22_false:

addi sp, sp, 52
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_multiply:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
addi r6, r0, 0 ;GET
movi [fp + 0], r6 ;SET


;for_init
addi r6, r0, 0 ;GET
movi [fp + 4], r6 ;SET
24_start:

;for_condition
movi r7, [fp + 4] ;GET
movi r8, [fp + 16] ;GET
sub r1, r7, r8
jc 24_true
jz 24_false
addi r7, r0, 1
jmp 24_end
24_true:
addi r7, r0, 0
jmp 24_end
24_end:
sub r1, r1, r0
jz 24_false

;for_body
movi r7, [fp + 0] ;GET
movi r8, [fp + 12] ;GET
add r2, r0, r8
add r1, r0, r7
add r1, r1, r2
add r7, r0, r1 ;ADD

movi [fp + 0], r7 ;SET


;for_iter
movi r7, [fp + 4] ;GET
addi r8, r0, 1 ;GET
add r2, r0, r8
add r1, r0, r7
add r1, r1, r2
add r7, r0, r1 ;ADD

movi [fp + 4], r7 ;SET
jmp 24_start
24_false:

movi r8, [fp + 0] ;GET
add r1, r0, r8
addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
add fp, r0, sp
jr ra

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_divide:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
addi r8, r0, 0 ;GET
movi [fp + 0], r8 ;SET

movi r8, [fp + 12] ;GET
movi [fp + 4], r8 ;SET

25_start:
movi r9, [fp + 4] ;GET
addi r10, r0, 32768 ;GET
sub r1, r9, r10
jc 25_true
jz 25_false
addi r9, r0, 1
jmp 25_end
25_true:
addi r9, r0, 0
jmp 25_end
25_end:
sub r9, r9, r0
jz 25_false
movi r8, [fp + 4] ;GET
movi r9, [fp + 16] ;GET
add r2, r0, r9
add r1, r0, r8
sub r1, r1, r2
add r8, r0, r1 ;SUB

movi [fp + 4], r8 ;SET

movi r8, [fp + 0] ;GET
addi r9, r0, 1 ;GET
add r2, r0, r9
add r1, r0, r8
add r1, r1, r2
add r8, r0, r1 ;ADD

movi [fp + 0], r8 ;SET

jmp 25_start
25_false:

movi r9, [fp + 0] ;GET
add r1, r0, r9
addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
add fp, r0, sp
jr ra

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_mod:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
addi r9, r0, 0 ;GET
movi [fp + 0], r9 ;SET

movi r9, [fp + 12] ;GET
movi [fp + 4], r9 ;SET

26_start:
movi r10, [fp + 4] ;GET
addi r11, r0, 32768 ;GET
sub r1, r10, r11
jc 26_true
jz 26_false
addi r10, r0, 1
jmp 26_end
26_true:
addi r10, r0, 0
jmp 26_end
26_end:
sub r10, r10, r0
jz 26_false
movi r9, [fp + 4] ;GET
movi r10, [fp + 16] ;GET
add r2, r0, r10
add r1, r0, r9
sub r1, r1, r2
add r9, r0, r1 ;SUB

movi [fp + 4], r9 ;SET

movi r9, [fp + 0] ;GET
addi r10, r0, 1 ;GET
add r2, r0, r10
add r1, r0, r9
add r1, r1, r2
add r9, r0, r1 ;ADD

movi [fp + 0], r9 ;SET

jmp 26_start
26_false:

movi r9, [fp + 4] ;GET
movi r10, [fp + 16] ;GET
add r2, r0, r10
add r1, r0, r9
add r1, r1, r2
add r9, r0, r1 ;ADD

movi [fp + 0], r9 ;SET

movi r10, [fp + 0] ;GET
add r1, r0, r10
addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
add fp, r0, sp
jr ra

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_primes:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 16
add fp, r0, sp
addi r10, r0, 3 ;GET
movi [fp + 0], r10 ;SET

addi r10, r0, 2 ;GET
movi [fp + 4], r10 ;SET

addi r10, r0, 1 ;GET
movi [fp + 8], r10 ;SET

jal _cr
add r11, r0, r1
add fp, r0, sp

addi r10, r0, 0 ;GET
movi [fp + 12], r10 ;SET

27_start:
movi r11, [fp + 0] ;GET
addi r12, r0, 32768 ;GET
sub r1, r11, r12
jc 27_true
jz 27_false
addi r11, r0, 1
jmp 27_end
27_true:
addi r11, r0, 0
jmp 27_end
27_end:
sub r11, r11, r0
jz 27_false
addi r10, r0, 0 ;GET
movi [fp + 12], r10 ;SET

28_start:
movi r11, [fp + 4] ;GET
movi r12, [fp + 0] ;GET
addi r13, r0, 1 ;GET
add r2, r0, r13
add r1, r0, r12
sr r1, r1, r2
add r12, r0, r1 ;RIGHT_SHIFT

addi r13, r0, 1 ;GET
add r2, r0, r13
add r1, r0, r12
add r1, r1, r2
add r12, r0, r1 ;ADD

sub r1, r11, r12
jc 28_true
jz 28_false
addi r11, r0, 1
jmp 28_end
28_true:
addi r11, r0, 0
jmp 28_end
28_end:
sub r11, r11, r0
jz 28_false
subi sp, sp, 4
movi r10, [fp + 4] ;GET_MEMORY
movi [sp + 0], r10 ;SET
subi sp, sp, 4
movi r10, [fp + 0] ;GET_MEMORY
movi [sp + 0], r10 ;SET
jal _mod
add r10, r0, r1
addi sp, sp, 8
add fp, r0, sp
movi [fp + 8], r10 ;SET

movi r10, [fp + 8] ;GET
addi r11, r0, 0 ;GET
sub r1, r11, r10
jz 29_true
addi r10, r0, 0
jmp 29_end
29_true:
addi r10, r0, 1
jmp 29_end
29_end:
sub r10, r10, r0
jz 29_false
addi r9, r0, 1 ;GET
movi [fp + 12], r9 ;SET

29_false:

movi r9, [fp + 4] ;GET
addi r10, r0, 1 ;GET
add r2, r0, r10
add r1, r0, r9
add r1, r1, r2
add r9, r0, r1 ;ADD

movi [fp + 4], r9 ;SET

jmp 28_start
28_false:

movi r10, [fp + 12] ;GET
addi r11, r0, 0 ;GET
sub r1, r11, r10
jz 30_true
addi r10, r0, 0
jmp 30_end
30_true:
addi r10, r0, 1
jmp 30_end
30_end:
sub r10, r10, r0
jz 30_false
subi sp, sp, 4
movi r10, [fp + 0] ;GET_MEMORY
movi [sp + 0], r10 ;SET
jal _print_bcd
add r10, r0, r1
addi sp, sp, 4
add fp, r0, sp

jal _cr
add r10, r0, r1
add fp, r0, sp

30_false:

movi r9, [fp + 0] ;GET
addi r10, r0, 1 ;GET
add r2, r0, r10
add r1, r0, r9
add r1, r1, r2
add r9, r0, r1 ;ADD

movi [fp + 0], r9 ;SET

addi r9, r0, 2 ;GET
movi [fp + 4], r9 ;SET

jmp 27_start
27_false:

jal _cr
add r10, r0, r1
add fp, r0, sp

addi sp, sp, 16
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_main:
subi sp, sp, 0
add fp, r0, sp
subi sp, sp, 4
addi r10, r0, 123 ;GET
movi [sp + 0], r10 ;SET
jal _print_bcd
add r10, r0, r1
addi sp, sp, 4
add fp, r0, sp

jal _cr
add r10, r0, r1
add fp, r0, sp

subi sp, sp, 4
addi r10, r0, 91 ;GET
movi [sp + 0], r10 ;SET
subi sp, sp, 4
addi r10, r0, 65 ;GET
movi [sp + 0], r10 ;SET
jal _function
add r10, r0, r1
addi sp, sp, 8
add fp, r0, sp

jal _cr
add r10, r0, r1
add fp, r0, sp

subi sp, sp, 4
addi r10, r0, 91 ;GET
movi [sp + 0], r10 ;SET
subi sp, sp, 4
addi r10, r0, 65 ;GET
movi [sp + 0], r10 ;SET
jal _function
add r10, r0, r1
addi sp, sp, 8
add fp, r0, sp

jal _cr
add r10, r0, r1
add fp, r0, sp

subi sp, sp, 4
addi r10, r0, 91 ;GET
movi [sp + 0], r10 ;SET
subi sp, sp, 4
addi r10, r0, 65 ;GET
movi [sp + 0], r10 ;SET
jal _function
add r10, r0, r1
addi sp, sp, 8
add fp, r0, sp

jal _cr
add r10, r0, r1
add fp, r0, sp

jal _primes
add r10, r0, r1
add fp, r0, sp

halt

_test:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp

movi r9, [fp + 0] ;GET
addi r10, r0, 1 ;GET
add r2, r0, r10
add r1, r0, r9
add r1, r1, r2
add r9, r0, r1 ;ADD

movi [fp + 0], r9 ;SET

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

halt

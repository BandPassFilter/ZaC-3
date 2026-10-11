lui fp, 18
addi sp, r0, 65532
lui sp, 18
addi ssp, r0, 65532
lui ssp, 17
lui dp, 4
lui io, 19

jmp _main

_func:
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp

addi r4, r0, 1 ;GET
movi [fp + 0], r4 ;SET

movi r4, [fp + 8] ;GET
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

_main:
subi sp, sp, 40
add fp, r0, sp

addi r4, r0, 21568 ;GET_32
lui r4, 137 ;GET_32
movi [fp + 0], r4 ;SET

addi r4, r0, 0 ;GET
movi r5, [fp + 0] ;GET
mvbi [r5 + 0], r4 ;SET


addi r4, r0, 1 ;GET
addi r5, r0, 2 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

addi r5, r0, 3 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 4], r4 ;SET


addi r4, r0, 5 ;GET
movi [fp + 8], r4 ;SET


addi r4, r0, 0 ;GET
movi [fp + 12], r4 ;SET

addi r4, r0, 3 ;GET
addi r5, r0, 4 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi r5, [fp + 8] ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 4], r4 ;SET

movi r4, [fp + 4] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 0_true
addi r4, r0, 0
jmp 0_end
0_true:
addi r4, r0, 1
jmp 0_end
0_end:
sub r4, r4, r0
jz 0_false
addi r4, r0, 3 ;GET
movi [fp + 4], r4 ;SET

0_false:

addi r4, r0, 0 ;GET
movi [fp + 12], r4 ;SET

movi r4, [fp + 4] ;GET
addi r5, r0, 123 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 16], r4 ;SET

movi r4, [fp + 8] ;GET
movi [fp + 20], r4 ;SET

subi sp, sp, 4
movi r4, [fp + 20] ;GET_MEMORY
movi [sp + 0], r4 ;SET
subi sp, sp, 4
movi r4, [fp + 16] ;GET_MEMORY
movi [sp + 0], r4 ;SET
jal _func
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 8
add fp, r0, sp
movi [fp + 12], r4 ;SET

addi r4, r0, 523 ;GET
movi r5, [fp + 8] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 24], r4 ;SET

movi r4, [fp + 4] ;GET
movi [fp + 28], r4 ;SET

subi sp, sp, 4
movi r4, [fp + 28] ;GET_MEMORY
movi [sp + 0], r4 ;SET
subi sp, sp, 4
movi r4, [fp + 24] ;GET_MEMORY
movi [sp + 0], r4 ;SET
jal _func
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 8
add fp, r0, sp

addi r4, r0, 0 ;GET
movi [fp + 4], r4 ;SET

movi r4, [fp + 12] ;GET
movi [fp + 32], r4 ;SET

movi r4, [fp + 8] ;GET
movi r5, [fp + 4] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 36], r4 ;SET

subi sp, sp, 4
movi r4, [fp + 36] ;GET_MEMORY
movi [sp + 0], r4 ;SET
subi sp, sp, 4
movi r4, [fp + 32] ;GET_MEMORY
movi [sp + 0], r4 ;SET
jal _func
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 8
add fp, r0, sp
movi [fp + 4], r4 ;SET

1_start:
movi r4, [fp + 4] ;GET
addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 1_true
addi r4, r0, 0
jmp 1_end
1_true:
addi r4, r0, 1
jmp 1_end
1_end:
sub r4, r4, r0
jz 1_false
addi r4, r0, 1 ;GET
movi [fp + 4], r4 ;SET

jmp 1_start
1_false:


;for_init
addi r4, r0, 0 ;GET
movi [fp + 4], r4 ;SET
2_start:

;for_condition
movi r4, [fp + 4] ;GET
addi r5, r0, 5 ;GET
sub r1, r4, r5
jc 2_true
jz 2_false
addi r4, r0, 1
jmp 2_end
2_true:
addi r4, r0, 0
jmp 2_end
2_end:
sub r1, r1, r0
jz 2_false

;for_body
addi r4, r0, 1 ;GET
movi [fp + 4], r4 ;SET


;for_iter
movi r4, [fp + 4] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 4], r4 ;SET
jmp 2_start
2_false:

halt

halt

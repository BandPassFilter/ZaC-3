lui fp, 18
addi sp, r0, 65532
lui sp, 18
addi ssp, r0, 65532
lui ssp, 17
lui dp, 4
lui io, 19

jmp _main

_func_b:
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
movi r4, [fp + 4] ;GET
add r1, r0, r4
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
add fp, r0, sp
jr ra

addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_func_a:
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
movi r5, [fp + 4] ;GET
add r1, r0, r5
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
add fp, r0, sp
jr ra

addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
jr ra

_main:
subi sp, sp, 4
add fp, r0, sp
addi r6, r0, 21568 ;GET_32
lui r6, 137 ;GET_32
movi [fp + 0], r6 ;SET

addi r4, r0, 0 ;GET
movi r5, [fp + 0] ;GET
mvbi [r5 + 0], r4 ;SET

subi sp, sp, 4
subi sp, sp, 4
addi r4, r0, 5 ;GET
movi [sp + 0], r4 ;SET
jal _func_b
add r4, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp
movi [sp + 0], r1 ;RETURN_SET_STACK
addi sp, sp, 4
add fp, r0, sp
jal _func_a
add r6, r0, r1 ;RETURN_SET
addi sp, sp, 4
add fp, r0, sp

halt

halt

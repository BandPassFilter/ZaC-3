lui fp, 18
addi sp, r0, 65532
lui sp, 18
addi ssp, r0, 65532
lui ssp, 17
lui dp, 4
lui io, 19

jmp _main

_get_char:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r4, r0, 0 ;GET_32
lui r4, 19 ;GET_32
movi [fp + 0], r4 ;SET

movi r4, [fp + 0] ;GET
mvbi r4, [r4 + 0] ;GET
add r1, r0, r4
addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_print_char:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r5, r0, 0 ;GET_32
lui r5, 19 ;GET_32
movi [fp + 0], r5 ;SET

mvbi r4, [fp + 12] ;/GET
movi r5, [fp + 0] ;GET
mvbi [r5 + 0], r4 ;SET

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_print:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
addi r4, r0, 0 ;GET_32
lui r4, 19 ;GET_32
movi [fp + 0], r4 ;SET


0_start:
movi r4, [fp + 16] ;GET
mvbi r4, [r4 + 0] ;GET
addi r5, r0, 0 ;GET
sub r1, r5, r4
jc 0_true
jz 0_false
addi r4, r0, 1
jmp 0_end
0_true:
addi r4, r0, 0
jmp 0_end
0_end:
sub r4, r4, r0
jz 0_false
movi r4, [fp + 16] ;GET
mvbi r4, [r4 + 0] ;GET
mvbi [fp + 4], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 4] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_char
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

movi r4, [fp + 16] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi [fp + 16], r4 ;SET

jmp 0_start
0_false:

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_main:
subi sp, sp, 12
add fp, r0, sp
addi r4, r0, 21568 ;GET_32
lui r4, 137 ;GET_32
movi [fp + 0], r4 ;SET

addi r4, r0, string_0
lui r4, _string_hi_adrs ;GET_32
movi [fp + 4], r4 ;SET


addi r4, r0, 0 ;GET_32
lui r4, 19 ;GET_32
movi [fp + 8], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 4] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

halt

.asciiz string_0 = "Hello, World!\n"
halt

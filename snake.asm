lui fp, 3
addi sp, r0, 65532
lui sp, 3
addi ssp, r0, 65532
lui ssp, 4
addi dp, r0, 0
lui dp, 5
lui io, 19

jmp _main

_syscall_execute:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r4, r0, 21568 ;GET_32
lui r4, 137 ;GET_32
movi [fp + 0], r4 ;SET

movi r4, [fp + 12] ;GET
movi [dp + syscall_execute_sfunc], r4 ;SET

movi r4, [fp + 16] ;GET
movi [dp + syscall_execute_sarg0], r4 ;SET

movi r4, [fp + 20] ;GET
movi [dp + syscall_execute_sarg1], r4 ;SET

movi r4, [fp + 24] ;GET
movi [dp + syscall_execute_sarg2], r4 ;SET

movi r4, [fp + 28] ;GET
movi [dp + syscall_execute_sarg3], r4 ;SET

addi r4, r0, 0 ;GET
movi [dp + syscall_execute_return_value], r4 ;SET

movi r16, [dp + syscall_execute_sfunc] ;GET

movi r17, [dp + syscall_execute_sarg0] ;GET

movi r18, [dp + syscall_execute_sarg1] ;GET

movi r19, [dp + syscall_execute_sarg2] ;GET

movi r20, [dp + syscall_execute_sarg3] ;GET

syscall

movi [dp + syscall_execute_return_value], r17 ;GET

movi r4, [dp + syscall_execute_return_value] ;GET
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

_printChar:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r5, r0, 0 ;GET
movi [sp + 0], r5 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r5, r0, 0 ;GET
movi [sp + 0], r5 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r5, r0, 0 ;GET
movi [sp + 0], r5 ;SET
;CALL_PARAM_END
subi sp, sp, 4
mvbi r5, [fp + 8] ;GET_MEMORY
mvbi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
addi r5, r0, 0 ;GET
movi [sp + 0], r5 ;SET
;CALL_PARAM_END
jal _syscall_execute
addi sp, sp, 20
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_getChar:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r6, r0, 0 ;GET
movi [sp + 0], r6 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r6, r0, 0 ;GET
movi [sp + 0], r6 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r6, r0, 0 ;GET
movi [sp + 0], r6 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r6, r0, 0 ;GET
movi [sp + 0], r6 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r6, r0, 1 ;GET
movi [sp + 0], r6 ;SET
;CALL_PARAM_END
jal _syscall_execute
addi sp, sp, 20
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r6, r0, r1 ;RETURN_SET
add r1, r0, r6
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_getCharInstant:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r7, r0, 0 ;GET
movi [sp + 0], r7 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r7, r0, 0 ;GET
movi [sp + 0], r7 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r7, r0, 0 ;GET
movi [sp + 0], r7 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r7, r0, 1 ;GET
movi [sp + 0], r7 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r7, r0, 1 ;GET
movi [sp + 0], r7 ;SET
;CALL_PARAM_END
jal _syscall_execute
addi sp, sp, 20
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r7, r0, r1 ;RETURN_SET
add r1, r0, r7
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_kbhit:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r8 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r8, r0, 0 ;GET
movi [sp + 0], r8 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r8, r0, 0 ;GET
movi [sp + 0], r8 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r8, r0, 0 ;GET
movi [sp + 0], r8 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r8, r0, 2 ;GET
movi [sp + 0], r8 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r8, r0, 1 ;GET
movi [sp + 0], r8 ;SET
;CALL_PARAM_END
jal _syscall_execute
addi sp, sp, 20
movi r8, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r8, r0, r1 ;RETURN_SET
add r1, r0, r8
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

__printString:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r8 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r9 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r9, r0, 0 ;GET
movi [sp + 0], r9 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r9, r0, 0 ;GET
movi [sp + 0], r9 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r9, r0, 0 ;GET
movi [sp + 0], r9 ;SET
;CALL_PARAM_END
subi sp, sp, 4
movi r9, [fp + 8] ;GET_MEMORY
movi [sp + 0], r9 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
addi r9, r0, 2 ;GET
movi [sp + 0], r9 ;SET
;CALL_PARAM_END
jal _syscall_execute
addi sp, sp, 20
movi r9, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r8, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r9, r0, r1 ;RETURN_SET

addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_exit:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r8 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r9 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r10 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r10, r0, 0 ;GET
movi [sp + 0], r10 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r10, r0, 0 ;GET
movi [sp + 0], r10 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r10, r0, 0 ;GET
movi [sp + 0], r10 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r10, r0, 0 ;GET
movi [sp + 0], r10 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r10, r0, 10 ;GET
movi [sp + 0], r10 ;SET
;CALL_PARAM_END
jal _syscall_execute
addi sp, sp, 20
movi r10, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r9, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r8, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r10, r0, r1 ;RETURN_SET

addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_get_hex_int:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
addi r11, r0, string_7
lui r11, _string_hi_adrs ;GET_32
movi [fp + 0], r11 ;SET

movi r11, [fp + 0] ;GET
mvbi r12, [fp + 16] ;/GET
add r2, r0, r12
add r1, r0, r11
add r1, r1, r2
add r11, r0, r1 ;ADD_POINTER

addi r12, r0, 48 ;GET
add r2, r0, r12
add r1, r0, r11
sub r1, r1, r2
add r11, r0, r1 ;SUB

mvbi r11, [r11 + 0] ;GET
addi r12, r0, 48 ;GET
add r2, r0, r12
add r1, r0, r11
sub r1, r1, r2
add r11, r0, r1 ;SUB

movi [fp + 4], r11 ;SET

movi r11, [fp + 4] ;GET
add r1, r0, r11
addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_cr:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r12, r0, 10 ;GET
mvbi [fp + 0], r12 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r8 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r9 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r10 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r11 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r12 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r12, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r12 ;SET
;CALL_PARAM_END_A
jal _printChar
addi sp, sp, 4
movi r12, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r11, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r10, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r9, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r8, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r12, r0, r1 ;RETURN_SET

addi r4, r0, 13 ;GET
mvbi [fp + 0], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_printString:
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
jal _printChar
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

_print_hex_byte:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp


mvbi r4, [fp + 16] ;/GET
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
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

mvbi r4, [fp + 16] ;/GET
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
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_print_hex:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 12
add fp, r0, sp



;for_init
addi r3, r0, 16 ;GET
movi [fp + 8], r3 ;SET
3_start:

;for_condition
movi r3, [fp + 8] ;GET
addi r4, r0, 0 ;GET
sub r1, r4, r3
jc 3_true
jz 3_false
addi r3, r0, 1
jmp 3_end
3_true:
addi r3, r0, 0
jmp 3_end
3_end:
sub r1, r1, r0
jz 3_false

;for_body
movi r4, [fp + 20] ;GET
movi r5, [fp + 8] ;GET
addi r6, r0, 4 ;GET
add r2, r0, r6
add r1, r0, r5
sub r1, r1, r2
add r5, r0, r1 ;SUB

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
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET


;for_iter
movi r4, [fp + 8] ;GET
addi r5, r0, 4 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 8], r4 ;SET
jmp 3_start
3_false:

addi sp, sp, 12
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_print_int_hex:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 8] ;GET
addi r5, r0, 16 ;GET
add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _print_hex
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 8] ;GET
addi r5, r0, 65535 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _print_hex
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_print_bcd:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 32
add fp, r0, sp



movi r4, [fp + 40] ;GET
movi [fp + 8], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 0], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 4], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 12], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 16], r4 ;SET


;for_init
addi r3, r0, 0 ;GET
movi [fp + 20], r3 ;SET
5_start:

;for_condition
movi r3, [fp + 20] ;GET
addi r4, r0, 16 ;GET
sub r1, r3, r4
jc 5_true
jz 5_false
addi r3, r0, 1
jmp 5_end
5_true:
addi r3, r0, 0
jmp 5_end
5_end:
sub r1, r1, r0
jz 5_false

;for_body
movi r4, [fp + 0] ;GET
addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 4 ;GET
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
movi r4, [fp + 0] ;GET
addi r5, r0, 3 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

6_false:

movi r4, [fp + 0] ;GET
addi r5, r0, 240 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 64 ;GET
sub r1, r5, r4
jc 7_true
jz 7_false
addi r4, r0, 1
jmp 7_end
7_true:
addi r4, r0, 0
jmp 7_end
7_end:
sub r4, r4, r0
jz 7_false
movi r4, [fp + 0] ;GET
addi r5, r0, 48 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

7_false:

movi r4, [fp + 0] ;GET
addi r5, r0, 3840 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 1024 ;GET
sub r1, r5, r4
jc 8_true
jz 8_false
addi r4, r0, 1
jmp 8_end
8_true:
addi r4, r0, 0
jmp 8_end
8_end:
sub r4, r4, r0
jz 8_false
movi r4, [fp + 0] ;GET
addi r5, r0, 768 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

8_false:

movi r4, [fp + 0] ;GET
addi r5, r0, 61440 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 16384 ;GET
sub r1, r5, r4
jc 9_true
jz 9_false
addi r4, r0, 1
jmp 9_end
9_true:
addi r4, r0, 0
jmp 9_end
9_end:
sub r4, r4, r0
jz 9_false
movi r4, [fp + 0] ;GET
addi r5, r0, 12288 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

9_false:

movi r4, [fp + 4] ;GET
addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 4 ;GET
sub r1, r5, r4
jc 10_true
jz 10_false
addi r4, r0, 1
jmp 10_end
10_true:
addi r4, r0, 0
jmp 10_end
10_end:
sub r4, r4, r0
jz 10_false
movi r4, [fp + 4] ;GET
addi r5, r0, 3 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 4], r4 ;SET

10_false:

movi r4, [fp + 8] ;GET
addi r5, r0, 32768 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 32768 ;GET
sub r1, r4, r5
jz 11_true
addi r4, r0, 0
jmp 11_end
11_true:
addi r4, r0, 1
jmp 11_end
11_end:
sub r4, r4, r0
jz 11_false
addi r4, r0, 1 ;GET
movi [fp + 12], r4 ;SET

11_false:

movi r4, [fp + 8] ;GET
addi r5, r0, 32768 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 12_true
addi r4, r0, 0
jmp 12_end
12_true:
addi r4, r0, 1
jmp 12_end
12_end:
sub r4, r4, r0
jz 12_false
addi r4, r0, 0 ;GET
movi [fp + 12], r4 ;SET

12_false:

movi r4, [fp + 0] ;GET
addi r5, r0, 32768 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 32768 ;GET
sub r1, r4, r5
jz 13_true
addi r4, r0, 0
jmp 13_end
13_true:
addi r4, r0, 1
jmp 13_end
13_end:
sub r4, r4, r0
jz 13_false
addi r4, r0, 1 ;GET
movi [fp + 16], r4 ;SET

13_false:

movi r4, [fp + 0] ;GET
addi r5, r0, 32768 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 14_true
addi r4, r0, 0
jmp 14_end
14_true:
addi r4, r0, 1
jmp 14_end
14_end:
sub r4, r4, r0
jz 14_false
addi r4, r0, 0 ;GET
movi [fp + 16], r4 ;SET

14_false:

movi r4, [fp + 8] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sl r1, r1, r2
add r4, r0, r1 ;LEFT_SHIFT

movi [fp + 8], r4 ;SET

movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sl r1, r1, r2
add r4, r0, r1 ;LEFT_SHIFT

movi [fp + 0], r4 ;SET

movi r4, [fp + 0] ;GET
movi r5, [fp + 12] ;GET
add r2, r0, r5
add r1, r0, r4
or r1, r1, r2
add r4, r0, r1 ;LOGICAL_OR

movi [fp + 0], r4 ;SET

movi r4, [fp + 4] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sl r1, r1, r2
add r4, r0, r1 ;LEFT_SHIFT

movi [fp + 4], r4 ;SET

movi r4, [fp + 4] ;GET
movi r5, [fp + 16] ;GET
add r2, r0, r5
add r1, r0, r4
or r1, r1, r2
add r4, r0, r1 ;LOGICAL_OR

movi [fp + 4], r4 ;SET


;for_iter
movi r4, [fp + 20] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 20], r4 ;SET
jmp 5_start
5_false:

addi r4, r0, 0 ;GET
mvbi [fp + 24], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 28], r4 ;SET

movi r4, [fp + 4] ;GET
addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 48 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 24], r4 ;SET

mvbi r4, [fp + 24] ;/GET
addi r5, r0, 48 ;GET
sub r1, r5, r4
jz 15_true
addi r4, r0, 1
jmp 15_end
15_true:
addi r4, r0, 0
jmp 15_end
15_end:
sub r4, r4, r0
jz 15_false
addi r4, r0, 1 ;GET
movi [fp + 28], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 24] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

15_false:

mvbi r4, [fp + 24] ;/GET
addi r5, r0, 48 ;GET
sub r1, r4, r5
jz 16_true
addi r4, r0, 0
jmp 16_end
16_true:
addi r4, r0, 1
jmp 16_end
16_end:
movi r5, [fp + 28] ;GET
addi r6, r0, 1 ;GET
sub r1, r5, r6
jz 17_true
addi r5, r0, 0
jmp 17_end
17_true:
addi r5, r0, 1
jmp 17_end
17_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 16_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 24] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

16_false:


;for_init
addi r4, r0, 16 ;GET
movi [fp + 20], r4 ;SET
18_start:

;for_condition
movi r4, [fp + 20] ;GET
addi r5, r0, 0 ;GET
sub r1, r5, r4
jc 18_true
jz 18_false
addi r4, r0, 1
jmp 18_end
18_true:
addi r4, r0, 0
jmp 18_end
18_end:
sub r1, r1, r0
jz 18_false

;for_body
movi r4, [fp + 0] ;GET
movi r5, [fp + 20] ;GET
addi r6, r0, 4 ;GET
add r2, r0, r6
add r1, r0, r5
sub r1, r1, r2
add r5, r0, r1 ;SUB

add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 48 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 24], r4 ;SET

mvbi r4, [fp + 24] ;/GET
addi r5, r0, 48 ;GET
sub r1, r5, r4
jz 19_true
addi r4, r0, 1
jmp 19_end
19_true:
addi r4, r0, 0
jmp 19_end
19_end:
sub r4, r4, r0
jz 19_false
addi r4, r0, 1 ;GET
movi [fp + 28], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 24] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

19_false:

mvbi r4, [fp + 24] ;/GET
addi r5, r0, 48 ;GET
sub r1, r4, r5
jz 20_true
addi r4, r0, 0
jmp 20_end
20_true:
addi r4, r0, 1
jmp 20_end
20_end:
movi r5, [fp + 28] ;GET
addi r6, r0, 1 ;GET
sub r1, r5, r6
jz 21_true
addi r5, r0, 0
jmp 21_end
21_true:
addi r5, r0, 1
jmp 21_end
21_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 20_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 24] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

20_false:


;for_iter
movi r4, [fp + 20] ;GET
addi r5, r0, 4 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 20], r4 ;SET
jmp 18_start
18_false:

movi r4, [fp + 28] ;GET
addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 22_true
addi r4, r0, 0
jmp 22_end
22_true:
addi r4, r0, 1
jmp 22_end
22_end:
sub r4, r4, r0
jz 22_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 48 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

22_false:

addi sp, sp, 32
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_debug:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r4, r0, 21568 ;GET_32
lui r4, 137 ;GET_32
movi [fp + 0], r4 ;SET

addi r4, r0, 0 ;GET
movi r5, [fp + 0] ;GET
mvbi [r5 + 0], r4 ;SET

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

.org 131072

_clear_cursor:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r4, r0, string_9
lui r4, _string_hi_adrs ;GET_32
movi [fp + 0], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 27 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_multiply:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
addi r4, r0, 0 ;GET
movi [fp + 0], r4 ;SET


;for_init
addi r3, r0, 0 ;GET
movi [fp + 4], r3 ;SET
23_start:

;for_condition
movi r3, [fp + 4] ;GET
movi r4, [fp + 20] ;GET
sub r1, r3, r4
jc 23_true
jz 23_false
addi r3, r0, 1
jmp 23_end
23_true:
addi r3, r0, 0
jmp 23_end
23_end:
sub r1, r1, r0
jz 23_false

;for_body
movi r4, [fp + 0] ;GET
movi r5, [fp + 16] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET


;for_iter
movi r4, [fp + 4] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 4], r4 ;SET
jmp 23_start
23_false:

movi r4, [fp + 0] ;GET
add r1, r0, r4
addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_mod:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
addi r5, r0, 0 ;GET
movi [fp + 0], r5 ;SET

movi r5, [fp + 16] ;GET
movi [fp + 4], r5 ;SET

24_start:
movi r5, [fp + 4] ;GET
addi r6, r0, 32768 ;GET
sub r1, r5, r6
jc 24_true
jz 24_false
addi r5, r0, 1
jmp 24_end
24_true:
addi r5, r0, 0
jmp 24_end
24_end:
sub r5, r5, r0
jz 24_false
movi r4, [fp + 4] ;GET
movi r5, [fp + 20] ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 4], r4 ;SET

movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

jmp 24_start
24_false:

movi r4, [fp + 4] ;GET
movi r5, [fp + 20] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

movi r4, [fp + 0] ;GET
add r1, r0, r4
addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_draw:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp

;for_init
addi r3, r0, 0 ;GET
movi [fp + 0], r3 ;SET
25_start:

;for_condition
movi r3, [fp + 0] ;GET
addi r4, r0, 1920 ;GET
sub r1, r4, r3
jc 25_true
jz 25_false
addi r3, r0, 1
jmp 25_end
25_true:
addi r3, r0, 0
jmp 25_end
25_end:
sub r1, r1, r0
jz 25_false

;for_body
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 12] ;GET
movi r5, [fp + 0] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET


;for_iter
movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET
jmp 25_start
25_false:

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_clear:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp

;for_init
addi r3, r0, 0 ;GET
movi [fp + 0], r3 ;SET
26_start:

;for_condition
movi r3, [fp + 0] ;GET
addi r4, r0, 1920 ;GET
sub r1, r4, r3
jc 26_true
jz 26_false
addi r3, r0, 1
jmp 26_end
26_true:
addi r3, r0, 0
jmp 26_end
26_end:
sub r1, r1, r0
jz 26_false

;for_body
addi r4, r0, 32 ;GET
movi r5, [fp + 16] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET


;for_iter
movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET
jmp 26_start
26_false:

addi r4, r0, string_10
lui r4, _string_hi_adrs ;GET_32
movi [fp + 4], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 27 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 4] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_check_valid_pos:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
movi r4, [fp + 8] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jc 27_true
jz 27_false
addi r4, r0, 1
jmp 27_end
27_true:
addi r4, r0, 0
jmp 27_end
27_end:
sub r4, r4, r0
jz 27_false
addi r4, r0, 0 ;GET
add r1, r0, r4
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

27_false:

movi r5, [fp + 12] ;GET
addi r6, r0, 1 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

addi r6, r0, 1 ;GET
sub r1, r5, r6
jc 28_true
jz 28_false
addi r5, r0, 1
jmp 28_end
28_true:
addi r5, r0, 0
jmp 28_end
28_end:
sub r5, r5, r0
jz 28_false
addi r5, r0, 0 ;GET
add r1, r0, r5
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

28_false:

movi r6, [fp + 8] ;GET
addi r7, r0, 80 ;GET
sub r1, r7, r6
jc 29_true
jz 29_false
addi r6, r0, 1
jmp 29_end
29_true:
addi r6, r0, 0
jmp 29_end
29_end:
sub r6, r6, r0
jz 29_false
addi r6, r0, 0 ;GET
add r1, r0, r6
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

29_false:

movi r7, [fp + 12] ;GET
addi r8, r0, 23 ;GET
sub r1, r8, r7
jc 30_true
jz 30_false
addi r7, r0, 1
jmp 30_end
30_true:
addi r7, r0, 0
jmp 30_end
30_end:
sub r7, r7, r0
jz 30_false
addi r7, r0, 0 ;GET
add r1, r0, r7
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

30_false:

addi r8, r0, 1 ;GET
add r1, r0, r8
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_clear_pos:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r8 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r9 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r9, r0, 80 ;GET
movi [sp + 0], r9 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r9, r0, 24 ;GET
movi r10, [fp + 24] ;GET
add r2, r0, r10
add r1, r0, r9
sub r1, r1, r2
add r9, r0, r1 ;SUB

movi [sp + 0], r9 ;SET
;CALL_PARAM_END
jal _multiply
addi sp, sp, 8
movi r9, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r8, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r9, r0, r1 ;RETURN_SET
movi [fp + 0], r9 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r8 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r9 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r9, [fp + 24] ;GET_MEMORY
movi [sp + 0], r9 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r9, [fp + 20] ;GET_MEMORY
movi [sp + 0], r9 ;SET
;CALL_PARAM_END_A
jal _check_valid_pos
addi sp, sp, 8
movi r9, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r8, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r9, r0, r1 ;RETURN_SET
movi [fp + 4], r9 ;SET

movi r9, [fp + 4] ;GET
addi r10, r0, 0 ;GET
sub r1, r9, r10
jz 31_true
addi r9, r0, 0
jmp 31_end
31_true:
addi r9, r0, 1
jmp 31_end
31_end:
sub r9, r9, r0
jz 31_false
addi r9, r0, 0 ;GET
add r1, r0, r9
addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

31_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r8 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r9 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r10 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r10, r0, 27 ;GET
movi [sp + 0], r10 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r10, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r9, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r8, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r10, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r8 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r9 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r10 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r10, r0, 91 ;GET
movi [sp + 0], r10 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r10, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r9, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r8, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r10, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r8 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r9 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r10 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r10, r0, 24 ;GET
movi r11, [fp + 24] ;GET
add r2, r0, r11
add r1, r0, r10
sub r1, r1, r2
add r10, r0, r1 ;SUB

movi [sp + 0], r10 ;SET
;CALL_PARAM_END
jal _print_bcd
addi sp, sp, 4
movi r10, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r9, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r8, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r10, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r8 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r9 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r10 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r10, r0, 59 ;GET
movi [sp + 0], r10 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r10, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r9, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r8, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r10, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r8 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r9 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r10 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r10, [fp + 20] ;GET_MEMORY
movi [sp + 0], r10 ;SET
;CALL_PARAM_END_A
jal _print_bcd
addi sp, sp, 4
movi r10, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r9, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r8, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r10, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r7 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r8 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r9 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r10 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r10, r0, 72 ;GET
movi [sp + 0], r10 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r10, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r9, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r8, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r7, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r10, r0, r1 ;RETURN_SET

addi r4, r0, 32 ;GET
movi r5, [fp + 16] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

movi r6, [fp + 20] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 16] ;GET
movi r5, [fp + 0] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi r5, [fp + 20] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi r4, [r4 + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_draw_pos:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 80 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r4, r0, 24 ;GET
movi r5, [fp + 24] ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _multiply
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 0], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 24] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 20] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _check_valid_pos
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 4], r4 ;SET

movi r4, [fp + 4] ;GET
addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 32_true
addi r4, r0, 0
jmp 32_end
32_true:
addi r4, r0, 1
jmp 32_end
32_end:
sub r4, r4, r0
jz 32_false
addi r4, r0, 0 ;GET
add r1, r0, r4
addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

32_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r5, r0, 27 ;GET
movi [sp + 0], r5 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r5, r0, 91 ;GET
movi [sp + 0], r5 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r5, r0, 24 ;GET
movi r6, [fp + 24] ;GET
add r2, r0, r6
add r1, r0, r5
sub r1, r1, r2
add r5, r0, r1 ;SUB

movi [sp + 0], r5 ;SET
;CALL_PARAM_END
jal _print_bcd
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r5, r0, 59 ;GET
movi [sp + 0], r5 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [fp + 20] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
jal _print_bcd
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r5, r0, 72 ;GET
movi [sp + 0], r5 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

movi r4, [fp + 28] ;GET
movi r5, [fp + 16] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

movi r6, [fp + 20] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 16] ;GET
movi r5, [fp + 0] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi r5, [fp + 20] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi r4, [r4 + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_random:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 16
add fp, r0, sp
addi r4, r0, 5 ;GET
movi [fp + 0], r4 ;SET

addi r4, r0, 1 ;GET
movi [fp + 4], r4 ;SET

movi r4, [fp + 28] ;GET
movi [fp + 8], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 28] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 24] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _multiply
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi r5, [fp + 4] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _mod
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 12], r4 ;SET

movi r4, [fp + 12] ;GET
add r1, r0, r4
addi sp, sp, 16
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 16
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_collision:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r5, r0, string_11
lui r5, _string_hi_adrs ;GET_32
movi [fp + 0], r5 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
jal _cr
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [fp + 0] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
jal _cr
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
jal _exit
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_main:
subi sp, sp, 108
add fp, r0, sp
addi r5, r0, string_12
lui r5, _string_hi_adrs ;GET_32
movi [fp + 0], r5 ;SET

addi r5, r0, string_13
lui r5, _string_hi_adrs ;GET_32
movi [fp + 4], r5 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [fp + 4] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
jal _clear_cursor
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

addi r5, r0, 20 ;GET
movi [fp + 8], r5 ;SET

addi r5, r0, 20 ;GET
movi [fp + 12], r5 ;SET

addi r5, r0, 3392 ;GET_32
lui r5, 3 ;GET_32
movi [fp + 16], r5 ;SET

addi r5, r0, 0 ;GET
movi [fp + 20], r5 ;SET

addi r5, r0, 0 ;GET
mvbi [fp + 24], r5 ;SET

addi r5, r0, 10 ;GET
movi [fp + 28], r5 ;SET

addi r5, r0, 10 ;GET
movi [fp + 32], r5 ;SET

addi r5, r0, 5 ;GET
movi [fp + 36], r5 ;SET

addi r5, r0, 16384 ;GET_32
lui r5, 2 ;GET_32
movi [fp + 40], r5 ;SET

addi r5, r0, 8192 ;GET
movi [fp + 44], r5 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [fp + 40] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
jal _clear
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [fp + 40] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
jal _draw
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

addi r5, r0, 0 ;GET
movi [fp + 48], r5 ;SET

addi r5, r0, 2 ;GET
movi [fp + 52], r5 ;SET

addi r5, r0, 42 ;GET
movi [fp + 56], r5 ;SET

addi r5, r0, 128 ;GET
movi [fp + 60], r5 ;SET

addi r5, r0, 3 ;GET
movi [fp + 64], r5 ;SET

addi r5, r0, string_14
lui r5, _string_hi_adrs ;GET_32
movi [fp + 68], r5 ;SET


;for_init
addi r3, r0, 0 ;GET
movi [fp + 72], r3 ;SET
33_start:

;for_condition
movi r3, [fp + 72] ;GET
movi r4, [fp + 60] ;GET
sub r1, r3, r4
jc 33_true
jz 33_false
addi r3, r0, 1
jmp 33_end
33_true:
addi r3, r0, 0
jmp 33_end
33_end:
sub r1, r1, r0
jz 33_false

;for_body
addi r4, r0, 0 ;GET
movi r5, [fp + 68] ;GET
movi r6, [fp + 72] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET


;for_iter
movi r4, [fp + 72] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 72], r4 ;SET
jmp 33_start
33_false:

34_start:
addi r4, r0, 1 ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 34_true
addi r4, r0, 0
jmp 34_end
34_true:
addi r4, r0, 1
jmp 34_end
34_end:
sub r4, r4, r0
jz 34_false

;for_init
addi r4, r0, 0 ;GET
movi [fp + 72], r4 ;SET
35_start:

;for_condition
movi r4, [fp + 72] ;GET
movi r5, [fp + 16] ;GET
sub r1, r4, r5
jc 35_true
jz 35_false
addi r4, r0, 1
jmp 35_end
35_true:
addi r4, r0, 0
jmp 35_end
35_end:
sub r1, r1, r0
jz 35_false

;for_body

;for_iter
movi r4, [fp + 72] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 72], r4 ;SET
jmp 35_start
35_false:

movi r4, [fp + 20] ;GET
addi r5, r0, 500 ;GET
sub r1, r5, r4
jc 36_true
jz 36_false
addi r4, r0, 1
jmp 36_end
36_true:
addi r4, r0, 0
jmp 36_end
36_end:
sub r4, r4, r0
jz 36_false
addi r4, r0, 0 ;GET
movi [fp + 20], r4 ;SET

36_false:

movi r4, [fp + 20] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 20], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _getCharInstant
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
mvbi [fp + 24], r4 ;SET

addi r4, r0, string_15
lui r4, _string_hi_adrs ;GET_32
movi [fp + 76], r4 ;SET

addi r4, r0, string_16
lui r4, _string_hi_adrs ;GET_32
movi [fp + 80], r4 ;SET

addi r4, r0, string_17
lui r4, _string_hi_adrs ;GET_32
movi [fp + 84], r4 ;SET

addi r4, r0, string_18
lui r4, _string_hi_adrs ;GET_32
movi [fp + 88], r4 ;SET

movi r4, [fp + 48] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 37_true
addi r4, r0, 0
jmp 37_end
37_true:
addi r4, r0, 1
jmp 37_end
37_end:
sub r4, r4, r0
jz 37_false
movi r4, [fp + 8] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 8], r4 ;SET

37_false:

movi r4, [fp + 48] ;GET
addi r5, r0, 2 ;GET
sub r1, r4, r5
jz 38_true
addi r4, r0, 0
jmp 38_end
38_true:
addi r4, r0, 1
jmp 38_end
38_end:
sub r4, r4, r0
jz 38_false
movi r4, [fp + 8] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 8], r4 ;SET

38_false:

movi r4, [fp + 52] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 39_true
addi r4, r0, 0
jmp 39_end
39_true:
addi r4, r0, 1
jmp 39_end
39_end:
sub r4, r4, r0
jz 39_false
movi r4, [fp + 12] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 12], r4 ;SET

39_false:

movi r4, [fp + 52] ;GET
addi r5, r0, 2 ;GET
sub r1, r4, r5
jz 40_true
addi r4, r0, 0
jmp 40_end
40_true:
addi r4, r0, 1
jmp 40_end
40_end:
sub r4, r4, r0
jz 40_false
movi r4, [fp + 12] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 12], r4 ;SET

40_false:

mvbi r4, [fp + 24] ;/GET
addi r5, r0, 119 ;GET
sub r1, r4, r5
jz 41_true
addi r4, r0, 0
jmp 41_end
41_true:
addi r4, r0, 1
jmp 41_end
41_end:
sub r4, r4, r0
jz 41_false
movi r4, [fp + 52] ;GET
addi r5, r0, 2 ;GET
sub r1, r5, r4
jz 42_true
addi r4, r0, 1
jmp 42_end
42_true:
addi r4, r0, 0
jmp 42_end
42_end:
sub r4, r4, r0
jz 42_false
addi r4, r0, 1 ;GET
movi [fp + 52], r4 ;SET

42_false:

addi r4, r0, 0 ;GET
movi [fp + 48], r4 ;SET

movi r4, [fp + 20] ;GET
movi [fp + 56], r4 ;SET

41_false:

mvbi r4, [fp + 24] ;/GET
addi r5, r0, 115 ;GET
sub r1, r4, r5
jz 43_true
addi r4, r0, 0
jmp 43_end
43_true:
addi r4, r0, 1
jmp 43_end
43_end:
sub r4, r4, r0
jz 43_false
movi r4, [fp + 52] ;GET
addi r5, r0, 1 ;GET
sub r1, r5, r4
jz 44_true
addi r4, r0, 1
jmp 44_end
44_true:
addi r4, r0, 0
jmp 44_end
44_end:
sub r4, r4, r0
jz 44_false
addi r4, r0, 2 ;GET
movi [fp + 52], r4 ;SET

44_false:

addi r4, r0, 0 ;GET
movi [fp + 48], r4 ;SET

movi r4, [fp + 20] ;GET
movi [fp + 56], r4 ;SET

43_false:

mvbi r4, [fp + 24] ;/GET
addi r5, r0, 97 ;GET
sub r1, r4, r5
jz 45_true
addi r4, r0, 0
jmp 45_end
45_true:
addi r4, r0, 1
jmp 45_end
45_end:
sub r4, r4, r0
jz 45_false
movi r4, [fp + 48] ;GET
addi r5, r0, 1 ;GET
sub r1, r5, r4
jz 46_true
addi r4, r0, 1
jmp 46_end
46_true:
addi r4, r0, 0
jmp 46_end
46_end:
sub r4, r4, r0
jz 46_false
addi r4, r0, 2 ;GET
movi [fp + 48], r4 ;SET

46_false:

addi r4, r0, 0 ;GET
movi [fp + 52], r4 ;SET

movi r4, [fp + 20] ;GET
movi [fp + 56], r4 ;SET

45_false:

mvbi r4, [fp + 24] ;/GET
addi r5, r0, 100 ;GET
sub r1, r4, r5
jz 47_true
addi r4, r0, 0
jmp 47_end
47_true:
addi r4, r0, 1
jmp 47_end
47_end:
sub r4, r4, r0
jz 47_false
movi r4, [fp + 48] ;GET
addi r5, r0, 2 ;GET
sub r1, r5, r4
jz 48_true
addi r4, r0, 1
jmp 48_end
48_true:
addi r4, r0, 0
jmp 48_end
48_end:
sub r4, r4, r0
jz 48_false
addi r4, r0, 1 ;GET
movi [fp + 48], r4 ;SET

48_false:

addi r4, r0, 0 ;GET
movi [fp + 52], r4 ;SET

movi r4, [fp + 20] ;GET
movi [fp + 56], r4 ;SET

47_false:

movi r4, [fp + 36] ;GET
addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 49_true
addi r4, r0, 0
jmp 49_end
49_true:
addi r4, r0, 1
jmp 49_end
49_end:
sub r4, r4, r0
jz 49_false

;for_init
addi r4, r0, 0 ;GET
movi [fp + 72], r4 ;SET
50_start:

;for_condition
movi r4, [fp + 72] ;GET
movi r5, [fp + 64] ;GET
addi r6, r0, 1 ;GET
add r2, r0, r6
add r1, r0, r5
sl r1, r1, r2
add r5, r0, r1 ;LEFT_SHIFT

sub r1, r4, r5
jc 50_true
jz 50_false
addi r4, r0, 1
jmp 50_end
50_true:
addi r4, r0, 0
jmp 50_end
50_end:
sub r1, r1, r0
jz 50_false

;for_body
movi r4, [fp + 8] ;GET
movi r5, [fp + 68] ;GET
movi r6, [fp + 72] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
sub r1, r4, r5
jz 51_true
addi r4, r0, 0
jmp 51_end
51_true:
addi r4, r0, 1
jmp 51_end
51_end:
sub r4, r4, r0
jz 51_false
movi r4, [fp + 12] ;GET
movi r5, [fp + 68] ;GET
movi r6, [fp + 72] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 1 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi r5, [r5 + 0] ;GET
sub r1, r4, r5
jz 52_true
addi r4, r0, 0
jmp 52_end
52_true:
addi r4, r0, 1
jmp 52_end
52_end:
sub r4, r4, r0
jz 52_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _collision
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

52_false:

51_false:


;for_iter
movi r4, [fp + 72] ;GET
addi r5, r0, 2 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 72], r4 ;SET
jmp 50_start
50_false:

49_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 12] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 8] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _check_valid_pos
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 53_true
addi r4, r0, 0
jmp 53_end
53_true:
addi r4, r0, 1
jmp 53_end
53_end:
sub r4, r4, r0
jz 53_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _collision
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

53_false:

movi r4, [fp + 36] ;GET
addi r5, r0, 0 ;GET
sub r1, r5, r4
jc 54_true
jz 54_false
addi r4, r0, 1
jmp 54_end
54_true:
addi r4, r0, 0
jmp 54_end
54_end:
sub r4, r4, r0
jz 54_false
movi r4, [fp + 36] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 36], r4 ;SET

54_false:


;for_init
movi r4, [fp + 60] ;GET
movi [fp + 72], r4 ;SET
55_start:

;for_condition
movi r4, [fp + 72] ;GET
addi r5, r0, 0 ;GET
sub r1, r5, r4
jc 55_true
jz 55_false
addi r4, r0, 1
jmp 55_end
55_true:
addi r4, r0, 0
jmp 55_end
55_end:
sub r1, r1, r0
jz 55_false

;for_body
movi r4, [fp + 68] ;GET
movi r5, [fp + 72] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

addi r5, r0, 2 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

addi r5, r0, 2 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

mvbi r4, [r4 + 0] ;GET
movi r5, [fp + 68] ;GET
movi r6, [fp + 72] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 2 ;GET
add r2, r0, r6
add r1, r0, r5
sub r1, r1, r2
add r5, r0, r1 ;SUB

mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 68] ;GET
movi r5, [fp + 72] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

addi r5, r0, 2 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

mvbi r4, [r4 + 0] ;GET
movi r5, [fp + 68] ;GET
movi r6, [fp + 72] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 1 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

addi r6, r0, 2 ;GET
add r2, r0, r6
add r1, r0, r5
sub r1, r1, r2
add r5, r0, r1 ;SUB

mvbi [r5 + 0], r4 ;SET


;for_iter
movi r4, [fp + 72] ;GET
addi r5, r0, 2 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 72], r4 ;SET
jmp 55_start
55_false:

movi r4, [fp + 8] ;GET
movi r5, [fp + 68] ;GET
mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 12] ;GET
movi r5, [fp + 68] ;GET
addi r6, r0, 1 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 68] ;GET
movi r5, [fp + 64] ;GET
addi r6, r0, 1 ;GET
add r2, r0, r6
add r1, r0, r5
sl r1, r1, r2
add r5, r0, r1 ;LEFT_SHIFT

add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi [fp + 92], r4 ;SET

movi r4, [fp + 68] ;GET
movi r5, [fp + 64] ;GET
addi r6, r0, 1 ;GET
add r2, r0, r6
add r1, r0, r5
sl r1, r1, r2
add r5, r0, r1 ;LEFT_SHIFT

add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi r4, [r4 + 0] ;GET
movi [fp + 96], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 96] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 92] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 40] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _clear_pos
addi sp, sp, 12
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 42 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
subi sp, sp, 4
movi r4, [fp + 12] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 8] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 40] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _draw_pos
addi sp, sp, 16
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

movi r4, [fp + 8] ;GET
movi r5, [fp + 28] ;GET
sub r1, r4, r5
jz 56_true
addi r4, r0, 0
jmp 56_end
56_true:
addi r4, r0, 1
jmp 56_end
56_end:
movi r5, [fp + 12] ;GET
movi r6, [fp + 32] ;GET
sub r1, r5, r6
jz 57_true
addi r5, r0, 0
jmp 57_end
57_true:
addi r5, r0, 1
jmp 57_end
57_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 56_false
movi r4, [fp + 64] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 64], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 32768 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
subi sp, sp, 4
movi r4, [fp + 28] ;GET
movi r5, [fp + 56] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _random
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 100], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 32768 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
subi sp, sp, 4
movi r4, [fp + 32] ;GET
movi r5, [fp + 56] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _random
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 104], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 70 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
subi sp, sp, 4
movi r4, [fp + 100] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _mod
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 28], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 20 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
subi sp, sp, 4
movi r4, [fp + 100] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _mod
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 32], r4 ;SET

56_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 43 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
subi sp, sp, 4
movi r4, [fp + 32] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 28] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 40] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _draw_pos
addi sp, sp, 16
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

jmp 34_start
34_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _exit
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

halt

.word syscall_execute_sfunc = 0
.word syscall_execute_sarg0 = 0
.word syscall_execute_sarg1 = 0
.word syscall_execute_sarg2 = 0
.word syscall_execute_sarg3 = 0
.word syscall_execute_return_value = 0
.asciiz string_7 = "0123456789       :;<=>?"
.asciiz string_9 = "[?25l"
.asciiz string_10 = "[2J"
.asciiz string_11 = "Game over!"
.asciiz string_12 = "hello world test\n"
.asciiz string_13 = "CharInstant demo\n"
.asciiz string_14 = "                                                    "
.asciiz string_15 = "Up\n"
.asciiz string_16 = "Down\n"
.asciiz string_17 = "Left\n"
.asciiz string_18 = "Right\n"
halt

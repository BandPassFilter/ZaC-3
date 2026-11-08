lui fp, 3
addi sp, r0, 65532
lui sp, 3
addi ssp, r0, 65532
lui ssp, 4
addi dp, r0, 0
lui dp, 5
lui io, 19

jmp _main

_print_char:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r4, r0, 0 ;GET_32
lui r4, 19 ;GET_32
movi [fp + 0], r4 ;SET

mvbi r4, [fp + 12] ;/GET
movi r5, [fp + 0] ;GET
mvbi [r5 + 0], r4 ;SET

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

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

_diskRead:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 12
add fp, r0, sp
addi r5, r0, 256 ;GET_32
lui r5, 19 ;GET_32
movi [fp + 0], r5 ;SET

addi r5, r0, string_0
lui r5, _string_hi_adrs ;GET_32
movi [fp + 4], r5 ;SET

movi r4, [fp + 24] ;GET
movi r5, [fp + 0] ;GET
movi [r5 + 0], r4 ;SET

addi r4, r0, 1 ;GET
movi r5, [fp + 0] ;GET
addi r6, r0, 2 ;GET
add r2, r0, r6
addi r7, r0, 2
sl r2, r2, r7
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

movi [r5 + 0], r4 ;SET


;for_init
addi r3, r0, 0 ;GET
movi [fp + 8], r3 ;SET
0_start:

;for_condition
movi r3, [fp + 8] ;GET
addi r4, r0, 128 ;GET
sub r1, r3, r4
jc 0_true
jz 0_false
addi r3, r0, 1
jmp 0_end
0_true:
addi r3, r0, 0
jmp 0_end
0_end:
sub r1, r1, r0
jz 0_false

;for_body
movi r4, [fp + 0] ;GET
addi r5, r0, 4 ;GET
add r2, r0, r5
addi r6, r0, 2
sl r2, r2, r6
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi r4, [r4 + 0] ;GET
movi r5, [fp + 20] ;GET
movi r6, [fp + 8] ;GET
add r2, r0, r6
addi r7, r0, 2
sl r2, r2, r7
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

movi [r5 + 0], r4 ;SET


;for_iter
movi r4, [fp + 8] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 8], r4 ;SET
jmp 0_start
0_false:

addi sp, sp, 12
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_diskWrite:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 12
add fp, r0, sp
addi r4, r0, 256 ;GET_32
lui r4, 19 ;GET_32
movi [fp + 0], r4 ;SET

addi r4, r0, string_1
lui r4, _string_hi_adrs ;GET_32
movi [fp + 4], r4 ;SET

movi r4, [fp + 24] ;GET
movi r5, [fp + 0] ;GET
movi [r5 + 0], r4 ;SET

addi r4, r0, 1 ;GET
movi r5, [fp + 0] ;GET
addi r6, r0, 3 ;GET
add r2, r0, r6
addi r7, r0, 2
sl r2, r2, r7
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

movi [r5 + 0], r4 ;SET


;for_init
addi r3, r0, 0 ;GET
movi [fp + 8], r3 ;SET
1_start:

;for_condition
movi r3, [fp + 8] ;GET
addi r4, r0, 128 ;GET
sub r1, r3, r4
jc 1_true
jz 1_false
addi r3, r0, 1
jmp 1_end
1_true:
addi r3, r0, 0
jmp 1_end
1_end:
sub r1, r1, r0
jz 1_false

;for_body
movi r4, [fp + 20] ;GET
movi r5, [fp + 8] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi r5, [fp + 0] ;GET
addi r6, r0, 4 ;GET
add r2, r0, r6
addi r7, r0, 2
sl r2, r2, r7
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

movi [r5 + 0], r4 ;SET


;for_iter
movi r4, [fp + 8] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 8], r4 ;SET
jmp 1_start
1_false:

addi sp, sp, 12
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

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
movi r7, [fp + 8] ;GET_MEMORY
movi [sp + 0], r7 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
addi r7, r0, 2 ;GET
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
addi r8, r0, 0 ;GET
movi [sp + 0], r8 ;SET
;CALL_PARAM_END
subi sp, sp, 4
addi r8, r0, 10 ;GET
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
addi r9, r0, string_9
lui r9, _string_hi_adrs ;GET_32
movi [fp + 0], r9 ;SET

movi r9, [fp + 0] ;GET
mvbi r10, [fp + 16] ;/GET
add r2, r0, r10
add r1, r0, r9
add r1, r1, r2
add r9, r0, r1 ;ADD_POINTER

addi r10, r0, 48 ;GET
add r2, r0, r10
add r1, r0, r9
sub r1, r1, r2
add r9, r0, r1 ;SUB

mvbi r9, [r9 + 0] ;GET
addi r10, r0, 48 ;GET
add r2, r0, r10
add r1, r0, r9
sub r1, r1, r2
add r9, r0, r1 ;SUB

movi [fp + 4], r9 ;SET

movi r9, [fp + 4] ;GET
add r1, r0, r9
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
addi r10, r0, 10 ;GET
mvbi [fp + 0], r10 ;SET

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
mvbi r10, [fp + 0] ;GET_MEMORY
mvbi [sp + 0], r10 ;SET
;CALL_PARAM_END_A
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


2_start:
movi r4, [fp + 16] ;GET
mvbi r4, [r4 + 0] ;GET
addi r5, r0, 0 ;GET
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

jmp 2_start
2_false:

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
5_start:

;for_condition
movi r3, [fp + 8] ;GET
addi r4, r0, 0 ;GET
sub r1, r4, r3
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
jmp 5_start
5_false:

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
7_start:

;for_condition
movi r3, [fp + 20] ;GET
addi r4, r0, 16 ;GET
sub r1, r3, r4
jc 7_true
jz 7_false
addi r3, r0, 1
jmp 7_end
7_true:
addi r3, r0, 0
jmp 7_end
7_end:
sub r1, r1, r0
jz 7_false

;for_body
movi r4, [fp + 0] ;GET
addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 4 ;GET
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
addi r5, r0, 3 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

8_false:

movi r4, [fp + 0] ;GET
addi r5, r0, 240 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 64 ;GET
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
addi r5, r0, 48 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

9_false:

movi r4, [fp + 0] ;GET
addi r5, r0, 3840 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 1024 ;GET
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
movi r4, [fp + 0] ;GET
addi r5, r0, 768 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

10_false:

movi r4, [fp + 0] ;GET
addi r5, r0, 61440 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 16384 ;GET
sub r1, r5, r4
jc 11_true
jz 11_false
addi r4, r0, 1
jmp 11_end
11_true:
addi r4, r0, 0
jmp 11_end
11_end:
sub r4, r4, r0
jz 11_false
movi r4, [fp + 0] ;GET
addi r5, r0, 12288 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

11_false:

movi r4, [fp + 4] ;GET
addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 4 ;GET
sub r1, r5, r4
jc 12_true
jz 12_false
addi r4, r0, 1
jmp 12_end
12_true:
addi r4, r0, 0
jmp 12_end
12_end:
sub r4, r4, r0
jz 12_false
movi r4, [fp + 4] ;GET
addi r5, r0, 3 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 4], r4 ;SET

12_false:

movi r4, [fp + 8] ;GET
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
movi [fp + 12], r4 ;SET

13_false:

movi r4, [fp + 8] ;GET
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
movi [fp + 12], r4 ;SET

14_false:

movi r4, [fp + 0] ;GET
addi r5, r0, 32768 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 32768 ;GET
sub r1, r4, r5
jz 15_true
addi r4, r0, 0
jmp 15_end
15_true:
addi r4, r0, 1
jmp 15_end
15_end:
sub r4, r4, r0
jz 15_false
addi r4, r0, 1 ;GET
movi [fp + 16], r4 ;SET

15_false:

movi r4, [fp + 0] ;GET
addi r5, r0, 32768 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 16_true
addi r4, r0, 0
jmp 16_end
16_true:
addi r4, r0, 1
jmp 16_end
16_end:
sub r4, r4, r0
jz 16_false
addi r4, r0, 0 ;GET
movi [fp + 16], r4 ;SET

16_false:

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
jmp 7_start
7_false:

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
jz 17_true
addi r4, r0, 1
jmp 17_end
17_true:
addi r4, r0, 0
jmp 17_end
17_end:
sub r4, r4, r0
jz 17_false
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

17_false:

mvbi r4, [fp + 24] ;/GET
addi r5, r0, 48 ;GET
sub r1, r4, r5
jz 18_true
addi r4, r0, 0
jmp 18_end
18_true:
addi r4, r0, 1
jmp 18_end
18_end:
movi r5, [fp + 28] ;GET
addi r6, r0, 1 ;GET
sub r1, r5, r6
jz 19_true
addi r5, r0, 0
jmp 19_end
19_true:
addi r5, r0, 1
jmp 19_end
19_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 18_false
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

18_false:


;for_init
addi r4, r0, 16 ;GET
movi [fp + 20], r4 ;SET
20_start:

;for_condition
movi r4, [fp + 20] ;GET
addi r5, r0, 0 ;GET
sub r1, r5, r4
jc 20_true
jz 20_false
addi r4, r0, 1
jmp 20_end
20_true:
addi r4, r0, 0
jmp 20_end
20_end:
sub r1, r1, r0
jz 20_false

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
jz 21_true
addi r4, r0, 1
jmp 21_end
21_true:
addi r4, r0, 0
jmp 21_end
21_end:
sub r4, r4, r0
jz 21_false
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

21_false:

mvbi r4, [fp + 24] ;/GET
addi r5, r0, 48 ;GET
sub r1, r4, r5
jz 22_true
addi r4, r0, 0
jmp 22_end
22_true:
addi r4, r0, 1
jmp 22_end
22_end:
movi r5, [fp + 28] ;GET
addi r6, r0, 1 ;GET
sub r1, r5, r6
jz 23_true
addi r5, r0, 0
jmp 23_end
23_true:
addi r5, r0, 1
jmp 23_end
23_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 22_false
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

22_false:


;for_iter
movi r4, [fp + 20] ;GET
addi r5, r0, 4 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 20], r4 ;SET
jmp 20_start
20_false:

movi r4, [fp + 28] ;GET
addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 24_true
addi r4, r0, 0
jmp 24_end
24_true:
addi r4, r0, 1
jmp 24_end
24_end:
sub r4, r4, r0
jz 24_false
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

24_false:

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

_get_int:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 16
add fp, r0, sp
addi r4, r0, 0 ;GET
movi [fp + 0], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 4], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 8], r4 ;SET

25_start:
movi r4, [fp + 24] ;GET
movi r5, [fp + 0] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
addi r5, r0, 32 ;GET
sub r1, r5, r4
jc 25_true
jz 25_false
addi r4, r0, 1
jmp 25_end
25_true:
addi r4, r0, 0
jmp 25_end
25_end:
sub r4, r4, r0
jz 25_false
movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

movi r4, [fp + 8] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 8], r4 ;SET

jmp 25_start
25_false:

movi r4, [fp + 8] ;GET
addi r5, r0, 2 ;GET
add r2, r0, r5
add r1, r0, r4
sl r1, r1, r2
add r4, r0, r1 ;LEFT_SHIFT

movi [fp + 8], r4 ;SET


;for_init
addi r3, r0, 0 ;GET
movi [fp + 12], r3 ;SET
26_start:

;for_condition
movi r3, [fp + 12] ;GET
movi r4, [fp + 8] ;GET
sub r1, r3, r4
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
movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 0], r4 ;SET

movi r4, [fp + 4] ;GET
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [fp + 24] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END
jal _get_hex_int
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET
movi r6, [fp + 12] ;GET
add r2, r0, r6
add r1, r0, r5
sl r1, r1, r2
add r5, r0, r1 ;LEFT_SHIFT

add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 4], r4 ;SET


;for_iter
movi r4, [fp + 12] ;GET
addi r5, r0, 4 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 12], r4 ;SET
jmp 26_start
26_false:

movi r4, [fp + 4] ;GET
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

_compare_fixed_string:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r5, r0, 0 ;GET
movi [fp + 0], r5 ;SET

27_start:
movi r5, [fp + 0] ;GET
movi r6, [fp + 20] ;GET
sub r1, r5, r6
jc 27_true
jz 27_false
addi r5, r0, 1
jmp 27_end
27_true:
addi r5, r0, 0
jmp 27_end
27_end:
movi r6, [fp + 12] ;GET
movi r7, [fp + 0] ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi r6, [r6 + 0] ;GET
movi r7, [fp + 16] ;GET
movi r8, [fp + 0] ;GET
add r2, r0, r8
add r1, r0, r7
add r1, r1, r2
add r7, r0, r1 ;ADD_POINTER

mvbi r7, [r7 + 0] ;GET
sub r1, r6, r7
jz 28_true
addi r6, r0, 0
jmp 28_end
28_true:
addi r6, r0, 1
jmp 28_end
28_end:
add r2, r0, r6
add r1, r0, r5
and r1, r1, r2
add r5, r0, r1 ;LOGICAL_AND

sub r5, r5, r0
jz 27_false
movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

jmp 27_start
27_false:

movi r4, [fp + 0] ;GET
movi r5, [fp + 20] ;GET
sub r1, r4, r5
jz 29_true
addi r4, r0, 0
jmp 29_end
29_true:
addi r4, r0, 1
jmp 29_end
29_end:
sub r4, r4, r0
jz 29_false
addi r4, r0, 1 ;GET
add r1, r0, r4
addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

29_false:

addi r5, r0, 0 ;GET
add r1, r0, r5
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

_compare_string:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r6, r0, 0 ;GET
movi [fp + 0], r6 ;SET

30_start:
movi r6, [fp + 12] ;GET
movi r7, [fp + 0] ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi r6, [r6 + 0] ;GET
movi r7, [fp + 16] ;GET
movi r8, [fp + 0] ;GET
add r2, r0, r8
add r1, r0, r7
add r1, r1, r2
add r7, r0, r1 ;ADD_POINTER

mvbi r7, [r7 + 0] ;GET
sub r1, r6, r7
jz 30_true
addi r6, r0, 0
jmp 30_end
30_true:
addi r6, r0, 1
jmp 30_end
30_end:
sub r6, r6, r0
jz 30_false
movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

movi r4, [fp + 16] ;GET
movi r5, [fp + 0] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 31_true
addi r4, r0, 0
jmp 31_end
31_true:
addi r4, r0, 1
jmp 31_end
31_end:
sub r4, r4, r0
jz 31_false
addi r4, r0, 1 ;GET
add r1, r0, r4
addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

31_false:

movi r5, [fp + 12] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 32 ;GET
sub r1, r5, r6
jz 32_true
addi r5, r0, 0
jmp 32_end
32_true:
addi r5, r0, 1
jmp 32_end
32_end:
sub r5, r5, r0
jz 32_false
addi r5, r0, 1 ;GET
add r1, r0, r5
addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

32_false:

jmp 30_start
30_false:

addi r4, r0, 0 ;GET
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

_reset_shell:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
addi r5, r0, 0 ;GET
movi [fp + 0], r5 ;SET

33_start:
movi r5, [fp + 0] ;GET
addi r6, r0, 256 ;GET
sub r1, r5, r6
jc 33_true
jz 33_false
addi r5, r0, 1
jmp 33_end
33_true:
addi r5, r0, 0
jmp 33_end
33_end:
sub r5, r5, r0
jz 33_false
addi r4, r0, 0 ;GET
movi r5, [fp + 16] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

jmp 33_start
33_false:

addi r4, r0, string_10
lui r4, _string_hi_adrs ;GET_32
movi [fp + 4], r4 ;SET

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

_read_halfword_hex:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 12
add fp, r0, sp
addi r4, r0, 0 ;GET
movi [fp + 0], r4 ;SET

movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 4], r4 ;SET

movi r4, [fp + 20] ;GET
movi r5, [fp + 0] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
mvbi [fp + 8], r4 ;SET

movi r4, [fp + 20] ;GET
movi r5, [fp + 0] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
addi r5, r0, 48 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

addi r5, r0, 12 ;GET
add r2, r0, r5
add r1, r0, r4
sl r1, r1, r2
add r4, r0, r1 ;LEFT_SHIFT

movi [fp + 4], r4 ;SET

movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

movi r4, [fp + 4] ;GET
movi r5, [fp + 20] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 48 ;GET
add r2, r0, r6
add r1, r0, r5
sub r1, r1, r2
add r5, r0, r1 ;SUB

addi r6, r0, 8 ;GET
add r2, r0, r6
add r1, r0, r5
sl r1, r1, r2
add r5, r0, r1 ;LEFT_SHIFT

add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 4], r4 ;SET

movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

movi r4, [fp + 4] ;GET
movi r5, [fp + 20] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 48 ;GET
add r2, r0, r6
add r1, r0, r5
sub r1, r1, r2
add r5, r0, r1 ;SUB

addi r6, r0, 4 ;GET
add r2, r0, r6
add r1, r0, r5
sl r1, r1, r2
add r5, r0, r1 ;LEFT_SHIFT

add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 4], r4 ;SET

movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

movi r4, [fp + 4] ;GET
movi r5, [fp + 20] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 48 ;GET
add r2, r0, r6
add r1, r0, r5
sub r1, r1, r2
add r5, r0, r1 ;SUB

add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 4], r4 ;SET

movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

movi r4, [fp + 4] ;GET
add r1, r0, r4
addi sp, sp, 12
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 12
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_skip_space_old:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r5, r0, 0 ;GET
movi [fp + 0], r5 ;SET

34_start:
movi r5, [fp + 12] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 33 ;GET
sub r1, r5, r6
jc 34_true
jz 34_false
addi r5, r0, 1
jmp 34_end
34_true:
addi r5, r0, 0
jmp 34_end
34_end:
sub r5, r5, r0
jz 34_false
movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

jmp 34_start
34_false:

movi r4, [fp + 0] ;GET
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

_skip_non_space:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r5, r0, 0 ;GET
movi [fp + 0], r5 ;SET

35_start:
movi r5, [fp + 12] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 32 ;GET
sub r1, r6, r5
jc 35_true
jz 35_false
addi r5, r0, 1
jmp 35_end
35_true:
addi r5, r0, 0
jmp 35_end
35_end:
sub r5, r5, r0
jz 35_false
movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

jmp 35_start
35_false:

movi r4, [fp + 0] ;GET
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

_dump_command:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 44
add fp, r0, sp
addi r5, r0, string_11
lui r5, _string_hi_adrs ;GET_32
movi [fp + 0], r5 ;SET

addi r5, r0, string_12
lui r5, _string_hi_adrs ;GET_32
movi [fp + 4], r5 ;SET

addi r5, r0, string_13
lui r5, _string_hi_adrs ;GET_32
movi [fp + 8], r5 ;SET

addi r5, r0, string_14
lui r5, _string_hi_adrs ;GET_32
movi [fp + 12], r5 ;SET

addi r5, r0, 21568 ;GET_32
lui r5, 137 ;GET_32
movi [fp + 16], r5 ;SET

movi r4, [fp + 56] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 56], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 20], r4 ;SET

movi r4, [fp + 52] ;GET
movi r5, [fp + 56] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
mvbi [fp + 24], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 52] ;GET
movi r5, [fp + 56] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _get_int
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 20], r4 ;SET

movi r4, [fp + 56] ;GET
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [fp + 52] ;GET
movi r6, [fp + 56] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

movi [sp + 0], r5 ;SET
;CALL_PARAM_END
jal _skip_non_space
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 56], r4 ;SET

movi r4, [fp + 56] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 56], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 28], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 52] ;GET
movi r5, [fp + 56] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _get_int
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 28], r4 ;SET

movi r4, [fp + 20] ;GET
movi [fp + 32], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 36], r4 ;SET

36_start:
movi r4, [fp + 32] ;GET
movi r5, [fp + 20] ;GET
movi r6, [fp + 28] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

sub r1, r4, r5
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
movi r4, [fp + 36] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

addi r5, r0, 7 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 7 ;GET
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
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 32 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _print_char
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

37_false:

movi r4, [fp + 36] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

addi r5, r0, 15 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 15 ;GET
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

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 32] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_int_hex
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
addi r4, r0, 58 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _print_char
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
addi r4, r0, 32 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _print_char
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
addi r4, r0, 32 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _print_char
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

38_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 32] ;GET
mvbi r4, [r4 + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _print_hex_byte
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
addi r4, r0, 32 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _print_char
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

movi r4, [fp + 36] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 36], r4 ;SET

movi r4, [fp + 32] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi [fp + 32], r4 ;SET

movi r4, [fp + 32] ;GET
movi r5, [fp + 20] ;GET
sub r1, r5, r4
jc 39_true
jz 39_false
addi r4, r0, 1
jmp 39_end
39_true:
addi r4, r0, 0
jmp 39_end
39_end:
movi r5, [fp + 36] ;GET
addi r6, r0, 1 ;GET
add r2, r0, r6
add r1, r0, r5
sub r1, r1, r2
add r5, r0, r1 ;SUB

addi r6, r0, 15 ;GET
add r2, r0, r6
add r1, r0, r5
and r1, r1, r2
add r5, r0, r1 ;BITWISE_AND

addi r6, r0, 15 ;GET
sub r1, r5, r6
jz 40_true
addi r5, r0, 0
jmp 40_end
40_true:
addi r5, r0, 1
jmp 40_end
40_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 39_false
addi r4, r0, 0 ;GET
movi [fp + 36], r4 ;SET

41_start:
movi r4, [fp + 36] ;GET
addi r5, r0, 16 ;GET
sub r1, r4, r5
jc 41_true
jz 41_false
addi r4, r0, 1
jmp 41_end
41_true:
addi r4, r0, 0
jmp 41_end
41_end:
sub r4, r4, r0
jz 41_false
movi r4, [fp + 32] ;GET
movi r5, [fp + 36] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

addi r5, r0, 16 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

mvbi r4, [r4 + 0] ;GET
mvbi [fp + 40], r4 ;SET

mvbi r4, [fp + 40] ;/GET
addi r5, r0, 31 ;GET
sub r1, r5, r4
jc 42_true
jz 42_false
addi r4, r0, 1
jmp 42_end
42_true:
addi r4, r0, 0
jmp 42_end
42_end:
mvbi r5, [fp + 40] ;/GET
addi r6, r0, 127 ;GET
sub r1, r5, r6
jc 43_true
jz 43_false
addi r5, r0, 1
jmp 43_end
43_true:
addi r5, r0, 0
jmp 43_end
43_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 42_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 40] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_char
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

42_false:

mvbi r4, [fp + 40] ;/GET
addi r5, r0, 32 ;GET
sub r1, r4, r5
jc 44_true
jz 44_false
addi r4, r0, 1
jmp 44_end
44_true:
addi r4, r0, 0
jmp 44_end
44_end:
mvbi r5, [fp + 40] ;/GET
addi r6, r0, 126 ;GET
sub r1, r6, r5
jc 45_true
jz 45_false
addi r5, r0, 1
jmp 45_end
45_true:
addi r5, r0, 0
jmp 45_end
45_end:
add r2, r0, r5
add r1, r0, r4
or r1, r1, r2
add r4, r0, r1 ;LOGICAL_OR

sub r4, r4, r0
jz 44_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 46 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _print_char
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

44_false:

movi r4, [fp + 36] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 36], r4 ;SET

jmp 41_start
41_false:

39_false:

jmp 36_start
36_false:

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

addi sp, sp, 44
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_write_command:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 48
add fp, r0, sp
addi r4, r0, string_15
lui r4, _string_hi_adrs ;GET_32
movi [fp + 0], r4 ;SET

addi r4, r0, string_16
lui r4, _string_hi_adrs ;GET_32
movi [fp + 4], r4 ;SET

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

movi r4, [fp + 60] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 60], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 8], r4 ;SET

movi r4, [fp + 56] ;GET
movi r5, [fp + 60] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
mvbi [fp + 12], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 56] ;GET
movi r5, [fp + 60] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _get_int
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 8], r4 ;SET

movi r4, [fp + 8] ;GET
movi [fp + 16], r4 ;SET

movi r4, [fp + 16] ;GET
movi [fp + 20], r4 ;SET

addi r4, r0, 0 ;GET
mvbi [fp + 24], r4 ;SET

addi r4, r0, 1 ;GET
movi [fp + 28], r4 ;SET

addi r4, r0, 0 ;GET
mvbi [fp + 32], r4 ;SET

addi r4, r0, 0 ;GET
mvbi [fp + 36], r4 ;SET

addi r4, r0, 0 ;GET
mvbi [fp + 40], r4 ;SET

addi r4, r0, string_17
lui r4, _string_hi_adrs ;GET_32
movi [fp + 44], r4 ;SET

46_start:
movi r4, [fp + 28] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 46_true
addi r4, r0, 0
jmp 46_end
46_true:
addi r4, r0, 1
jmp 46_end
46_end:
sub r4, r4, r0
jz 46_false
movi r4, [fp + 16] ;GET
movi [fp + 20], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 20] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_int_hex
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
addi r4, r0, 58 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _print_char
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
addi r4, r0, 32 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _print_char
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

movi r4, [fp + 28] ;GET
addi r5, r0, 1 ;GET
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
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _get_char
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
mvbi [fp + 32], r4 ;SET

47_false:

mvbi r4, [fp + 32] ;/GET
addi r5, r0, 13 ;GET
sub r1, r4, r5
jz 48_true
addi r4, r0, 0
jmp 48_end
48_true:
addi r4, r0, 1
jmp 48_end
48_end:
sub r4, r4, r0
jz 48_false
addi r4, r0, 0 ;GET
movi [fp + 28], r4 ;SET

48_false:

movi r4, [fp + 28] ;GET
addi r5, r0, 1 ;GET
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
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 32] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_char
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
jal _get_char
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
mvbi [fp + 36], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 36] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_char
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

49_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _get_char
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
mvbi [fp + 40], r4 ;SET

mvbi r4, [fp + 40] ;/GET
addi r5, r0, 13 ;GET
sub r1, r4, r5
jz 50_true
addi r4, r0, 0
jmp 50_end
50_true:
addi r4, r0, 1
jmp 50_end
50_end:
sub r4, r4, r0
jz 50_false
addi r4, r0, 0 ;GET
movi [fp + 28], r4 ;SET

50_false:

movi r4, [fp + 28] ;GET
addi r5, r0, 1 ;GET
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
addi r4, r0, 0 ;GET
mvbi [fp + 24], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 32] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _get_hex_int
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
addi r5, r0, 4 ;GET
add r2, r0, r5
add r1, r0, r4
sl r1, r1, r2
add r4, r0, r1 ;LEFT_SHIFT

mvbi [fp + 24], r4 ;SET

mvbi r4, [fp + 24] ;/GET
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r5, [fp + 36] ;GET_MEMORY
mvbi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
jal _get_hex_int
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi [fp + 24], r4 ;SET

mvbi r4, [fp + 24] ;/GET
movi r5, [fp + 16] ;GET
mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 16] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi [fp + 16], r4 ;SET

51_false:

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

jmp 46_start
46_false:

addi sp, sp, 48
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_run_command:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
addi r4, r0, string_18
lui r4, _string_hi_adrs ;GET_32
movi [fp + 0], r4 ;SET

addi r4, r0, 0 ;GET_32
lui r4, 2 ;GET_32
movi [fp + 4], r4 ;SET

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

addi r1, r0, 0

lui r1, 2

jr r1

addi sp, sp, 8
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
52_start:

;for_condition
movi r3, [fp + 4] ;GET
movi r4, [fp + 20] ;GET
sub r1, r3, r4
jc 52_true
jz 52_false
addi r3, r0, 1
jmp 52_end
52_true:
addi r3, r0, 0
jmp 52_end
52_end:
sub r1, r1, r0
jz 52_false

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
jmp 52_start
52_false:

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

_divide:
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

53_start:
movi r5, [fp + 4] ;GET
addi r6, r0, 32768 ;GET
sub r1, r5, r6
jc 53_true
jz 53_false
addi r5, r0, 1
jmp 53_end
53_true:
addi r5, r0, 0
jmp 53_end
53_end:
sub r5, r5, r0
jz 53_false
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

jmp 53_start
53_false:

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

54_start:
movi r5, [fp + 4] ;GET
addi r6, r0, 32768 ;GET
sub r1, r5, r6
jc 54_true
jz 54_false
addi r5, r0, 1
jmp 54_end
54_true:
addi r5, r0, 0
jmp 54_end
54_end:
sub r5, r5, r0
jz 54_false
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

jmp 54_start
54_false:

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

_system_call:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp





movi [dp + system_call_func_number], r16

movi [dp + system_call_arg0], r17

movi [dp + system_call_arg1], r18

movi [dp + system_call_arg2], r19

movi [dp + system_call_arg3], r20

addi r5, r0, 21568 ;GET_32
lui r5, 137 ;GET_32
movi [fp + 0], r5 ;SET

addi r5, r0, 0 ;GET
movi [dp + system_call_return_value], r5 ;SET

movi r5, [dp + system_call_func_number] ;GET
addi r6, r0, 0 ;GET
sub r1, r5, r6
jz 55_true
addi r5, r0, 0
jmp 55_end
55_true:
addi r5, r0, 1
jmp 55_end
55_end:
sub r5, r5, r0
jz 55_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [dp + system_call_arg0] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END
jal _print_char
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

55_false:

movi r5, [dp + system_call_func_number] ;GET
addi r6, r0, 1 ;GET
sub r1, r5, r6
jz 56_true
addi r5, r0, 0
jmp 56_end
56_true:
addi r5, r0, 1
jmp 56_end
56_end:
sub r5, r5, r0
jz 56_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _get_char
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [dp + system_call_return_value], r4 ;SET

56_false:

movi r4, [dp + system_call_func_number] ;GET
addi r5, r0, 2 ;GET
sub r1, r4, r5
jz 57_true
addi r4, r0, 0
jmp 57_end
57_true:
addi r4, r0, 1
jmp 57_end
57_end:
sub r4, r4, r0
jz 57_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [dp + system_call_arg0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _printString
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

57_false:

movi r4, [dp + system_call_func_number] ;GET
addi r5, r0, 10 ;GET
sub r1, r4, r5
jz 58_true
addi r4, r0, 0
jmp 58_end
58_true:
addi r4, r0, 1
jmp 58_end
58_end:
sub r4, r4, r0
jz 58_false
addi r1, r0, _shell

jr r1

58_false:

movi r17, [dp + system_call_return_value]

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_setMountValues:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r4, r0, 256 ;GET_32
lui r4, 7 ;GET_32
movi [fp + 0], r4 ;SET

movi r4, [fp + 12] ;GET
movi r5, [fp + 0] ;GET
movi [r5 + 0], r4 ;SET

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_getMountValues:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 12
add fp, r0, sp
addi r4, r0, 256 ;GET_32
lui r4, 7 ;GET_32
movi [fp + 0], r4 ;SET

movi r4, [fp + 0] ;GET
movi r4, [r4 + 0] ;GET
movi [fp + 4], r4 ;SET

addi r4, r0, string_30
lui r4, _string_hi_adrs ;GET_32
movi [fp + 8], r4 ;SET

movi r4, [fp + 4] ;GET
addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 59_true
addi r4, r0, 0
jmp 59_end
59_true:
addi r4, r0, 1
jmp 59_end
59_end:
sub r4, r4, r0
jz 59_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 8] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
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
jal _exit
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

59_false:

movi r4, [fp + 4] ;GET
add r1, r0, r4
addi sp, sp, 12
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 12
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_getFileInstanceTable:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
addi r5, r0, 0 ;GET_32
lui r5, 7 ;GET_32
add r1, r0, r5
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

_mount_command:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 84
add fp, r0, sp
addi r6, r0, 256 ;GET_32
lui r6, 19 ;GET_32
movi [fp + 0], r6 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
jal _getDiskBufferBase
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r6, r0, r1 ;RETURN_SET
movi [fp + 4], r6 ;SET

movi r6, [fp + 4] ;GET
movi [fp + 8], r6 ;SET

addi r6, r0, string_31
lui r6, _string_hi_adrs ;GET_32
movi [fp + 12], r6 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r6 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r6, [fp + 12] ;GET_MEMORY
movi [sp + 0], r6 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r6, r0, r1 ;RETURN_SET

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
movi r6, [fp + 4] ;GET
movi [sp + 0], r6 ;SET
;CALL_PARAM_END_A
jal _diskRead
addi sp, sp, 8
movi r6, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r6, r0, r1 ;RETURN_SET







addi r6, r0, 512 ;GET
movi [fp + 40], r6 ;SET

movi r4, [fp + 8] ;GET
addi r5, r0, 13 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi [fp + 16], r4 ;SET

movi r4, [fp + 8] ;GET
addi r5, r0, 16 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi [fp + 20], r4 ;SET

movi r4, [fp + 8] ;GET
addi r5, r0, 17 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi r5, [fp + 8] ;GET
addi r6, r0, 18 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 8 ;GET
add r2, r0, r6
add r1, r0, r5
sl r1, r1, r2
add r5, r0, r1 ;LEFT_SHIFT

add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 24], r4 ;SET

movi r4, [fp + 8] ;GET
addi r5, r0, 22 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi r5, [fp + 8] ;GET
addi r6, r0, 23 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 8 ;GET
add r2, r0, r6
add r1, r0, r5
sl r1, r1, r2
add r5, r0, r1 ;LEFT_SHIFT

add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 28], r4 ;SET

movi r4, [fp + 8] ;GET
addi r5, r0, 14 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi r5, [fp + 8] ;GET
addi r6, r0, 15 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 8 ;GET
add r2, r0, r6
add r1, r0, r5
sl r1, r1, r2
add r5, r0, r1 ;LEFT_SHIFT

add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 32], r4 ;SET

movi r4, [fp + 8] ;GET
addi r5, r0, 17 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi r5, [fp + 8] ;GET
addi r6, r0, 18 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 8 ;GET
add r2, r0, r6
add r1, r0, r5
sl r1, r1, r2
add r5, r0, r1 ;LEFT_SHIFT

add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 36], r4 ;SET




movi r4, [fp + 32] ;GET
movi [fp + 44], r4 ;SET


movi r4, [fp + 28] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sl r1, r1, r2
add r4, r0, r1 ;LEFT_SHIFT

movi [fp + 56], r4 ;SET

movi r4, [fp + 44] ;GET
movi r5, [fp + 56] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 48], r4 ;SET


movi r4, [fp + 36] ;GET
addi r5, r0, 5 ;GET
add r2, r0, r5
add r1, r0, r4
sl r1, r1, r2
add r4, r0, r1 ;LEFT_SHIFT

movi r5, [fp + 40] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

addi r5, r0, 9 ;GET
add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

movi [fp + 60], r4 ;SET

movi r4, [fp + 48] ;GET
movi r5, [fp + 60] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 52], r4 ;SET

addi r4, r0, string_32
lui r4, _string_hi_adrs ;GET_32
movi [fp + 64], r4 ;SET

addi r4, r0, string_33
lui r4, _string_hi_adrs ;GET_32
movi [fp + 68], r4 ;SET

addi r4, r0, string_34
lui r4, _string_hi_adrs ;GET_32
movi [fp + 72], r4 ;SET

addi r4, r0, string_35
lui r4, _string_hi_adrs ;GET_32
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 64] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
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
movi r4, [fp + 44] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_bcd
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
jal _cr
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
movi r4, [fp + 68] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
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
movi r4, [fp + 48] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_bcd
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
jal _cr
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
movi r4, [fp + 72] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
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
movi r4, [fp + 52] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_bcd
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
jal _cr
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
movi r4, [fp + 76] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
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
movi r4, [fp + 16] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_bcd
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
jal _cr
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

movi r4, [fp + 44] ;GET
movi r5, [fp + 48] ;GET
addi r6, r0, 8 ;GET
add r2, r0, r6
add r1, r0, r5
sl r1, r1, r2
add r5, r0, r1 ;LEFT_SHIFT

add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi r5, [fp + 52] ;GET
addi r6, r0, 16 ;GET
add r2, r0, r6
add r1, r0, r5
sl r1, r1, r2
add r5, r0, r1 ;LEFT_SHIFT

add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 80], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 80] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _setMountValues
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

movi r5, [fp + 80] ;GET
add r1, r0, r5
addi sp, sp, 84
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 84
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_getDiskIOBase:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
addi r6, r0, 256 ;GET_32
lui r6, 19 ;GET_32
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

_getDiskBufferBase:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
addi r7, r0, 0 ;GET_32
lui r7, 8 ;GET_32
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

_dir_command:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 68
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
jal _getMountValues
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
movi [fp + 0], r8 ;SET

addi r8, r0, 256 ;GET_32
lui r8, 19 ;GET_32
movi [fp + 4], r8 ;SET

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
jal _getDiskBufferBase
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
movi [fp + 8], r8 ;SET

movi r8, [fp + 8] ;GET
movi [fp + 12], r8 ;SET

addi r8, r0, string_36
lui r8, _string_hi_adrs ;GET_32
movi [fp + 16], r8 ;SET




movi r4, [fp + 0] ;GET
addi r5, r0, 255 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

movi [fp + 20], r4 ;SET

movi r4, [fp + 0] ;GET
addi r5, r0, 8 ;GET
add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

addi r5, r0, 255 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

movi [fp + 24], r4 ;SET

movi r4, [fp + 0] ;GET
addi r5, r0, 16 ;GET
add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

addi r5, r0, 255 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

movi [fp + 28], r4 ;SET

movi r4, [fp + 0] ;GET
addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 60_true
addi r4, r0, 0
jmp 60_end
60_true:
addi r4, r0, 1
jmp 60_end
60_end:
sub r4, r4, r0
jz 60_false
addi r4, r0, string_37
lui r4, _string_hi_adrs ;GET_32
movi [fp + 32], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 32] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 0 ;GET
add r1, r0, r4
addi sp, sp, 68
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

60_false:

addi r5, r0, 0 ;GET
movi [fp + 36], r5 ;SET


;for_init
movi r3, [fp + 24] ;GET
movi [fp + 40], r3 ;SET
61_start:

;for_condition
movi r3, [fp + 40] ;GET
movi r4, [fp + 28] ;GET
sub r1, r3, r4
jc 61_true
jz 61_false
addi r3, r0, 1
jmp 61_end
61_true:
addi r3, r0, 0
jmp 61_end
61_end:
sub r1, r1, r0
jz 61_false

;for_body
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 40] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 8] ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _diskRead
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET


;for_init
addi r3, r0, 0 ;GET
movi [fp + 44], r3 ;SET
62_start:

;for_condition
movi r3, [fp + 44] ;GET
addi r4, r0, 512 ;GET
sub r1, r3, r4
jc 62_true
jz 62_false
addi r3, r0, 1
jmp 62_end
62_true:
addi r3, r0, 0
jmp 62_end
62_end:
sub r1, r1, r0
jz 62_false

;for_body
movi r4, [fp + 12] ;GET
movi r5, [fp + 44] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

addi r5, r0, 11 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi r4, [r4 + 0] ;GET
movi [fp + 48], r4 ;SET

movi r4, [fp + 12] ;GET
movi r5, [fp + 44] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi [fp + 52], r4 ;SET

movi r4, [fp + 48] ;GET
addi r5, r0, 15 ;GET
sub r1, r5, r4
jz 63_true
addi r4, r0, 1
jmp 63_end
63_true:
addi r4, r0, 0
jmp 63_end
63_end:
movi r5, [fp + 52] ;GET
addi r6, r0, 128 ;GET
sub r1, r5, r6
jc 64_true
jz 64_false
addi r5, r0, 1
jmp 64_end
64_true:
addi r5, r0, 0
jmp 64_end
64_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

movi r5, [fp + 52] ;GET
addi r6, r0, 0 ;GET
sub r1, r6, r5
jc 65_true
jz 65_false
addi r5, r0, 1
jmp 65_end
65_true:
addi r5, r0, 0
jmp 65_end
65_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 63_false
movi r4, [fp + 36] ;GET
addi r5, r0, 0 ;GET
sub r1, r5, r4
jc 66_true
jz 66_false
addi r4, r0, 1
jmp 66_end
66_true:
addi r4, r0, 0
jmp 66_end
66_end:
sub r4, r4, r0
jz 66_false
movi r4, [fp + 48] ;GET
addi r5, r0, 8 ;GET
sub r1, r5, r4
jz 67_true
addi r4, r0, 1
jmp 67_end
67_true:
addi r4, r0, 0
jmp 67_end
67_end:
sub r4, r4, r0
jz 67_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 32 ;GET
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
addi r4, r0, 58 ;GET
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
addi r4, r0, 32 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

67_false:

66_false:

movi r4, [fp + 48] ;GET
addi r5, r0, 16 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 16 ;GET
sub r1, r4, r5
jz 68_true
addi r4, r0, 0
jmp 68_end
68_true:
addi r4, r0, 1
jmp 68_end
68_end:
sub r4, r4, r0
jz 68_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 42 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _printChar
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

68_false:

movi r4, [fp + 48] ;GET
addi r5, r0, 8 ;GET
sub r1, r4, r5
jz 69_true
addi r4, r0, 0
jmp 69_end
69_true:
addi r4, r0, 1
jmp 69_end
69_end:
sub r4, r4, r0
jz 69_false
addi r4, r0, string_38
lui r4, _string_hi_adrs ;GET_32
movi [fp + 56], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

69_false:

movi r4, [fp + 48] ;GET
addi r5, r0, 8 ;GET
sub r1, r5, r4
jz 70_true
addi r4, r0, 1
jmp 70_end
70_true:
addi r4, r0, 0
jmp 70_end
70_end:
sub r4, r4, r0
jz 70_false
movi r4, [fp + 36] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 36], r4 ;SET

70_false:


;for_init
addi r3, r0, 0 ;GET
movi [fp + 60], r3 ;SET
71_start:

;for_condition
movi r3, [fp + 60] ;GET
addi r4, r0, 11 ;GET
sub r1, r3, r4
jc 71_true
jz 71_false
addi r3, r0, 1
jmp 71_end
71_true:
addi r3, r0, 0
jmp 71_end
71_end:
sub r1, r1, r0
jz 71_false

;for_body
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 12] ;GET
movi r5, [fp + 44] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi r5, [fp + 60] ;GET
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


;for_iter
movi r4, [fp + 60] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 60], r4 ;SET
jmp 71_start
71_false:

movi r4, [fp + 48] ;GET
addi r5, r0, 8 ;GET
sub r1, r4, r5
jz 72_true
addi r4, r0, 0
jmp 72_end
72_true:
addi r4, r0, 1
jmp 72_end
72_end:
sub r4, r4, r0
jz 72_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _cr
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

72_false:

63_false:


;for_iter
movi r4, [fp + 44] ;GET
addi r5, r0, 32 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 44], r4 ;SET
jmp 62_start
62_false:


;for_iter
movi r4, [fp + 40] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 40], r4 ;SET
jmp 61_start
61_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _cr
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, string_39
lui r4, _string_hi_adrs ;GET_32
movi [fp + 64], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
addi r4, r0, 9 ;GET
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
movi r4, [fp + 36] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_bcd
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
movi r4, [fp + 64] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
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
jal _cr
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 0 ;GET
add r1, r0, r4
addi sp, sp, 68
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 68
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_searchfile_command:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 12
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [fp + 20] ;GET
movi r6, [fp + 24] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

movi [sp + 0], r5 ;SET
;CALL_PARAM_END
jal _searchFile
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET
movi [fp + 0], r5 ;SET

movi r5, [fp + 0] ;GET
addi r6, r0, 9 ;GET
add r2, r0, r6
add r1, r0, r5
sr r1, r1, r2
add r5, r0, r1 ;RIGHT_SHIFT

movi [fp + 4], r5 ;SET

movi r5, [fp + 0] ;GET
addi r6, r0, 511 ;GET
add r2, r0, r6
add r1, r0, r5
and r1, r1, r2
add r5, r0, r1 ;BITWISE_AND

movi [fp + 8], r5 ;SET

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
jal _print_hex
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
subi sp, sp, 4
movi r5, [fp + 8] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
jal _print_hex
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

addi sp, sp, 12
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_getDirectoryStart:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
movi r5, [fp + 8] ;GET
addi r6, r0, 8 ;GET
add r2, r0, r6
add r1, r0, r5
sr r1, r1, r2
add r5, r0, r1 ;RIGHT_SHIFT

addi r6, r0, 255 ;GET
add r2, r0, r6
add r1, r0, r5
and r1, r1, r2
add r5, r0, r1 ;BITWISE_AND

add r1, r0, r5
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

_getDataStart:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
movi r6, [fp + 8] ;GET
addi r7, r0, 16 ;GET
add r2, r0, r7
add r1, r0, r6
sr r1, r1, r2
add r6, r0, r1 ;RIGHT_SHIFT

addi r7, r0, 255 ;GET
add r2, r0, r7
add r1, r0, r6
and r1, r1, r2
add r6, r0, r1 ;BITWISE_AND

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

_getFATStart:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
movi r7, [fp + 8] ;GET
addi r8, r0, 255 ;GET
add r2, r0, r8
add r1, r0, r7
and r1, r1, r2
add r7, r0, r1 ;BITWISE_AND

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

_makeUppercase:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r8, r0, 0 ;GET
movi [fp + 0], r8 ;SET

73_start:
movi r8, [fp + 0] ;GET
addi r9, r0, 256 ;GET
sub r1, r8, r9
jc 73_true
jz 73_false
addi r8, r0, 1
jmp 73_end
73_true:
addi r8, r0, 0
jmp 73_end
73_end:
movi r9, [fp + 12] ;GET
movi r10, [fp + 0] ;GET
add r2, r0, r10
add r1, r0, r9
add r1, r1, r2
add r9, r0, r1 ;ADD_POINTER

mvbi r9, [r9 + 0] ;GET
addi r10, r0, 0 ;GET
sub r1, r10, r9
jz 74_true
addi r9, r0, 1
jmp 74_end
74_true:
addi r9, r0, 0
jmp 74_end
74_end:
add r2, r0, r9
add r1, r0, r8
and r1, r1, r2
add r8, r0, r1 ;LOGICAL_AND

sub r8, r8, r0
jz 73_false
movi r8, [fp + 12] ;GET
movi r9, [fp + 0] ;GET
add r2, r0, r9
add r1, r0, r8
add r1, r1, r2
add r8, r0, r1 ;ADD_POINTER

mvbi r8, [r8 + 0] ;GET
addi r9, r0, 96 ;GET
sub r1, r9, r8
jc 75_true
jz 75_false
addi r8, r0, 1
jmp 75_end
75_true:
addi r8, r0, 0
jmp 75_end
75_end:
movi r9, [fp + 12] ;GET
movi r10, [fp + 0] ;GET
add r2, r0, r10
add r1, r0, r9
add r1, r1, r2
add r9, r0, r1 ;ADD_POINTER

mvbi r9, [r9 + 0] ;GET
addi r10, r0, 123 ;GET
sub r1, r9, r10
jc 76_true
jz 76_false
addi r9, r0, 1
jmp 76_end
76_true:
addi r9, r0, 0
jmp 76_end
76_end:
add r2, r0, r9
add r1, r0, r8
and r1, r1, r2
add r8, r0, r1 ;LOGICAL_AND

sub r8, r8, r0
jz 75_false
movi r4, [fp + 12] ;GET
movi r5, [fp + 0] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
addi r5, r0, 32 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi r5, [fp + 12] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET

75_false:

movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

jmp 73_start
73_false:

addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_searchFile:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 60
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _getMountValues
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
movi r4, [fp + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _getDirectoryStart
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 4], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _getDataStart
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 8], r4 ;SET

addi r4, r0, string_40
lui r4, _string_hi_adrs ;GET_32
movi [fp + 12], r4 ;SET

addi r4, r0, string_41
lui r4, _string_hi_adrs ;GET_32
movi [fp + 16], r4 ;SET

addi r4, r0, string_42
lui r4, _string_hi_adrs ;GET_32
movi [fp + 20], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 68] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _makeUppercase
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 0 ;GET
movi [fp + 24], r4 ;SET


;for_init
addi r4, r0, 0 ;GET
movi [fp + 24], r4 ;SET
77_start:

;for_condition
movi r4, [fp + 24] ;GET
addi r5, r0, 8 ;GET
sub r1, r4, r5
jc 77_true
jz 77_false
addi r4, r0, 1
jmp 77_end
77_true:
addi r4, r0, 0
jmp 77_end
77_end:
sub r1, r1, r0
jz 77_false

;for_body
addi r4, r0, 32 ;GET
movi r5, [fp + 12] ;GET
movi r6, [fp + 24] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET


;for_iter
movi r4, [fp + 24] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 24], r4 ;SET
jmp 77_start
77_false:


;for_init
addi r4, r0, 0 ;GET
movi [fp + 24], r4 ;SET
78_start:

;for_condition
movi r4, [fp + 24] ;GET
addi r5, r0, 3 ;GET
sub r1, r4, r5
jc 78_true
jz 78_false
addi r4, r0, 1
jmp 78_end
78_true:
addi r4, r0, 0
jmp 78_end
78_end:
sub r1, r1, r0
jz 78_false

;for_body
addi r4, r0, 32 ;GET
movi r5, [fp + 16] ;GET
movi r6, [fp + 24] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET


;for_iter
movi r4, [fp + 24] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 24], r4 ;SET
jmp 78_start
78_false:

addi r4, r0, 0 ;GET
movi [fp + 24], r4 ;SET

79_start:
movi r4, [fp + 24] ;GET
addi r5, r0, 8 ;GET
sub r1, r4, r5
jc 79_true
jz 79_false
addi r4, r0, 1
jmp 79_end
79_true:
addi r4, r0, 0
jmp 79_end
79_end:
movi r5, [fp + 68] ;GET
movi r6, [fp + 24] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 46 ;GET
sub r1, r6, r5
jz 80_true
addi r5, r0, 1
jmp 80_end
80_true:
addi r5, r0, 0
jmp 80_end
80_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

movi r5, [fp + 68] ;GET
movi r6, [fp + 24] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 0 ;GET
sub r1, r6, r5
jc 81_true
jz 81_false
addi r5, r0, 1
jmp 81_end
81_true:
addi r5, r0, 0
jmp 81_end
81_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 79_false
movi r4, [fp + 68] ;GET
movi r5, [fp + 24] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi r5, [fp + 12] ;GET
movi r6, [fp + 24] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 24] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 24], r4 ;SET

jmp 79_start
79_false:

movi r4, [fp + 24] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 24], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 28], r4 ;SET

82_start:
movi r4, [fp + 24] ;GET
addi r5, r0, 11 ;GET
sub r1, r4, r5
jc 82_true
jz 82_false
addi r4, r0, 1
jmp 82_end
82_true:
addi r4, r0, 0
jmp 82_end
82_end:
movi r5, [fp + 68] ;GET
movi r6, [fp + 24] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 0 ;GET
sub r1, r6, r5
jz 83_true
addi r5, r0, 1
jmp 83_end
83_true:
addi r5, r0, 0
jmp 83_end
83_end:
movi r6, [fp + 68] ;GET
movi r7, [fp + 24] ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi r6, [r6 + 0] ;GET
addi r7, r0, 32 ;GET
sub r1, r7, r6
jz 84_true
addi r6, r0, 1
jmp 84_end
84_true:
addi r6, r0, 0
jmp 84_end
84_end:
add r2, r0, r6
add r1, r0, r5
or r1, r1, r2
add r5, r0, r1 ;LOGICAL_OR

add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

movi r5, [fp + 68] ;GET
movi r6, [fp + 24] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 0 ;GET
sub r1, r6, r5
jc 85_true
jz 85_false
addi r5, r0, 1
jmp 85_end
85_true:
addi r5, r0, 0
jmp 85_end
85_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 82_false
movi r4, [fp + 68] ;GET
movi r5, [fp + 24] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi r5, [fp + 16] ;GET
movi r6, [fp + 28] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 24] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 24], r4 ;SET

movi r4, [fp + 28] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 28], r4 ;SET

jmp 82_start
82_false:


;for_init
addi r4, r0, 0 ;GET
movi [fp + 24], r4 ;SET
86_start:

;for_condition
movi r4, [fp + 24] ;GET
addi r5, r0, 8 ;GET
sub r1, r4, r5
jc 86_true
jz 86_false
addi r4, r0, 1
jmp 86_end
86_true:
addi r4, r0, 0
jmp 86_end
86_end:
sub r1, r1, r0
jz 86_false

;for_body
movi r4, [fp + 12] ;GET
movi r5, [fp + 24] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi r5, [fp + 20] ;GET
movi r6, [fp + 24] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET


;for_iter
movi r4, [fp + 24] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 24], r4 ;SET
jmp 86_start
86_false:

movi r4, [fp + 24] ;GET
movi [fp + 28], r4 ;SET


;for_init
addi r4, r0, 0 ;GET
movi [fp + 24], r4 ;SET
87_start:

;for_condition
movi r4, [fp + 24] ;GET
addi r5, r0, 3 ;GET
sub r1, r4, r5
jc 87_true
jz 87_false
addi r4, r0, 1
jmp 87_end
87_true:
addi r4, r0, 0
jmp 87_end
87_end:
sub r1, r1, r0
jz 87_false

;for_body
movi r4, [fp + 16] ;GET
movi r5, [fp + 24] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi r5, [fp + 20] ;GET
movi r6, [fp + 28] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 28] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 28], r4 ;SET


;for_iter
movi r4, [fp + 24] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 24], r4 ;SET
jmp 87_start
87_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _getDiskBufferBase
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 32], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 36], r4 ;SET

addi r4, r0, 11 ;GET
movi [fp + 40], r4 ;SET


;for_init
movi r3, [fp + 4] ;GET
movi [fp + 44], r3 ;SET
88_start:

;for_condition
movi r3, [fp + 44] ;GET
movi r4, [fp + 8] ;GET
sub r1, r3, r4
jc 88_true
jz 88_false
addi r3, r0, 1
jmp 88_end
88_true:
addi r3, r0, 0
jmp 88_end
88_end:
sub r1, r1, r0
jz 88_false

;for_body
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 44] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 32] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _diskRead
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET


;for_init
addi r4, r0, 0 ;GET
movi [fp + 24], r4 ;SET
89_start:

;for_condition
movi r4, [fp + 24] ;GET
addi r5, r0, 512 ;GET
sub r1, r4, r5
jc 89_true
jz 89_false
addi r4, r0, 1
jmp 89_end
89_true:
addi r4, r0, 0
jmp 89_end
89_end:
sub r1, r1, r0
jz 89_false

;for_body
movi r4, [fp + 32] ;GET
movi r5, [fp + 24] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

addi r5, r0, 11 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

mvbi r4, [r4 + 0] ;GET
movi [fp + 48], r4 ;SET

movi r4, [fp + 32] ;GET
movi r5, [fp + 24] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi [fp + 52], r4 ;SET

movi r4, [fp + 48] ;GET
addi r5, r0, 15 ;GET
sub r1, r5, r4
jz 90_true
addi r4, r0, 1
jmp 90_end
90_true:
addi r4, r0, 0
jmp 90_end
90_end:
movi r5, [fp + 52] ;GET
addi r6, r0, 128 ;GET
sub r1, r5, r6
jc 91_true
jz 91_false
addi r5, r0, 1
jmp 91_end
91_true:
addi r5, r0, 0
jmp 91_end
91_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

movi r5, [fp + 52] ;GET
addi r6, r0, 0 ;GET
sub r1, r6, r5
jc 92_true
jz 92_false
addi r5, r0, 1
jmp 92_end
92_true:
addi r5, r0, 0
jmp 92_end
92_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 90_false
movi r4, [fp + 36] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 36], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 40] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 20] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 32] ;GET
movi r5, [fp + 24] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _compare_fixed_string
addi sp, sp, 12
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 56], r4 ;SET

movi r4, [fp + 56] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 93_true
addi r4, r0, 0
jmp 93_end
93_true:
addi r4, r0, 1
jmp 93_end
93_end:
sub r4, r4, r0
jz 93_false
movi r4, [fp + 44] ;GET
addi r5, r0, 9 ;GET
add r2, r0, r5
add r1, r0, r4
sl r1, r1, r2
add r4, r0, r1 ;LEFT_SHIFT

movi r5, [fp + 24] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

add r1, r0, r4
addi sp, sp, 60
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

93_false:

90_false:


;for_iter
movi r4, [fp + 24] ;GET
addi r5, r0, 32 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 24], r4 ;SET
jmp 89_start
89_false:


;for_iter
movi r4, [fp + 44] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 44], r4 ;SET
jmp 88_start
88_false:

addi r4, r0, 0 ;GET_32
lui r4, 1 ;GET_32
add r1, r0, r4
addi sp, sp, 60
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 60
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_openFile:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 52
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
jal _getFileInstanceTable
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET
movi [fp + 0], r5 ;SET

movi r5, [fp + 0] ;GET
movi [fp + 4], r5 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
jal _getMountValues
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET
movi [fp + 8], r5 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [fp + 8] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
jal _getDirectoryStart
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET
movi [fp + 12], r5 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [fp + 8] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
jal _getFATStart
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET
movi [fp + 16], r5 ;SET


subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 60] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _searchFile
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 20], r4 ;SET

movi r4, [fp + 20] ;GET
addi r5, r0, 0 ;GET_32
lui r5, 1 ;GET_32
sub r1, r4, r5
jz 94_true
addi r4, r0, 0
jmp 94_end
94_true:
addi r4, r0, 1
jmp 94_end
94_end:
sub r4, r4, r0
jz 94_false
addi r4, r0, 255 ;GET
add r1, r0, r4
addi sp, sp, 52
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

94_false:

movi r5, [fp + 20] ;GET
addi r6, r0, 9 ;GET
add r2, r0, r6
add r1, r0, r5
sr r1, r1, r2
add r5, r0, r1 ;RIGHT_SHIFT

movi [fp + 24], r5 ;SET

movi r5, [fp + 20] ;GET
addi r6, r0, 511 ;GET
add r2, r0, r6
add r1, r0, r5
and r1, r1, r2
add r5, r0, r1 ;BITWISE_AND

movi [fp + 28], r5 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
jal _getDiskBufferBase
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET
movi [fp + 32], r5 ;SET

movi r5, [fp + 32] ;GET
movi r6, [fp + 28] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

movi [fp + 36], r5 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [fp + 24] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r5, [fp + 32] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
jal _diskRead
addi sp, sp, 8
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

movi r5, [fp + 36] ;GET
addi r6, r0, 26 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
movi r6, [fp + 36] ;GET
addi r7, r0, 27 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi r6, [r6 + 0] ;GET
addi r7, r0, 8 ;GET
add r2, r0, r7
add r1, r0, r6
sl r1, r1, r2
add r6, r0, r1 ;LEFT_SHIFT

add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

movi [fp + 40], r5 ;SET

movi r5, [fp + 36] ;GET
addi r6, r0, 28 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
movi r6, [fp + 36] ;GET
addi r7, r0, 29 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi r6, [r6 + 0] ;GET
addi r7, r0, 8 ;GET
add r2, r0, r7
add r1, r0, r6
sl r1, r1, r2
add r6, r0, r1 ;LEFT_SHIFT

add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

movi r6, [fp + 36] ;GET
addi r7, r0, 30 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi r6, [r6 + 0] ;GET
addi r7, r0, 16 ;GET
add r2, r0, r7
add r1, r0, r6
sl r1, r1, r2
add r6, r0, r1 ;LEFT_SHIFT

add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

movi r6, [fp + 36] ;GET
addi r7, r0, 31 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi r6, [r6 + 0] ;GET
addi r7, r0, 24 ;GET
add r2, r0, r7
add r1, r0, r6
sl r1, r1, r2
add r6, r0, r1 ;LEFT_SHIFT

add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

movi [fp + 44], r5 ;SET

addi r5, r0, 0 ;GET
movi [fp + 48], r5 ;SET

95_start:
movi r5, [fp + 48] ;GET
addi r6, r0, 256 ;GET
sub r1, r5, r6
jc 95_true
jz 95_false
addi r5, r0, 1
jmp 95_end
95_true:
addi r5, r0, 0
jmp 95_end
95_end:
movi r6, [fp + 0] ;GET
movi r7, [fp + 48] ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

addi r7, r0, 10 ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD

mvbi r6, [r6 + 0] ;GET
addi r7, r0, 0 ;GET
sub r1, r7, r6
jz 96_true
addi r6, r0, 1
jmp 96_end
96_true:
addi r6, r0, 0
jmp 96_end
96_end:
add r2, r0, r6
add r1, r0, r5
and r1, r1, r2
add r5, r0, r1 ;LOGICAL_AND

sub r5, r5, r0
jz 95_false
movi r4, [fp + 48] ;GET
addi r5, r0, 16 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 48], r4 ;SET

jmp 95_start
95_false:

movi r4, [fp + 48] ;GET
addi r5, r0, 256 ;GET
sub r1, r4, r5
jz 97_true
addi r4, r0, 0
jmp 97_end
97_true:
addi r4, r0, 1
jmp 97_end
97_end:
sub r4, r4, r0
jz 97_false
addi r4, r0, 256 ;GET
add r1, r0, r4
addi sp, sp, 52
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

97_false:

movi r4, [fp + 44] ;GET
addi r5, r0, 255 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

movi r5, [fp + 0] ;GET
movi r6, [fp + 48] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 0 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 44] ;GET
addi r5, r0, 8 ;GET
add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

addi r5, r0, 255 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

movi r5, [fp + 0] ;GET
movi r6, [fp + 48] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 1 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 44] ;GET
addi r5, r0, 16 ;GET
add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

addi r5, r0, 255 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

movi r5, [fp + 0] ;GET
movi r6, [fp + 48] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 2 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 44] ;GET
addi r5, r0, 24 ;GET
add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

addi r5, r0, 255 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

movi r5, [fp + 0] ;GET
movi r6, [fp + 48] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 3 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

addi r4, r0, 0 ;GET
movi r5, [fp + 0] ;GET
movi r6, [fp + 48] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 4 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

addi r4, r0, 0 ;GET
movi r5, [fp + 0] ;GET
movi r6, [fp + 48] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 5 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

addi r4, r0, 0 ;GET
movi r5, [fp + 0] ;GET
movi r6, [fp + 48] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 6 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

addi r4, r0, 0 ;GET
movi r5, [fp + 0] ;GET
movi r6, [fp + 48] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 7 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 40] ;GET
addi r5, r0, 255 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

movi r5, [fp + 0] ;GET
movi r6, [fp + 48] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 8 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 40] ;GET
addi r5, r0, 8 ;GET
add r2, r0, r5
add r1, r0, r4
sr r1, r1, r2
add r4, r0, r1 ;RIGHT_SHIFT

addi r5, r0, 255 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

movi r5, [fp + 0] ;GET
movi r6, [fp + 48] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 9 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

addi r4, r0, 1 ;GET
movi r5, [fp + 0] ;GET
movi r6, [fp + 48] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

addi r6, r0, 10 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET

movi r4, [fp + 48] ;GET
add r1, r0, r4
addi sp, sp, 52
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 52
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_closeFile:
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
jal _getFileInstanceTable
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET
movi [fp + 0], r5 ;SET


;for_init
addi r3, r0, 0 ;GET
movi [fp + 4], r3 ;SET
98_start:

;for_condition
movi r3, [fp + 4] ;GET
addi r4, r0, 16 ;GET
sub r1, r3, r4
jc 98_true
jz 98_false
addi r3, r0, 1
jmp 98_end
98_true:
addi r3, r0, 0
jmp 98_end
98_end:
sub r1, r1, r0
jz 98_false

;for_body
addi r4, r0, 0 ;GET
movi r5, [fp + 0] ;GET
movi r6, [fp + 16] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

movi r6, [fp + 4] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

mvbi [r5 + 0], r4 ;SET


;for_iter
movi r4, [fp + 4] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 4], r4 ;SET
jmp 98_start
98_false:

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_readFile:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_writeFile:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_open_command:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 12] ;GET
movi r5, [fp + 16] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _openFile
addi sp, sp, 4
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
movi r4, [fp + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
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
jal _cr
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

_close_command:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 12] ;GET
movi r5, [fp + 16] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi [sp + 0], r4 ;SET
;CALL_PARAM_END
jal _get_int
addi sp, sp, 4
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
movi r4, [fp + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _closeFile
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

_filerd_command:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_filewr_command:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_skip_space:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
movi r5, [fp + 16] ;GET
movi [fp + 0], r5 ;SET

99_start:
movi r5, [fp + 0] ;GET
addi r6, r0, 256 ;GET
sub r1, r5, r6
jc 99_true
jz 99_false
addi r5, r0, 1
jmp 99_end
99_true:
addi r5, r0, 0
jmp 99_end
99_end:
movi r6, [fp + 12] ;GET
movi r7, [fp + 0] ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi r6, [r6 + 0] ;GET
addi r7, r0, 32 ;GET
sub r1, r6, r7
jz 100_true
addi r6, r0, 0
jmp 100_end
100_true:
addi r6, r0, 1
jmp 100_end
100_end:
add r2, r0, r6
add r1, r0, r5
and r1, r1, r2
add r5, r0, r1 ;LOGICAL_AND

sub r5, r5, r0
jz 99_false
movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

jmp 99_start
99_false:

movi r4, [fp + 0] ;GET
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

_reset:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 8
add fp, r0, sp
addi r5, r0, 0 ;GET_32
lui r5, 7 ;GET_32
movi [fp + 0], r5 ;SET


;for_init
addi r3, r0, 0 ;GET
movi [fp + 4], r3 ;SET
101_start:

;for_condition
movi r3, [fp + 4] ;GET
addi r4, r0, 0 ;GET_32
lui r4, 1 ;GET_32
sub r1, r3, r4
jc 101_true
jz 101_false
addi r3, r0, 1
jmp 101_end
101_true:
addi r3, r0, 0
jmp 101_end
101_end:
sub r1, r1, r0
jz 101_false

;for_body
addi r4, r0, 0 ;GET
movi r5, [fp + 0] ;GET
movi r6, [fp + 4] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET


;for_iter
movi r4, [fp + 4] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 4], r4 ;SET
jmp 101_start
101_false:

addi sp, sp, 8
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_shell:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 100
add fp, r0, sp
addi r4, r0, string_43
lui r4, _string_hi_adrs ;GET_32
movi [fp + 0], r4 ;SET

addi r4, r0, string_44
lui r4, _string_hi_adrs ;GET_32
movi [fp + 4], r4 ;SET

addi r4, r0, string_45
lui r4, _string_hi_adrs ;GET_32
movi [fp + 8], r4 ;SET

addi r4, r0, string_46
lui r4, _string_hi_adrs ;GET_32
movi [fp + 12], r4 ;SET

addi r4, r0, string_47
lui r4, _string_hi_adrs ;GET_32
movi [fp + 16], r4 ;SET

addi r4, r0, string_48
lui r4, _string_hi_adrs ;GET_32
movi [fp + 20], r4 ;SET

addi r4, r0, string_49
lui r4, _string_hi_adrs ;GET_32
movi [fp + 24], r4 ;SET

addi r4, r0, string_50
lui r4, _string_hi_adrs ;GET_32
movi [fp + 28], r4 ;SET

addi r4, r0, string_51
lui r4, _string_hi_adrs ;GET_32
movi [fp + 32], r4 ;SET

addi r4, r0, string_52
lui r4, _string_hi_adrs ;GET_32
movi [fp + 36], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 40], r4 ;SET

addi r4, r0, string_53
lui r4, _string_hi_adrs ;GET_32
movi [fp + 44], r4 ;SET

addi r4, r0, string_54
lui r4, _string_hi_adrs ;GET_32
movi [fp + 48], r4 ;SET

addi r4, r0, string_55
lui r4, _string_hi_adrs ;GET_32
movi [fp + 52], r4 ;SET

addi r4, r0, 6784 ;GET_32
lui r4, 6 ;GET_32
movi [fp + 56], r4 ;SET

addi r4, r0, string_56
lui r4, _string_hi_adrs ;GET_32
movi [fp + 60], r4 ;SET

addi r4, r0, 32 ;GET
mvbi [fp + 64], r4 ;SET

addi r4, r0, 8 ;GET
mvbi [fp + 68], r4 ;SET

addi r4, r0, 256 ;GET
movi [fp + 72], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 76], r4 ;SET

addi r4, r0, 1 ;GET
movi [fp + 80], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _reset_shell
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

102_start:
movi r4, [fp + 80] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 102_true
addi r4, r0, 0
jmp 102_end
102_true:
addi r4, r0, 1
jmp 102_end
102_end:
sub r4, r4, r0
jz 102_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _get_char
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
mvbi [fp + 84], r4 ;SET

mvbi r4, [fp + 84] ;/GET
addi r5, r0, 31 ;GET
sub r1, r5, r4
jc 103_true
jz 103_false
addi r4, r0, 1
jmp 103_end
103_true:
addi r4, r0, 0
jmp 103_end
103_end:
sub r4, r4, r0
jz 103_false
mvbi r4, [fp + 84] ;/GET
movi r5, [fp + 56] ;GET
movi r6, [fp + 76] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 84] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_char
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

movi r4, [fp + 76] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 76], r4 ;SET

103_false:

movi r4, [fp + 76] ;GET
addi r5, r0, 255 ;GET
sub r1, r5, r4
jc 104_true
jz 104_false
addi r4, r0, 1
jmp 104_end
104_true:
addi r4, r0, 0
jmp 104_end
104_end:
sub r4, r4, r0
jz 104_false
addi r4, r0, 0 ;GET
movi [fp + 76], r4 ;SET

104_false:

mvbi r4, [fp + 84] ;/GET
addi r5, r0, 8 ;GET
sub r1, r4, r5
jz 105_true
addi r4, r0, 0
jmp 105_end
105_true:
addi r4, r0, 1
jmp 105_end
105_end:
sub r4, r4, r0
jz 105_false
movi r4, [fp + 76] ;GET
addi r5, r0, 0 ;GET
sub r1, r5, r4
jc 106_true
jz 106_false
addi r4, r0, 1
jmp 106_end
106_true:
addi r4, r0, 0
jmp 106_end
106_end:
sub r4, r4, r0
jz 106_false
movi r4, [fp + 76] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 76], r4 ;SET

addi r4, r0, 0 ;GET
movi r5, [fp + 56] ;GET
movi r6, [fp + 76] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi [r5 + 0], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
mvbi r4, [fp + 68] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_char
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
mvbi r4, [fp + 64] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_char
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
mvbi r4, [fp + 68] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_char
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

106_false:

105_false:

mvbi r4, [fp + 84] ;/GET
addi r5, r0, 13 ;GET
sub r1, r4, r5
jz 107_true
addi r4, r0, 0
jmp 107_end
107_true:
addi r4, r0, 1
jmp 107_end
107_end:
sub r4, r4, r0
jz 107_false
addi r4, r0, 0 ;GET
movi [fp + 88], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 92], r4 ;SET

addi r4, r0, 6784 ;GET_32
lui r4, 6 ;GET_32
movi [fp + 56], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 60] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

movi r4, [fp + 76] ;GET
addi r5, r0, 0 ;GET
sub r1, r5, r4
jc 108_true
jz 108_false
addi r4, r0, 1
jmp 108_end
108_true:
addi r4, r0, 0
jmp 108_end
108_end:
sub r4, r4, r0
jz 108_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 88], r4 ;SET

movi r4, [fp + 88] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 109_true
addi r4, r0, 0
jmp 109_end
109_true:
addi r4, r0, 1
jmp 109_end
109_end:
sub r4, r4, r0
jz 109_false
addi r4, r0, 4 ;GET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 76] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _dump_command
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 1 ;GET
movi [fp + 92], r4 ;SET

109_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 4] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 88], r4 ;SET

movi r4, [fp + 88] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 110_true
addi r4, r0, 0
jmp 110_end
110_true:
addi r4, r0, 1
jmp 110_end
110_end:
sub r4, r4, r0
jz 110_false
addi r4, r0, 5 ;GET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 76] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _write_command
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 1 ;GET
movi [fp + 92], r4 ;SET

110_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 8] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 88], r4 ;SET

movi r4, [fp + 88] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 111_true
addi r4, r0, 0
jmp 111_end
111_true:
addi r4, r0, 1
jmp 111_end
111_end:
sub r4, r4, r0
jz 111_false
addi r4, r0, 3 ;GET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _run_command
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 1 ;GET
movi [fp + 92], r4 ;SET

111_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 12] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 88], r4 ;SET

movi r4, [fp + 88] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 112_true
addi r4, r0, 0
jmp 112_end
112_true:
addi r4, r0, 1
jmp 112_end
112_end:
sub r4, r4, r0
jz 112_false
addi r4, r0, 3 ;GET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _mount_command
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 1 ;GET
movi [fp + 92], r4 ;SET

112_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 16] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 88], r4 ;SET

movi r4, [fp + 88] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 113_true
addi r4, r0, 0
jmp 113_end
113_true:
addi r4, r0, 1
jmp 113_end
113_end:
sub r4, r4, r0
jz 113_false
addi r4, r0, 3 ;GET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _dir_command
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 1 ;GET
movi [fp + 92], r4 ;SET

113_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 20] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 88], r4 ;SET

movi r4, [fp + 88] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 114_true
addi r4, r0, 0
jmp 114_end
114_true:
addi r4, r0, 1
jmp 114_end
114_end:
sub r4, r4, r0
jz 114_false
addi r4, r0, 4 ;GET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 76] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _skip_space
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 76] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _open_command
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 1 ;GET
movi [fp + 92], r4 ;SET

114_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 24] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 88], r4 ;SET

movi r4, [fp + 88] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 115_true
addi r4, r0, 0
jmp 115_end
115_true:
addi r4, r0, 1
jmp 115_end
115_end:
sub r4, r4, r0
jz 115_false
addi r4, r0, 5 ;GET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 76] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _skip_space
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 76] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _close_command
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 1 ;GET
movi [fp + 92], r4 ;SET

115_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 28] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 88], r4 ;SET

movi r4, [fp + 88] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 116_true
addi r4, r0, 0
jmp 116_end
116_true:
addi r4, r0, 1
jmp 116_end
116_end:
sub r4, r4, r0
jz 116_false
addi r4, r0, 6 ;GET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 76] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _skip_space
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _filerd_command
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 1 ;GET
movi [fp + 92], r4 ;SET

116_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 36] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 88], r4 ;SET

movi r4, [fp + 88] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 117_true
addi r4, r0, 0
jmp 117_end
117_true:
addi r4, r0, 1
jmp 117_end
117_end:
sub r4, r4, r0
jz 117_false
addi r4, r0, 6 ;GET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 76] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _skip_space
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 76] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _searchfile_command
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 1 ;GET
movi [fp + 92], r4 ;SET

117_false:

movi r4, [fp + 92] ;GET
addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 118_true
addi r4, r0, 0
jmp 118_end
118_true:
addi r4, r0, 1
jmp 118_end
118_end:
sub r4, r4, r0
jz 118_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 48] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

118_false:

108_false:

addi r4, r0, 0 ;GET
movi [fp + 76], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _reset_shell
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

107_false:

jmp 102_start
102_false:

addi r4, r0, string_57
lui r4, _string_hi_adrs ;GET_32
movi [fp + 96], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 96] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi sp, sp, 100
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_main:
subi sp, sp, 4
add fp, r0, sp
addi sys, r0, _system_call

addi r4, r0, string_59
lui r4, _string_hi_adrs ;GET_32
movi [fp + 0], r4 ;SET

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

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _reset
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
jal _shell
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

halt

.asciiz string_0 = "DiskRead test\n"
.asciiz string_1 = "DiskWrite test\n"
.word syscall_execute_sfunc = 0
.word syscall_execute_sarg0 = 0
.word syscall_execute_sarg1 = 0
.word syscall_execute_sarg2 = 0
.word syscall_execute_sarg3 = 0
.word syscall_execute_return_value = 0
.asciiz string_9 = "0123456789       :;<=>?"
.asciiz string_10 = ">"
.asciiz string_11 = "\n"
.asciiz string_12 = " "
.asciiz string_13 = "dump command detected\n"
.asciiz string_14 = "shell_buf_offset: "
.asciiz string_15 = "write command detected\n"
.asciiz string_16 = "\n"
.asciiz string_17 = "0123456789       :;<=>?"
.asciiz string_18 = "run command detected\n"
.word system_call_func_number = 0
.word system_call_arg0 = 0
.word system_call_arg1 = 0
.word system_call_arg2 = 0
.word system_call_arg3 = 0
.word system_call_return_value = 0
.asciiz string_30 = "Disk not mounted!\n"
.asciiz string_31 = "Disk test\n"
.asciiz string_32 = "FAT offset: "
.asciiz string_33 = "Root offset: "
.asciiz string_34 = "Data offset: "
.asciiz string_35 = "Sectors per cluster: "
.asciiz string_36 = "Disk test\n"
.asciiz string_37 = "Disk not mounted!\n"
.asciiz string_38 = "Volume name: "
.asciiz string_39 = " file(s)\n"
.asciiz string_40 = "        "
.asciiz string_41 = "   "
.asciiz string_42 = "           "
.asciiz string_43 = "dump"
.asciiz string_44 = "write"
.asciiz string_45 = "run"
.asciiz string_46 = "mount"
.asciiz string_47 = "dir"
.asciiz string_48 = "open"
.asciiz string_49 = "close"
.asciiz string_50 = "filerd"
.asciiz string_51 = "filewr"
.asciiz string_52 = "search"
.asciiz string_53 = "Typed string is: "
.asciiz string_54 = "Invalid command\n"
.asciiz string_55 = "\ncarriage return\n"
.asciiz string_56 = "\n"
.asciiz string_57 = "end\n"
.asciiz string_59 = "\nZaC-3 OS\n"
halt

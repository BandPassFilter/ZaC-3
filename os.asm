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

_compare_string:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r5, r0, 0 ;GET
movi [fp + 0], r5 ;SET

27_start:
movi r5, [fp + 12] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
movi r6, [fp + 16] ;GET
movi r7, [fp + 0] ;GET
add r2, r0, r7
add r1, r0, r6
add r1, r1, r2
add r6, r0, r1 ;ADD_POINTER

mvbi r6, [r6 + 0] ;GET
sub r1, r5, r6
jz 27_true
addi r5, r0, 0
jmp 27_end
27_true:
addi r5, r0, 1
jmp 27_end
27_end:
sub r5, r5, r0
jz 27_false
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
jz 28_true
addi r4, r0, 0
jmp 28_end
28_true:
addi r4, r0, 1
jmp 28_end
28_end:
sub r4, r4, r0
jz 28_false
addi r4, r0, 1 ;GET
add r1, r0, r4
addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

28_false:

movi r5, [fp + 12] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 32 ;GET
sub r1, r5, r6
jz 29_true
addi r5, r0, 0
jmp 29_end
29_true:
addi r5, r0, 1
jmp 29_end
29_end:
sub r5, r5, r0
jz 29_false
addi r5, r0, 1 ;GET
add r1, r0, r5
addi sp, sp, 4
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

29_false:

jmp 27_start
27_false:

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

30_start:
movi r5, [fp + 0] ;GET
addi r6, r0, 256 ;GET
sub r1, r5, r6
jc 30_true
jz 30_false
addi r5, r0, 1
jmp 30_end
30_true:
addi r5, r0, 0
jmp 30_end
30_end:
sub r5, r5, r0
jz 30_false
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

jmp 30_start
30_false:

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

_skip_space:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 4
add fp, r0, sp
addi r5, r0, 0 ;GET
movi [fp + 0], r5 ;SET

31_start:
movi r5, [fp + 12] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 33 ;GET
sub r1, r5, r6
jc 31_true
jz 31_false
addi r5, r0, 1
jmp 31_end
31_true:
addi r5, r0, 0
jmp 31_end
31_end:
sub r5, r5, r0
jz 31_false
movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

jmp 31_start
31_false:

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

32_start:
movi r5, [fp + 12] ;GET
movi r6, [fp + 0] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD_POINTER

mvbi r5, [r5 + 0] ;GET
addi r6, r0, 32 ;GET
sub r1, r6, r5
jc 32_true
jz 32_false
addi r5, r0, 1
jmp 32_end
32_true:
addi r5, r0, 0
jmp 32_end
32_end:
sub r5, r5, r0
jz 32_false
movi r4, [fp + 0] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 0], r4 ;SET

jmp 32_start
32_false:

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

33_start:
movi r4, [fp + 32] ;GET
movi r5, [fp + 20] ;GET
movi r6, [fp + 28] ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

sub r1, r4, r5
jc 33_true
jz 33_false
addi r4, r0, 1
jmp 33_end
33_true:
addi r4, r0, 0
jmp 33_end
33_end:
sub r4, r4, r0
jz 33_false
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
jz 34_true
addi r4, r0, 0
jmp 34_end
34_true:
addi r4, r0, 1
jmp 34_end
34_end:
sub r4, r4, r0
jz 34_false
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

34_false:

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
jz 35_true
addi r4, r0, 0
jmp 35_end
35_true:
addi r4, r0, 1
jmp 35_end
35_end:
sub r4, r4, r0
jz 35_false
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

35_false:

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
jc 36_true
jz 36_false
addi r4, r0, 1
jmp 36_end
36_true:
addi r4, r0, 0
jmp 36_end
36_end:
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
jz 37_true
addi r5, r0, 0
jmp 37_end
37_true:
addi r5, r0, 1
jmp 37_end
37_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 36_false
addi r4, r0, 0 ;GET
movi [fp + 36], r4 ;SET

38_start:
movi r4, [fp + 36] ;GET
addi r5, r0, 16 ;GET
sub r1, r4, r5
jc 38_true
jz 38_false
addi r4, r0, 1
jmp 38_end
38_true:
addi r4, r0, 0
jmp 38_end
38_end:
sub r4, r4, r0
jz 38_false
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
jc 39_true
jz 39_false
addi r4, r0, 1
jmp 39_end
39_true:
addi r4, r0, 0
jmp 39_end
39_end:
mvbi r5, [fp + 40] ;/GET
addi r6, r0, 127 ;GET
sub r1, r5, r6
jc 40_true
jz 40_false
addi r5, r0, 1
jmp 40_end
40_true:
addi r5, r0, 0
jmp 40_end
40_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 39_false
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

39_false:

mvbi r4, [fp + 40] ;/GET
addi r5, r0, 32 ;GET
sub r1, r4, r5
jc 41_true
jz 41_false
addi r4, r0, 1
jmp 41_end
41_true:
addi r4, r0, 0
jmp 41_end
41_end:
mvbi r5, [fp + 40] ;/GET
addi r6, r0, 126 ;GET
sub r1, r6, r5
jc 42_true
jz 42_false
addi r5, r0, 1
jmp 42_end
42_true:
addi r5, r0, 0
jmp 42_end
42_end:
add r2, r0, r5
add r1, r0, r4
or r1, r1, r2
add r4, r0, r1 ;LOGICAL_OR

sub r4, r4, r0
jz 41_false
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

41_false:

movi r4, [fp + 36] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 36], r4 ;SET

jmp 38_start
38_false:

36_false:

jmp 33_start
33_false:

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

43_start:
movi r4, [fp + 28] ;GET
addi r5, r0, 1 ;GET
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
jz 44_true
addi r4, r0, 0
jmp 44_end
44_true:
addi r4, r0, 1
jmp 44_end
44_end:
sub r4, r4, r0
jz 44_false
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

44_false:

mvbi r4, [fp + 32] ;/GET
addi r5, r0, 13 ;GET
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
addi r4, r0, 0 ;GET
movi [fp + 28], r4 ;SET

45_false:

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

46_false:

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
jz 47_true
addi r4, r0, 0
jmp 47_end
47_true:
addi r4, r0, 1
jmp 47_end
47_end:
sub r4, r4, r0
jz 47_false
addi r4, r0, 0 ;GET
movi [fp + 28], r4 ;SET

47_false:

movi r4, [fp + 28] ;GET
addi r5, r0, 1 ;GET
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

48_false:

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

jmp 43_start
43_false:

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
49_start:

;for_condition
movi r3, [fp + 4] ;GET
movi r4, [fp + 20] ;GET
sub r1, r3, r4
jc 49_true
jz 49_false
addi r3, r0, 1
jmp 49_end
49_true:
addi r3, r0, 0
jmp 49_end
49_end:
sub r1, r1, r0
jz 49_false

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
jmp 49_start
49_false:

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

50_start:
movi r5, [fp + 4] ;GET
addi r6, r0, 32768 ;GET
sub r1, r5, r6
jc 50_true
jz 50_false
addi r5, r0, 1
jmp 50_end
50_true:
addi r5, r0, 0
jmp 50_end
50_end:
sub r5, r5, r0
jz 50_false
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

jmp 50_start
50_false:

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

51_start:
movi r5, [fp + 4] ;GET
addi r6, r0, 32768 ;GET
sub r1, r5, r6
jc 51_true
jz 51_false
addi r5, r0, 1
jmp 51_end
51_true:
addi r5, r0, 0
jmp 51_end
51_end:
sub r5, r5, r0
jz 51_false
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

jmp 51_start
51_false:

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
jz 52_true
addi r5, r0, 0
jmp 52_end
52_true:
addi r5, r0, 1
jmp 52_end
52_end:
sub r5, r5, r0
jz 52_false
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

52_false:

movi r5, [dp + system_call_func_number] ;GET
addi r6, r0, 1 ;GET
sub r1, r5, r6
jz 53_true
addi r5, r0, 0
jmp 53_end
53_true:
addi r5, r0, 1
jmp 53_end
53_end:
sub r5, r5, r0
jz 53_false
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

53_false:

movi r4, [dp + system_call_func_number] ;GET
addi r5, r0, 2 ;GET
sub r1, r4, r5
jz 54_true
addi r4, r0, 0
jmp 54_end
54_true:
addi r4, r0, 1
jmp 54_end
54_end:
sub r4, r4, r0
jz 54_false
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

54_false:

movi r4, [dp + system_call_func_number] ;GET
addi r5, r0, 10 ;GET
sub r1, r4, r5
jz 55_true
addi r4, r0, 0
jmp 55_end
55_true:
addi r4, r0, 1
jmp 55_end
55_end:
sub r4, r4, r0
jz 55_false
addi r1, r0, _shell

jr r1

55_false:

movi r17, [dp + system_call_return_value]

addi sp, sp, 4
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
subi sp, sp, 68
add fp, r0, sp
addi r4, r0, 256 ;GET_32
lui r4, 19 ;GET_32
movi [fp + 0], r4 ;SET

addi r4, r0, 0 ;GET_32
lui r4, 1 ;GET_32
movi [fp + 4], r4 ;SET

movi r4, [fp + 4] ;GET
movi [fp + 8], r4 ;SET

addi r4, r0, string_30
lui r4, _string_hi_adrs ;GET_32
movi [fp + 12], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 12] ;GET_MEMORY
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
addi r4, r0, 0 ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END
subi sp, sp, 4
movi r4, [fp + 4] ;GET
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _diskRead
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET







addi r4, r0, 512 ;GET
movi [fp + 40], r4 ;SET

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

movi [fp + 64], r4 ;SET

movi r4, [fp + 64] ;GET
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

_dir_command:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
subi sp, sp, 64
add fp, r0, sp
addi r5, r0, 256 ;GET_32
lui r5, 19 ;GET_32
movi [fp + 0], r5 ;SET

addi r5, r0, 0 ;GET_32
lui r5, 1 ;GET_32
movi [fp + 4], r5 ;SET

movi r5, [fp + 4] ;GET
movi [fp + 8], r5 ;SET

addi r5, r0, string_31
lui r5, _string_hi_adrs ;GET_32
movi [fp + 12], r5 ;SET




movi r4, [fp + 72] ;GET
addi r5, r0, 255 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

movi [fp + 16], r4 ;SET

movi r4, [fp + 72] ;GET
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

movi [fp + 20], r4 ;SET

movi r4, [fp + 72] ;GET
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

movi [fp + 24], r4 ;SET

movi r4, [fp + 16] ;GET
addi r5, r0, 2 ;GET
sub r1, r5, r4
jz 56_true
addi r4, r0, 1
jmp 56_end
56_true:
addi r4, r0, 0
jmp 56_end
56_end:
sub r4, r4, r0
jz 56_false
addi r4, r0, string_32
lui r4, _string_hi_adrs ;GET_32
movi [fp + 28], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 28] ;GET_MEMORY
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
addi sp, sp, 64
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

56_false:

addi r5, r0, 0 ;GET
movi [fp + 32], r5 ;SET


;for_init
movi r3, [fp + 20] ;GET
movi [fp + 36], r3 ;SET
57_start:

;for_condition
movi r3, [fp + 36] ;GET
movi r4, [fp + 24] ;GET
sub r1, r3, r4
jc 57_true
jz 57_false
addi r3, r0, 1
jmp 57_end
57_true:
addi r3, r0, 0
jmp 57_end
57_end:
sub r1, r1, r0
jz 57_false

;for_body
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 36] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 4] ;GET
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
movi [fp + 40], r3 ;SET
58_start:

;for_condition
movi r3, [fp + 40] ;GET
addi r4, r0, 512 ;GET
sub r1, r3, r4
jc 58_true
jz 58_false
addi r3, r0, 1
jmp 58_end
58_true:
addi r3, r0, 0
jmp 58_end
58_end:
sub r1, r1, r0
jz 58_false

;for_body
movi r4, [fp + 8] ;GET
movi r5, [fp + 40] ;GET
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
movi [fp + 44], r4 ;SET

movi r4, [fp + 8] ;GET
movi r5, [fp + 40] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

mvbi r4, [r4 + 0] ;GET
movi [fp + 48], r4 ;SET

movi r4, [fp + 44] ;GET
addi r5, r0, 15 ;GET
sub r1, r5, r4
jz 59_true
addi r4, r0, 1
jmp 59_end
59_true:
addi r4, r0, 0
jmp 59_end
59_end:
movi r5, [fp + 48] ;GET
addi r6, r0, 128 ;GET
sub r1, r5, r6
jc 60_true
jz 60_false
addi r5, r0, 1
jmp 60_end
60_true:
addi r5, r0, 0
jmp 60_end
60_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

movi r5, [fp + 48] ;GET
addi r6, r0, 0 ;GET
sub r1, r6, r5
jc 61_true
jz 61_false
addi r5, r0, 1
jmp 61_end
61_true:
addi r5, r0, 0
jmp 61_end
61_end:
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;LOGICAL_AND

sub r4, r4, r0
jz 59_false
movi r4, [fp + 32] ;GET
addi r5, r0, 0 ;GET
sub r1, r5, r4
jc 62_true
jz 62_false
addi r4, r0, 1
jmp 62_end
62_true:
addi r4, r0, 0
jmp 62_end
62_end:
sub r4, r4, r0
jz 62_false
movi r4, [fp + 44] ;GET
addi r5, r0, 8 ;GET
sub r1, r5, r4
jz 63_true
addi r4, r0, 1
jmp 63_end
63_true:
addi r4, r0, 0
jmp 63_end
63_end:
sub r4, r4, r0
jz 63_false
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

63_false:

62_false:

movi r4, [fp + 44] ;GET
addi r5, r0, 16 ;GET
add r2, r0, r5
add r1, r0, r4
and r1, r1, r2
add r4, r0, r1 ;BITWISE_AND

addi r5, r0, 16 ;GET
sub r1, r4, r5
jz 64_true
addi r4, r0, 0
jmp 64_end
64_true:
addi r4, r0, 1
jmp 64_end
64_end:
sub r4, r4, r0
jz 64_false
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

64_false:

movi r4, [fp + 44] ;GET
addi r5, r0, 8 ;GET
sub r1, r4, r5
jz 65_true
addi r4, r0, 0
jmp 65_end
65_true:
addi r4, r0, 1
jmp 65_end
65_end:
sub r4, r4, r0
jz 65_false
addi r4, r0, string_33
lui r4, _string_hi_adrs ;GET_32
movi [fp + 52], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 52] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

65_false:

movi r4, [fp + 44] ;GET
addi r5, r0, 8 ;GET
sub r1, r5, r4
jz 66_true
addi r4, r0, 1
jmp 66_end
66_true:
addi r4, r0, 0
jmp 66_end
66_end:
sub r4, r4, r0
jz 66_false
movi r4, [fp + 32] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 32], r4 ;SET

66_false:


;for_init
addi r3, r0, 0 ;GET
movi [fp + 56], r3 ;SET
67_start:

;for_condition
movi r3, [fp + 56] ;GET
addi r4, r0, 11 ;GET
sub r1, r3, r4
jc 67_true
jz 67_false
addi r3, r0, 1
jmp 67_end
67_true:
addi r3, r0, 0
jmp 67_end
67_end:
sub r1, r1, r0
jz 67_false

;for_body
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 8] ;GET
movi r5, [fp + 40] ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD_POINTER

movi r5, [fp + 56] ;GET
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
movi r4, [fp + 56] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 56], r4 ;SET
jmp 67_start
67_false:

movi r4, [fp + 44] ;GET
addi r5, r0, 8 ;GET
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
jal _cr
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

68_false:

59_false:


;for_iter
movi r4, [fp + 40] ;GET
addi r5, r0, 32 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 40], r4 ;SET
jmp 58_start
58_false:


;for_iter
movi r4, [fp + 36] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 36], r4 ;SET
jmp 57_start
57_false:

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

addi r4, r0, string_34
lui r4, _string_hi_adrs ;GET_32
movi [fp + 60], r4 ;SET

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
addi sp, sp, 64
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

addi sp, sp, 64
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
subi sp, sp, 80
add fp, r0, sp
addi r5, r0, string_35
lui r5, _string_hi_adrs ;GET_32
movi [fp + 0], r5 ;SET

addi r5, r0, string_36
lui r5, _string_hi_adrs ;GET_32
movi [fp + 4], r5 ;SET

addi r5, r0, string_37
lui r5, _string_hi_adrs ;GET_32
movi [fp + 8], r5 ;SET

addi r5, r0, string_38
lui r5, _string_hi_adrs ;GET_32
movi [fp + 12], r5 ;SET

addi r5, r0, string_39
lui r5, _string_hi_adrs ;GET_32
movi [fp + 16], r5 ;SET


addi r5, r0, string_40
lui r5, _string_hi_adrs ;GET_32
movi [fp + 24], r5 ;SET

addi r5, r0, string_41
lui r5, _string_hi_adrs ;GET_32
movi [fp + 28], r5 ;SET

addi r5, r0, string_42
lui r5, _string_hi_adrs ;GET_32
movi [fp + 32], r5 ;SET

addi r5, r0, 6784 ;GET_32
lui r5, 6 ;GET_32
movi [fp + 36], r5 ;SET

addi r5, r0, string_43
lui r5, _string_hi_adrs ;GET_32
movi [fp + 40], r5 ;SET

addi r5, r0, 32 ;GET
mvbi [fp + 44], r5 ;SET

addi r5, r0, 8 ;GET
mvbi [fp + 48], r5 ;SET

addi r5, r0, 256 ;GET
movi [fp + 52], r5 ;SET

addi r5, r0, 0 ;GET
movi [fp + 56], r5 ;SET

addi r5, r0, 1 ;GET
movi [fp + 60], r5 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r5, [fp + 36] ;GET_MEMORY
movi [sp + 0], r5 ;SET
;CALL_PARAM_END_A
jal _reset_shell
addi sp, sp, 4
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET

69_start:
movi r5, [fp + 60] ;GET
addi r6, r0, 1 ;GET
sub r1, r5, r6
jz 69_true
addi r5, r0, 0
jmp 69_end
69_true:
addi r5, r0, 1
jmp 69_end
69_end:
sub r5, r5, r0
jz 69_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r5 ;REGISTER_SAVE_PUSH
jal _get_char
movi r5, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r5, r0, r1 ;RETURN_SET
mvbi [fp + 64], r5 ;SET

mvbi r5, [fp + 64] ;/GET
addi r6, r0, 31 ;GET
sub r1, r6, r5
jc 70_true
jz 70_false
addi r5, r0, 1
jmp 70_end
70_true:
addi r5, r0, 0
jmp 70_end
70_end:
sub r5, r5, r0
jz 70_false
mvbi r4, [fp + 64] ;/GET
movi r5, [fp + 36] ;GET
movi r6, [fp + 56] ;GET
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

movi r4, [fp + 56] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi [fp + 56], r4 ;SET

70_false:

movi r4, [fp + 56] ;GET
addi r5, r0, 255 ;GET
sub r1, r5, r4
jc 71_true
jz 71_false
addi r4, r0, 1
jmp 71_end
71_true:
addi r4, r0, 0
jmp 71_end
71_end:
sub r4, r4, r0
jz 71_false
addi r4, r0, 0 ;GET
movi [fp + 56], r4 ;SET

71_false:

mvbi r4, [fp + 64] ;/GET
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
movi r4, [fp + 56] ;GET
addi r5, r0, 0 ;GET
sub r1, r5, r4
jc 73_true
jz 73_false
addi r4, r0, 1
jmp 73_end
73_true:
addi r4, r0, 0
jmp 73_end
73_end:
sub r4, r4, r0
jz 73_false
movi r4, [fp + 56] ;GET
addi r5, r0, 1 ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 56], r4 ;SET

addi r4, r0, 0 ;GET
movi r5, [fp + 36] ;GET
movi r6, [fp + 56] ;GET
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
mvbi r4, [fp + 48] ;GET_MEMORY
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
mvbi r4, [fp + 44] ;GET_MEMORY
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
mvbi r4, [fp + 48] ;GET_MEMORY
mvbi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _print_char
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

73_false:

72_false:

mvbi r4, [fp + 64] ;/GET
addi r5, r0, 13 ;GET
sub r1, r4, r5
jz 74_true
addi r4, r0, 0
jmp 74_end
74_true:
addi r4, r0, 1
jmp 74_end
74_end:
sub r4, r4, r0
jz 74_false
addi r4, r0, 0 ;GET
movi [fp + 68], r4 ;SET

addi r4, r0, 0 ;GET
movi [fp + 72], r4 ;SET

addi r4, r0, 6784 ;GET_32
lui r4, 6 ;GET_32
movi [fp + 36], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 40] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

movi r4, [fp + 56] ;GET
addi r5, r0, 0 ;GET
sub r1, r5, r4
jc 75_true
jz 75_false
addi r4, r0, 1
jmp 75_end
75_true:
addi r4, r0, 0
jmp 75_end
75_end:
sub r4, r4, r0
jz 75_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 0] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 36] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 68], r4 ;SET

movi r4, [fp + 68] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 76_true
addi r4, r0, 0
jmp 76_end
76_true:
addi r4, r0, 1
jmp 76_end
76_end:
sub r4, r4, r0
jz 76_false
addi r4, r0, 4 ;GET
movi [fp + 56], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 36] ;GET_MEMORY
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
movi [fp + 72], r4 ;SET

76_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 4] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 36] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 68], r4 ;SET

movi r4, [fp + 68] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 77_true
addi r4, r0, 0
jmp 77_end
77_true:
addi r4, r0, 1
jmp 77_end
77_end:
sub r4, r4, r0
jz 77_false
addi r4, r0, 5 ;GET
movi [fp + 56], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 56] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 36] ;GET_MEMORY
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
movi [fp + 72], r4 ;SET

77_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 8] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 36] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 68], r4 ;SET

movi r4, [fp + 68] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 78_true
addi r4, r0, 0
jmp 78_end
78_true:
addi r4, r0, 1
jmp 78_end
78_end:
sub r4, r4, r0
jz 78_false
addi r4, r0, 3 ;GET
movi [fp + 56], r4 ;SET

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
movi [fp + 72], r4 ;SET

78_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 12] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 36] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 68], r4 ;SET

movi r4, [fp + 68] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 79_true
addi r4, r0, 0
jmp 79_end
79_true:
addi r4, r0, 1
jmp 79_end
79_end:
sub r4, r4, r0
jz 79_false
addi r4, r0, 3 ;GET
movi [fp + 56], r4 ;SET

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
movi [fp + 20], r4 ;SET

addi r4, r0, 1 ;GET
movi [fp + 72], r4 ;SET

79_false:

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 16] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
subi sp, sp, 4
movi r4, [fp + 36] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _compare_string
addi sp, sp, 8
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET
movi [fp + 68], r4 ;SET

movi r4, [fp + 68] ;GET
addi r5, r0, 1 ;GET
sub r1, r4, r5
jz 80_true
addi r4, r0, 0
jmp 80_end
80_true:
addi r4, r0, 1
jmp 80_end
80_end:
sub r4, r4, r0
jz 80_false
addi r4, r0, 3 ;GET
movi [fp + 56], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 20] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _dir_command
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

addi r4, r0, 1 ;GET
movi [fp + 72], r4 ;SET

80_false:

movi r4, [fp + 72] ;GET
addi r5, r0, 0 ;GET
sub r1, r4, r5
jz 81_true
addi r4, r0, 0
jmp 81_end
81_true:
addi r4, r0, 1
jmp 81_end
81_end:
sub r4, r4, r0
jz 81_false
subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 28] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _printString
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

81_false:

75_false:

addi r4, r0, 0 ;GET
movi [fp + 56], r4 ;SET

subi sp, sp, 4
movi [sp + 0], r3 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi [sp + 0], r4 ;REGISTER_SAVE_PUSH
subi sp, sp, 4
movi r4, [fp + 36] ;GET_MEMORY
movi [sp + 0], r4 ;SET
;CALL_PARAM_END_A
jal _reset_shell
addi sp, sp, 4
movi r4, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
movi r3, [sp + 0] ;REGISTER_SAVE_POP
addi sp, sp, 4
add r4, r0, r1 ;RETURN_SET

74_false:

jmp 69_start
69_false:

addi r4, r0, string_44
lui r4, _string_hi_adrs ;GET_32
movi [fp + 76], r4 ;SET

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

addi sp, sp, 80
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_main:
subi sp, sp, 4
add fp, r0, sp
addi sys, r0, _system_call

addi r4, r0, string_46
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
.asciiz string_30 = "Disk test\n"
.asciiz string_31 = "Disk test\n"
.asciiz string_32 = "Disk not mounted!\n"
.asciiz string_33 = "Volume name: "
.asciiz string_34 = "file(s)\n"
.asciiz string_35 = "dump"
.asciiz string_36 = "write"
.asciiz string_37 = "run"
.asciiz string_38 = "mount"
.asciiz string_39 = "dir"
.asciiz string_40 = "Typed string is: "
.asciiz string_41 = "Invalid command\n"
.asciiz string_42 = "\ncarriage return\n"
.asciiz string_43 = "\n"
.asciiz string_44 = "end\n"
.asciiz string_46 = "\nZaC-3 OS\n"
halt

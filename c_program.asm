lui fp, 18
lui sp, 18
lui ssp, 17
lui dp, 4
lui io, 19

jmp _main

_main:
subi sp, sp, 8
add fp, r0, sp
lui r3, 19 ;GET_32
ori r3, r3, 0 ;GET_32
movi [fp + 0], r3 ;SET


;for_init
addi r4, r0, 0 ;GET
movi [fp + 4], r4 ;SET
0_start:

;for_condition
movi r5, [fp + 4] ;GET
addi r6, r0, 127 ;GET
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
movi r5, [fp + 4] ;GET
movi r6, [fp + 0] ;GET
mvbi [r6 + 0], r5 ;SET


;for_iter
movi r5, [fp + 4] ;GET
addi r6, r0, 1 ;GET
add r2, r0, r6
add r1, r0, r5
add r1, r1, r2
add r5, r0, r1 ;ADD

movi [fp + 4], r5 ;SET
jmp 0_start
0_false:

halt

halt

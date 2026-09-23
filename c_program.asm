lui fp, 18
addi sp, r0, 65532
lui sp, 18
addi ssp, r0, 65532
lui ssp, 17
lui dp, 4
lui io, 19

jmp _main

_main:
subi sp, sp, 8
add fp, r0, sp

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

movi [fp + 0], r4 ;SET


addi r4, r0, 5 ;GET
movi [fp + 4], r4 ;SET

addi r4, r0, 3 ;GET
addi r5, r0, 4 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

movi r5, [fp + 4] ;GET
add r2, r0, r5
add r1, r0, r4
sub r1, r1, r2
add r4, r0, r1 ;SUB

movi [fp + 0], r4 ;SET

movi r4, [fp + 0] ;GET
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
movi [fp + 0], r4 ;SET

0_false:

halt

halt

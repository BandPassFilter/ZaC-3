lui fp, 3
addi sp, r0, 65532
lui sp, 3
addi ssp, r0, 65532
lui ssp, 4
addi dp, r0, 0
lui dp, 5
lui io, 19

jmp _main

_system_call:
subi sp, sp, 4
movi [sp + 0], fp
subi sp, sp, 4
movi [sp + 0], ra
add fp, r0, sp
.word system_call_func_number = 0

addi r4, r0, 1 ;GET
movi [dp + system_call_func_number], r4 ;SET

movi r4, [dp + system_call_func_number] ;GET
addi r5, r0, 0 ;GET
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
Рлллллллл■ю■ю■ю■0_false:

addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 4
movi fp, [sp + 0]
addi sp, sp, 4
jr ra

_main:
subi sp, sp, 4
add fp, r0, sp

halt

halt

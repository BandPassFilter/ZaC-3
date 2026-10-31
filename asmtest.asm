lui fp, 18
addi sp, r0, 65532
lui sp, 18
addi ssp, r0, 65532
lui ssp, 17
lui dp, 4
lui io, 19

jmp _main

_main:
subi sp, sp, 0
add fp, r0, sp
addi r1, r0, 131072 ;assembly_test

halt

halt

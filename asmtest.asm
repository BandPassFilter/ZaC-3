lui fp, 3
addi sp, r0, 65532
lui sp, 3
addi ssp, r0, 65532
lui ssp, 4
lui dp, 5
lui io, 19

jmp _main

_main:
subi sp, sp, 0
add fp, r0, sp
addi r1, r0, 131072 ;assembly_test

halt

halt

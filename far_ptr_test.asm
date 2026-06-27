jmp _main

_main:
addi sp, sp, -0
add fp, r0, sp
addi r4, r0, 1 ;GET
addi r5, r0, 2 ;GET
add r2, r0, r5
add r1, r0, r4
add r1, r1, r2
add r4, r0, r1 ;ADD

add r1, r0, r4
addi sp, sp, 0
movi ra, [sp + 0]
addi sp, sp, 2
add fp, r0, sp
jr ra

halt

halt

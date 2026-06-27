main:
.word a = 0

.word b = 0

.word c_ptr = 0

addi r1, r0, 30
addi r2, r0, 5
sub r1, r2, r1
movi [dp + a], r1

addi r1, r0, 59
movi [dp + b], r1

movi r1, [dp + a]
movi r2, [dp + b]
add r1, r2, r1
movi [dp + a], r1

movi r1, [dp + a]
movi r2, [dp + b]
sub r1, r2, r1
jz 0_true
addi r1, r0, 0
jmp 0_end
0_true:
addi r1, r0, 1
jmp 0_false
0_end:
movi r1, [dp + b]
movi r2, [dp + a]
add r1, r2, r1
movi [dp + b], r1

0_false:

1_start:
movi r1, [dp + a]
movi r2, [dp + b]
sub r1, r2, r1
jz 1_true
addi r1, r0, 0
jmp 1_end
1_true:
addi r1, r0, 1
jmp 1_false
1_end:
movi r1, [dp + a]
addi r2, r0, 1
add r1, r2, r1
movi [dp + a], r1

movi r1, [dp + a]
addi r2, r0, 2
add r1, r2, r1
movi r2, [dp + b]
addi r3, r0, 1
sub r2, r3, r2
sub r1, r2, r1
jz 2_true
addi r1, r0, 0
jmp 2_end
2_true:
addi r1, r0, 1
jmp 2_false
2_end:
movi r1, [dp + a]
addi r2, r0, 1
add r1, r2, r1
movi [dp + a], r1

movi r1, [dp + a]
movi r1, [dp + a]
addi r2, r0, 5
add r1, r2, r1
addi i1, r0, 16
mov i0, r1
movi [i0 + 0], r1

2_false:

jmp 1_start
1_false:

halt

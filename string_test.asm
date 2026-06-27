addi r1, r0, test_string
loop:
    mvbi r2, [r1 + 0]
    sub r3, r2, r0
    jz end
    mvbi [io + 0], r2
    addi r1, r1, 1
    jmp loop

end:
    halt


.asciiz test_string = "Hello, World!\n"
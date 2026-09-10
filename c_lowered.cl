lui fp, 18
addi sp, r0, 65532
lui sp, 18
addi ssp, r0, 65532
lui ssp, 17
lui dp, 4
lui io, 19

jmp _main

_main:
subi sp, sp, 4
add fp, r0, sp
int main_a;
main_a = 1 + 2;
main_a = 3 + 4;

halt

halt

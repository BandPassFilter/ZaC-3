#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
    
int main() {
    int MEMORY_SIZE = 1024*1024*16;
    uint16_t *memory = (uint16_t *) malloc(MEMORY_SIZE * sizeof(uint16_t));
    FILE *program_file = fopen("program.bin", "rb");
    if (!program_file) {
        printf("Error opening program file!\n");
        exit(1);
    }
    fread(memory, 1, 320*1024, program_file);
    printf("\n");
    for (int i = 0x20000; i < 0x201FF; i++) {
        printf("Memory[%X]: %X\n", i, memory[i]);
    }
}
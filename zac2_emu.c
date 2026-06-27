/*
ZaC-2 Emulator

ZaC-2 is a 16-bit CPU with 24-bit address bus and uses a segmented memory model. However each segment is directly hardwired
depending on what register is used. So SP is hardwired to the stack segment, user registers are hardwired to the data segment,
PC is hardwired to the code segment, I/O register is in the I/O segment, etc. The code segment has 256 KB of storage,
because the instructions are fixed-witdth 32-bit, allowing the PC to be a uint32_t pointer rather than uint8_t. Each
other segment like data, stack, I/O, etc. are 64 KB.

The address bus is byte-addressible, so most of the time with 16-bit word loads and stores, the A0 bit is set to zero.
The A0 bit is set to 1 only when there's odd byte accesses. 16-bit odd access (unaligned words) are NOT allowed to
maintain simplicity.

TODO:
Implement a 640x480 frame buffer using SDL.
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <windows.h>

#define PC registers[15]
#define RA registers[24]
#define SP registers[25]
#define FP registers[23]
#define FLAGS registers[20]
#define MEMORY_SIZE 1024*1024*16
#define reg_a_sel (IR_1 & 0b000001111100000) >> 5
#define reg_b_sel (IR_1 & 0b000000000011111)
#define reg_c_sel ((IR_0 & 0b1111100000000000) >> 11)
#define imm16_sel IR_0

HANDLE hSerial;
#define n 1
char szBuff[n] = {0};
DCB dcbSerialParams = {0};
DWORD dwBytesRead = 0;

int InitialiseSerialPort() {
    printf("Serial port program\n");
    hSerial = CreateFile("COM2",
                         GENERIC_READ | GENERIC_WRITE,
                         0,
                         0,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0);
    
    dcbSerialParams.DCBlength=sizeof(dcbSerialParams);
    if (!GetCommState(hSerial, &dcbSerialParams)) {
        // error getting state
        printf("error getting state\n");
        return 1;
    }

    if (hSerial == INVALID_HANDLE_VALUE) {
        if (GetLastError()==ERROR_FILE_NOT_FOUND){
            // serial port doesn't exist
            printf("Serial port doesn't exist\n");
            return 1;
        }
        printf("Serial port error occured\n");
        return 1;
    }

    dcbSerialParams.BaudRate=CBR_115200;
    dcbSerialParams.ByteSize=8;
    dcbSerialParams.StopBits=ONESTOPBIT;
    dcbSerialParams.Parity=NOPARITY;

    if(!SetCommState(hSerial, &dcbSerialParams)) {
        // error getting serial port state
        printf("error getting serial port state\n");
        return 1;
    }

    COMMTIMEOUTS timeouts = {0};

    timeouts.ReadIntervalTimeout=50;
    timeouts.ReadTotalTimeoutConstant=50;
    timeouts.ReadTotalTimeoutMultiplier=10;
    timeouts.WriteTotalTimeoutConstant=50;
    timeouts.WriteTotalTimeoutMultiplier=10;

    if (!SetCommTimeouts(hSerial, &timeouts)) {
        printf("invalid timeout error\n");
        return 1;
    }
    
    
    
    for (int i = 0; i < n; i++) {
        szBuff[i] = (char)0;
    }
}

uint8_t ReadSerialPort() {
    while (ReadFile(hSerial, szBuff, n, &dwBytesRead, NULL)) {
        if (dwBytesRead != 0) {
            return szBuff[0];
        }
    } 
}

void WriteSerialPort(uint8_t c) {
    WriteFile(hSerial, &c, 1, &dwBytesRead, NULL);
}

// I/O emulation
// 0x13xxxx is I/O region in memory
// OFFSETS:
// 0000 = Console decimal uint16_t out

void io_out(int address, uint16_t value) {
    if (address == 0x130000) {
        WriteSerialPort((uint8_t)value);
    }
}

uint16_t io_in(int address) {
    if (address == 0x130000) {
        return (uint16_t)ReadSerialPort();
    }
}

int ALU(uint16_t a, uint16_t b, int opcode, int *flags) {
    int carry = 0;
    int zero = 0;
    int res = 0;
    const int MAX_SIZE = 65536;
    switch(opcode) {
        case(0x00): {
            // ADD
            res = (a + b);
            carry = ((res >> 16) & 1) == 1;
            break;
        }
        case(0x01): {
            // SUB
            res = (a - b);
            carry = ((res >> 16) & 1) == 0;
            break;
        }
        case(0x02): {
            // OR
            res = (a | b);
            break;
        }
        case(0x03): {
            // AND
            res = (a & b);
            break;
        }
        case(0x04): {
            // NOT
            res = !a;
            break;
        }
        case(0x05): {
            // SL
            res = a << b;
            carry = ((res >> 16) & 1) == 1;
            break;
        }
        case(0x06): {
            // SR
            res = a >> b;
            carry = (a & 1) == 1;
            break;
        }
    }
    zero = res % MAX_SIZE == 0;
    *flags = zero + (carry << 1);
    return res % MAX_SIZE;
}


uint16_t load_memory(uint16_t *memory, int index) {
    if (index < MEMORY_SIZE) {
        if ((index >> 16) == 0x13) {
            // memory-mapped I/O
            return io_in(index);
        }
        if (index % 2 == 0) { // even address, load the 16-bit word
            return *(memory + (index >> 1)); 
        } else { // odd address, access the next 8-bits
            return *(memory + (index >> 1));
        }
    } else {
        printf("Memory index out of bounds!\n");
        exit(1);
    }
}

void store_memory(uint16_t *memory, int index, uint16_t data) {
    if (index < MEMORY_SIZE) {
        if ((index >> 16) == 0x13) {
            // memory-mapped I/O
            io_out(index, data);
        }
        if (index % 2 == 0) { // even address, load the 16-bit word
            *(memory + (index >> 1)) = data;
        } else { // odd address, access the next 8-bits
            *(memory + (index >> 1)) = data;
        }
    } else {
        printf("Memory index out of bounds!\n");
        exit(1);
    }
}  

uint8_t load_memory_byte(uint16_t *memory, int index) {
    uint8_t *byte_ptr = (uint8_t*)memory + index;
    if (index < MEMORY_SIZE) {
        if ((index >> 16) == 0x13) {
            // memory-mapped I/O
            return io_in(index);
        } else {
            return *byte_ptr;
        }
    } else {
        printf("Memory index out of bounds!\n");
        exit(1);
    }
}

void store_memory_byte(uint16_t *memory, int index, uint8_t data) {
    if (index < MEMORY_SIZE) {
        if ((index >> 16) == 0x13) {
            // memory-mapped I/O
            io_out(index, data);
        }
        uint8_t *byte_ptr = (uint8_t*)memory + index;
        *byte_ptr = data;
    } else {
        printf("Memory index out of bounds!\n");
        exit(1);
    }
}  

int eval_segment(int register_sel, int *registers) {
    // R0-R7 = user data registers, data segment (0x04xxxx)
    // system registers
	// fp R22 = frame pointer
    // flags R23 = flags register
    // fp r23 = frame pointer (same as stack segment 0x12xxxx)
    // ra R24 = return address from call 
    // sp R25 = stack register (at fixed base 0x12xxxx)
    // ssp R26 = supervisor stack (at fixed base 0x11xxxx)
    // dp R27 = data pointer (statics and globals go here, 0x04xxxx)
    // io R28 = I/O (at fixed base 0x13xxxx)
    // I0 R29
    // I1 R30 = 24-bit index register
    // pc R31 = 16-bit instruction pointer (points in terms of instruction words, not bytes) (0x000000 - 0x03ffff)

    const int register_sel_lut[16] = {0x10, 0x11, 0x12, 0x13};
    if (register_sel < 8) {
        // data registers
        return 0x04;
    }
    switch(register_sel) {
        case(23): {
            return 0x12;
        }
        case(25): {
            return 0x12;
        }
        case(26): {
            return 0x11;
        }
        case(27): {
            return 0x04;
        }
        case(28): {
            return 0x13;
        }
        case(29): {
            return registers[30];
        }
        case(31): {
            return 0x00;
        }
    }
}

void print_binary(int x) {
    for (int i = 0; i < 32; i++) {
        if (((x << i) & 0x80000000) == 0x80000000) {
            printf("1");
        } else {
            printf("0");
        }
    }
}

int main(int argc, char** argv) {
    printf("ZaC-2 Emulator\n");

    if (InitialiseSerialPort() == 1) {
        printf("serial port error\n");
        //exit(1);
    }
    FlushFileBuffers(hSerial);

    // 1 MB of memory
    // 16-bit computer address indexing memory byte-wise, NOT word-wise, so A0-A23 address bits holds 16 MB of memory.

    // 16-bit memory, every index holds a 16-bit word
    uint16_t *memory = (uint16_t *) malloc(MEMORY_SIZE * sizeof(uint8_t));
    if (memory == NULL) {
        printf("Memory allocation fail!\n");
        exit(1);
    } else {
        printf("Memory allocation successful at %p\n", memory);
    }

    // initialise memory
    for (int i = 0; i < MEMORY_SIZE/2; i++) {
        // initialise memory
        memory[i] = 0xFFFF;
    }

    // now load input program into memory
    FILE *program_file = fopen("program.bin", "rb");
    if (!program_file) {
        printf("Error opening program file!\n");
        exit(1);
    }
    fread(memory, 1, 320*1024, program_file);
    
    
    // define 16-bit registers
    // R0-R7 = 8 16-bit GPR (R0 = zero register)
    // I0-I1 = 24-bit index register (can access entire 24-bit address space)

    // system registers
    // A0-A7 = 16-bit offset registers for data, stack, supervisor stack, heap, I/O
    // A3 = return address from call
    // A4 = stack register (at fixed base 0x10xxxx)
    // A5 = supervisor stack (at fixed base 0x11xxxx)
    // A6 = heap (at fixed base 0x04xxxx)
    // A7 = I/O (at fixed base 0x13xxxx)
    // PC = 16-bit instruction pointer (points in terms of instruction words, not bytes) (0x000000 - 0x03ffff)
    // FLAGS = carry, zero, interrupt

    // even though registers are stored as uint64_t words, the emulator treats them as 16-bit registers.

    // instruction format:
    // R-type, I-type and J-type

    // R-type:
    // OOOO OxAA AAAB BBBB CCCC Cxxx xxxx xxxx
    
    // I-type:
    // OOOO OxAA AAAB BBBB IIII IIII IIII IIII

    // J-type:
    // OOOO Oxxx xxxx xxxx JJJJ JJJJ JJJJ JJJJ

    // Opcodes:
    // 00000 = NOP
    // 00001 = MOV aaaaa bbbbb // move register a = b
    // 00010 = ADD ccccc aaaaa bbbbb // add register c = a + b
    // 00011 = SUB ccccc aaaaa bbbbb // sub register c = a - b
    // 00100 = OR  ccccc aaaaa bbbbb // or
    // 00101 = AND ccccc aaaaa bbbbb // and
    // 00110 = NOT aaaaa // not register a = ~a
    // 00111 = ADDI aaaaa bbbbb i = ADD immediate a = b + i
    // 01000 = SUBI aaaaa bbbbb i = SUB immediate a = b - i
    // 01001 = ORI  aaaaa bbbbb i = OR immediate a = b || i
    // 01010 = ANDI aaaaa bbbbb i = AND immediate a = b && i
    // 01011 = SLI aaaaa bbbbb i // shift left immediate a = b << i
    // 01100 = SRI aaaaa bbbbb i // shift right immediate a = b >> i (unsigned)
    // 01101 = SRAI aaaaa bbbbb i // arithmetic shift right immediate a = b >> i (signed)
    // 01110 = MOVI aaaaa [bbbbb i] = move indirect register + offset, b = memory[a + i]
    // 01111 = MOVI [bbbbb i] aaaaa = move indirect register to memory, memory[b + i] = a
    // 10000 = JMP J = Jump unconditional to J
    // 10001 = JZ J = Jump if zero to J
    // 10010 = JC J = Jump if carry to J
    // 10011 = JNZ J = Jump if not zero to J
    // 10100 = JNC J = Jump if not carry to J
    // 10101 = JAL J = Jump and link to J ($ra or A3 = return address of PC)
    // 10110 = JR J = Jump register (such as $ra)
    // 10111 = SYSCALL aaaaa = Perform system call with register aaaaa as syscall number
    // 11000 = MVBI aaaaa [bbbbb i] = move indirect byte register + offset, b = [a + y] byte
    // 11001 = MVBI [bbbbb i] aaaaa = move indirect byte register + offset, memory[b + i] byte = a
    // 11111 = HALT

    /*
    0 = R0
    1 = R1
    2 = R2
    3 = R3
    4 = R4
    5 = R5
    6 = R6
    7 = R7
    23 = FLAGS
    24 = ra
    25 = sp
    26 = ssp
    27 = dp
    28 = io
    29 = i0
    30 = i1
    31 = pc
    */
    int registers[64]; // register file

    //for (int i = 0x40000; i < 0x400FF; i++) {
    //    printf("Memory[%d]: %d  ", i, memory[i]);
    //}
    


    for (int i = 0; i < 64; i++) {
        // initialise registers
        registers[i] = 0;
    }

    SP = 0xffff;

    
    PC = 0;


    int IR_0, IR_1, pre_IR_0, pre_IR_1 = 0; // instruction register 32-bit (16-bit low and high)
    int ring = 0; // ring counter for control unit


    int data_bus = 0; // 16-bit
    int address_bus = 0; // 24-bit
    int address_calc = 0;

    int run = 1; // CPU run state
    int seg_eval = 0;
    int reg_a_eval = 0; // R0-R3
    int reg_b_eval = 0;
    int reg_c_eval = 0;
    int offset_eval = 0;

    int debug_mode = 0;
    
    while (run) {
        // instruction fetch-execute cycle
        switch(ring) {
            case 0x00: {
                // fetch instruction from memory
                registers[0] = 0; // reset zero register
                IR_0 = load_memory(memory, (PC << 2));
                IR_1 = load_memory(memory, (PC << 2) + 2);
                uint32_t temp_ir = (pre_IR_1 << 16) + pre_IR_0;

                PC = PC + 1;
                ring = ring + 1;
                break;
            }

            // instruction format:
            // R-type, I-type and J-type
            // R-type: OOOO OxAA AAAB BBBB CCCC Cxxx xxxx xxxx
            // I-type: OOOO OxAA AAAB BBBB IIII IIII IIII IIII
            // J-type: OOOO Oxxx xxxx xxxx JJJJ JJJJ JJJJ JJJJ
            case 0x01: {
                // execute instruction
                switch(IR_1 >> 3+8) {
                    case 0b00000: {
                        // NOP
                        ring = 0;
                        break;
                    }
                    case 0b00001: {
                        // MOV aaaaa = bbbbb register
                        ring = 0;
                        registers[reg_a_sel] = registers[reg_b_sel];
                        ring = 0;
                        break;
                    }
                    case 0b00010: {
                        // ADD a b c
                        // ADD opcode = 0
                        registers[reg_a_sel] = ALU(registers[reg_b_sel], registers[reg_c_sel], 0, &FLAGS);
                        ring = 0;
                        break;
                    }
                    case 0b00011: {
                        // SUB a b c
                        // SUB opcode = 1
                        registers[reg_a_sel] = ALU(registers[reg_b_sel], registers[reg_c_sel], 1, &FLAGS);
                        ring = 0;
                        break;
                    }
                    case 0b00100: {
                        // OR a b c
                        // OR opcode = 2
                        registers[reg_a_sel] = ALU(registers[reg_b_sel], registers[reg_c_sel], 2, &FLAGS);
                        ring = 0;
                        break;
                    }
                    case 0b00101: {
                        // AND a b c
                        // AND opcode = 3
                        registers[reg_a_sel] = ALU(registers[reg_b_sel], registers[reg_c_sel], 3, &FLAGS);
                        ring = 0;
                        break;
                    }
                    case 0b00110: {
                        // NOT a b c
                        // NOT opcode = 4
                        registers[reg_a_sel] = ALU(registers[reg_b_sel], registers[reg_c_sel], 4, &FLAGS);
                        ring = 0;
                        break;
                    }
                    case 0b00111: {
                        // ADD a = b + i
                        registers[reg_a_sel] = ALU(registers[reg_b_sel], imm16_sel, 0, &FLAGS);
                        ring = 0;
                        break;
                    }
                    case 0b01000: {
                        // SUB a = b + i
                        registers[reg_a_sel] = ALU(registers[reg_b_sel], imm16_sel, 1, &FLAGS);
                        ring = 0;
                        break;
                    }
                    case 0b01001: {
                        // OR a = b + i
                        registers[reg_a_sel] = ALU(registers[reg_b_sel], imm16_sel, 2, &FLAGS);
                        ring = 0;
                        break;
                    }
                    case 0b01010: {
                        // AND a = b + i
                        registers[reg_a_sel] = ALU(registers[reg_b_sel], imm16_sel, 3, &FLAGS);
                        ring = 0;
                        break;
                    }
                    case 0b01011: {
                        // SL a b c
                        // SL opcode = 5
                        registers[reg_a_sel] = ALU(registers[reg_b_sel], registers[reg_c_sel], 5, &FLAGS);
                        ring = 0;
                        break;
                    }
                    case 0b01100: {
                        // SR a b c
                        // SR opcode = 6
                        registers[reg_a_sel] = ALU(registers[reg_b_sel], registers[reg_c_sel], 6, &FLAGS);
                        ring = 0;
                        break;
                    }
                    case 0b01101: {
                        // SRA a b c
                        // SR opcode = 6
                        registers[reg_a_sel] = ALU(registers[reg_b_sel], registers[reg_c_sel], 6, &FLAGS);
                        ring = 0;
                        break;
                    }
                    case 0b01110: {
                        // MOVI a [b+i], a = mem[b+i]
                        seg_eval = eval_segment(reg_b_sel, registers);
                        if (seg_eval == 0) {
                            printf("Segmentation fault, tried to access code\n");
                            exit(1);
                        }
                        reg_a_eval = registers[reg_a_sel];
                        reg_b_eval = registers[reg_b_sel];
                        offset_eval = imm16_sel;
                        address_calc = (seg_eval << 16) + (reg_b_eval + offset_eval);
                        registers[reg_a_sel] = load_memory(memory, address_calc);
                        ring = 0;
                        break;
                    }
                    case 0b01111: {
                        // MOVI [b + i] a, mem[b+i] = a
                        seg_eval = eval_segment(reg_b_sel, registers);
                        if (seg_eval == 0) {
                            printf("Segmentation fault, tried to access code\n");
                            exit(1);
                        }
                        reg_a_eval = registers[reg_a_sel];
                        reg_b_eval = registers[reg_b_sel];
                        offset_eval = imm16_sel;
                        address_calc = (seg_eval << 16) + (reg_b_eval + offset_eval);
                        store_memory(memory, address_calc, reg_a_eval);
                        ring = 0;
                        break;
                    }
                    case 0b10000: {
                        // JMP J
                        offset_eval = imm16_sel;
                        PC = imm16_sel;
                        ring = 0;
                        break;
                    }
                    case 0b10001: {
                        // JZ J
                        offset_eval = imm16_sel;
                        if (FLAGS & 0x0001) {
                            PC = imm16_sel;
                        }
                        ring = 0;
                        break;
                    }
                    case 0b10010: {
                        // JC J
                        offset_eval = imm16_sel;
                        if (FLAGS & 0x0002) {
                            PC = imm16_sel;
                        }
                        ring = 0;
                        break;
                    }
                    case 0b10011: {
                        // JNZ J
                        offset_eval = imm16_sel;
                        if (!(FLAGS & 0x0001)) {
                            PC = imm16_sel;
                        }
                        ring = 0;
                        break;
                    }
                    case 0b10100: {
                        // JNC J
                        offset_eval = imm16_sel;
                        if (!(FLAGS & 0x0002)) {
                            PC = imm16_sel;
                        }
                        ring = 0;
                        break;
                    }
                    case 0b10101: {
                        // JAL J
                        offset_eval = imm16_sel;
                        RA = PC;
                        PC = imm16_sel;
                        ring = 0;
                        break;
                    }
                    case 0b10110: {
                        // JR A
                        PC = registers[reg_a_sel];
                        ring = 0;
                        break;
                    }
                    case 0b11000: {
                        // MVBI a [b+i], a = mem[b+i]
                        seg_eval = eval_segment(reg_b_sel, registers);
                        reg_a_eval = registers[reg_a_sel];
                        reg_b_eval = registers[reg_b_sel];
                        offset_eval = imm16_sel;
                        address_calc = (seg_eval << 16) + (reg_b_eval + offset_eval);
                        registers[reg_a_sel] = load_memory_byte(memory, address_calc);
                        ring = 0;
                        break;
                    }
                    case 0b11001: {
                        // MVBI [b + i] a, mem[b+i] = a
                        seg_eval = eval_segment(reg_b_sel, registers);
                        reg_a_eval = registers[reg_a_sel];
                        reg_b_eval = registers[reg_b_sel];
                        offset_eval = imm16_sel;
                        address_calc = (seg_eval << 16) + (reg_b_eval + offset_eval);
                        store_memory_byte(memory, address_calc, reg_a_eval);
                        ring = 0;
                        break;
                    }
                    case 0b11111: {
                        // HALT
                        printf("SYSTEM HALTED\n");
                        run = 0;
                        break;
                    }
                }
            }
        }

        debug_mode = 0;
        if (debug_mode) {
            printf("IR: ");
            print_binary((IR_1<<16)+IR_0);
            printf("\n");
            printf("PC: %d,  IR: %d,  MEMORY[PC]: %d\n", PC, (IR_1<<16)+IR_0, load_memory(memory, PC));
            printf("R0: %d, R1: %d,  R2: %d,  R3: %d,  R4: %d,  R5: %d,  R6: %d,  R7: %d,  I0: %d,  I1: %d\n", registers[0], registers[1], registers[2], registers[3], registers[4], registers[5], registers[6], registers[7], registers[29], registers[30]);
            printf("R8: %d, R9: %d, R10: %d, R11: %d, R12: %d, R13: %d, R14: %d, R15: %d, R16: %d, R17: %d\n", registers[8], registers[9], registers[10], registers[11], registers[12], registers[13], registers[14], registers[15], registers[16], registers[17]);
            printf("fp: %d, sp: %d, ra: %d, flags: %d\n", FP, SP, RA, FLAGS);
            printf("sp[%d]: %d\n", (eval_segment(25, registers)<<16) + SP, load_memory(memory, (eval_segment(25, registers)<<16) + SP));
            //getchar();
        }
    }
    fclose(program_file);
    return 0;
}
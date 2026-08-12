#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define LABEL_STRING_SIZE 50
#define LABELS_SIZE 256
#define PARSE_LENGTH 64

/*
Assembler for ZaC-3

TODO:
Implement libraries.
.include "library.asm"

How  this works, the same way in C, is it simply copies and pastes the library file into the current
source file, and assembles the final big file. The big file would be something like "final.asm", where all
the includes and current file gets copied/pasted into, and then just assemble "final.asm".


Strings are stored in the data section of memory. I plan that the data section would reside just after the code
section, so the final flat binary would be 256KB + 64KB, which is code + data, making 320KB final file. The
last 64KB is where all the static data and strings reside and gets initialised immediately when the program starts.
*/


enum label_type {
    LABEL_NUMBER,
    LABEL_STRING
};

typedef struct {
    int memory_value;
    int imm_value;
    char *imm_string;
    int label_type;
    char name[LABEL_STRING_SIZE];
} Label;

int compare_string(char *string_a, char *string_b) {
    // each string null-terminated
    int i = 0;
    while (string_a[i] == string_b[i]) {
        if (string_a[i] == '\0' && string_b[i] == '\0') {
            return 1;
        }
        i++;
    }
    return 0;
}

void push_labels(Label *labels, char *instruction_string, int memory_value_value, int imm_value_value, int *input_buf_ptr, int *label_idx, int label_type) {
    // store data in label struct
    int i = 0;
    while (i < LABEL_STRING_SIZE && instruction_string[i] != '\0' && instruction_string[i] != ':') {
        labels[*label_idx].name[i] = instruction_string[i];
        i++;
    }
    labels[*label_idx].memory_value = memory_value_value;
    labels[*label_idx].imm_value = imm_value_value;
    labels[*label_idx].label_type = label_type;

    // update label index
    *label_idx = (*label_idx) + 1;
}

int check_string_in_labels(Label *labels, char *label_string) {
    // do simple linear search
    // returns valid integer if in label
    // if not, it returns -1
    for (int i = 0; i < LABELS_SIZE; i++) {
        if (compare_string(labels[i].name, label_string)) {
            return i;
        }
    }
    return -1;
}

int check_string_in_strings(int strings_arr_length, char **strings, char* string) {
    // checks if string is in string array (strings)
    for (int i = 0; i < strings_arr_length; i++) {
        if (compare_string(strings[i], string)) {
            return i;
        }
    }
    return -1;
}

int check_string_is_non_inst(char *instruction_string, int length) {
    for (int i = 0; i < length; i++) {
        if (instruction_string[i] == ':') {
            // jump label
            return 1;
        }
    }
    if (compare_string(instruction_string, ".define")) {
       return 1;
    } else if (compare_string(instruction_string, ".asciiz")) {
       return 1;
    } else if (compare_string(instruction_string, ".word")) {
        return 1;
    }
    return 0;
}

int check_string_is_jmp_label(char *instruction_string, int length) {
    for (int i = 0; i < length; i++) {
        if (instruction_string[i] == ':') {
            // jump label
            return 1;
        }
    }
    return 0;
}

int whitespace_detect(char input, char *whitespace) {
    const int WHITESPACE_LENGTH = 64;
    int i = 0;
    while (whitespace[i] != '\0') {
        if (input == whitespace[i]) {
            return 1; // True
        }
        i++;
    }
    return 0; // False
}

void grab_quoted_string(char *input_file_buf, long fsize, char *instruction_string, int *input_buf_ptr) {
    int parse_string_ptr = 0;
    char whitespace[64] = {'\"', '\0'}; // always have null-terminating character
    // initialise instruction_string
    for (int i = 0; i < PARSE_LENGTH; i++) {
        instruction_string[i] = '\0';
    }
    while ((*input_buf_ptr) < (fsize) && !whitespace_detect(input_file_buf[*input_buf_ptr], &whitespace[0])) {
        if (input_file_buf[*input_buf_ptr] == '\\') {
            (*input_buf_ptr)++;
            if (input_file_buf[*input_buf_ptr] == 'n') {
                // '\n' = carriage return + line feed, 0x0D, 0x0A
                instruction_string[parse_string_ptr] = 0x0D;
                parse_string_ptr++;
                instruction_string[parse_string_ptr] = 0x0A;
                parse_string_ptr++;
            }
            (*input_buf_ptr)++;
        } else {
            instruction_string[parse_string_ptr] = input_file_buf[*input_buf_ptr];
            (*input_buf_ptr)++;
            parse_string_ptr++;
        }
    }
}

void grab_string(char *input_file_buf, long fsize, char *instruction_string, int *input_buf_ptr) {
    int parse_string_ptr = 0;
    char whitespace[64] = {' ', ',', '\t', '\n', ']', '\0'}; // always have null-terminating character
    // initialise instruction_string
    for (int i = 0; i < PARSE_LENGTH; i++) {
        instruction_string[i] = '\0';
    }
    while ((*input_buf_ptr) < (fsize) && !whitespace_detect(input_file_buf[*input_buf_ptr], &whitespace[0])) {
        instruction_string[parse_string_ptr] = input_file_buf[*input_buf_ptr];
        (*input_buf_ptr)++;
        parse_string_ptr++;
    }
}

void skip_whitespace(char *input_file_buf, long fsize, int *input_buf_ptr) {
    int parse_string_ptr = 0;
    char whitespace[64] = {' ', ',', '\t', '\n', ']', '\0'}; // always have null-terminating character

    while ((*input_buf_ptr) < fsize && whitespace_detect(input_file_buf[*input_buf_ptr], &whitespace[0])) {
        (*input_buf_ptr)++;
        parse_string_ptr++;
    }
}

void skip_line(char *input_file_buf, long fsize, int *input_buf_ptr) {
    int parse_string_ptr = 0;
    char whitespace[64] = {'\n', '\0'}; // always have null-terminating character

    while ((*input_buf_ptr) < fsize && !whitespace_detect(input_file_buf[*input_buf_ptr], &whitespace[0])) {
        (*input_buf_ptr)++;
        parse_string_ptr++;
    }
    if (input_file_buf[*input_buf_ptr] == '\n') {
        (*input_buf_ptr)++;
    }
}

void remove_line_after(char *input_file_buf, long fsize, int *input_buf_ptr) {
    int parse_string_ptr = 0;
    char whitespace[64] = {'\n', '\0'}; // always have null-terminating character
    *(input_file_buf + *input_buf_ptr) = ' '; // remove comment

    while ((*input_buf_ptr) < fsize && (input_file_buf[*input_buf_ptr] != ';')) {
        *(input_file_buf + *input_buf_ptr) = ' '; // remove comment
        (*input_buf_ptr)--;
        parse_string_ptr++;
    }
    if (input_file_buf[*input_buf_ptr] == ';') {
        *(input_file_buf + *input_buf_ptr) = ' '; // remove comment
        (*input_buf_ptr)--;
        parse_string_ptr++;
    }
    if (input_file_buf[*input_buf_ptr] == '\n') {
        (*input_buf_ptr)++;
    }
}

int string_is_number(char *input_string) {
    // checks if ascii input is a number (i.e. atoi())

    // first just check if first character is decimal number or not

    if (strlen(input_string) > 1) {
        if (input_string[0] == '-' && input_string[1] == '0') {
            return 1;
        }
    }
    if (input_string[0] >= '0' && input_string[0] <= '9' || atoi(input_string) != 0) {
        return 1;
    } else {
        return 0;
    }
}

int eval_register(char *reg_string) {
    // r0-r7 are data registers d0-d7
    // r8-r15 are temp registers t0-t7
    // r16-22 are argument/result registers a0-a6
    // r23-31 are system registers
    // flags = r23
    // ra = r24
    // sp = r25
    // ssp = r26
    // dp = r27
    // io = r28
    // i0 = r29
    // i1 = r30
    // pc = r31

    if (compare_string(reg_string, "r0")) {
        return 0b00000;
    } else if (compare_string(reg_string, "r1")) {
        return 0b00001;
    } else if (compare_string(reg_string, "r2")) {
        return 0b00010;
    } else if (compare_string(reg_string, "r3")) {
        return 0b00011;
    } else if (compare_string(reg_string, "r4")) {
        return 0b00100;
    } else if (compare_string(reg_string, "r5")) {
        return 0b00101;
    } else if (compare_string(reg_string, "r6")) {
        return 0b00110;
    } else if (compare_string(reg_string, "r7")) {
        return 0b00111;
    } else if (compare_string(reg_string, "r8")) {
        return 0b01000;
    } else if (compare_string(reg_string, "r9")) {
        return 0b01001;
    } else if (compare_string(reg_string, "r10")) {
        return 0b01010;
    } else if (compare_string(reg_string, "r11")) {
        return 0b01011;
    } else if (compare_string(reg_string, "r12")) {
        return 0b01100;
    } else if (compare_string(reg_string, "r13")) {
        return 0b01101;
    } else if (compare_string(reg_string, "r14")) {
        return 0b01110;
    } else if (compare_string(reg_string, "r15")) {
        return 0b01111;
    } else if (compare_string(reg_string, "r16")) {
        return 0b10000;
    } else if (compare_string(reg_string, "r17")) {
        return 0b10001;
    } else if (compare_string(reg_string, "r18")) {
        return 0b10010;
    } else if (compare_string(reg_string, "r19")) {
        return 0b10011;
    } else if (compare_string(reg_string, "r20")) {
        return 0b10100;
    } else if (compare_string(reg_string, "r21")) {
        return 0b10101;
    } else if (compare_string(reg_string, "r22")) {
        return 0b10110;
    } else if (compare_string(reg_string, "fp")) {
        return 0b10111;
    } else if (compare_string(reg_string, "ra")) {
        return 0b11000;
    } else if (compare_string(reg_string, "sp")) {
        return 0b11001;
    } else if (compare_string(reg_string, "ssp")) {
        return 0b11010;
    } else if (compare_string(reg_string, "dp")) {
        return 0b11011;
    } else if (compare_string(reg_string, "io")) {
        return 0b11100;
    } else if (compare_string(reg_string, "i0")) {
        return 0b11101;
    } else if (compare_string(reg_string, "i1")) {
        return 0b11110;
    }

    return 0;
}

int eval_opcode(int inst_type, int instruction_number, int inst_shift) {
    // returns opcode number based on inst_type and instruction_number
    /*
    char *nop_type_inst[NOP_ARR_LENGTH] = {"nop", "halt"};
    char *r_type_inst[R_ARR_LENGTH] = {"mov", "add", "sub", "or", "and", "not", "sl", "sr", "sra", "jr"};
    char *i_type_inst[I_ARR_LENGTH] = {"addi", "subi", "ori", "andi", "movi", "mvbi", "lui"};
    char *j_type_inst[J_ARR_LENGTH] = {"jmp", "jz", "jc", "jnz", "jnc", "jal"};
    */

    int opcode_lut_0[5][10] = {
        {0},
        {0b00000, 0b11111},
        {0b00001, 0b00010, 0b00011, 0b00100, 0b00101, 0b00110, 0b01011, 0b01100, 0b01101, 0b10110},
        {0b00111, 0b01000, 0b01001, 0b01010, 0b01110, 0b11000, 0b11010},
        {0b10000, 0b10001, 0b10010, 0b10011, 0b10100, 0b10101}
    };
    int opcode_lut_1[5][10] = {
        {0},
        {0b00000, 0b11111},
        {0b00001, 0b00010, 0b00011, 0b00100, 0b00101, 0b00110, 0b01011, 0b01100, 0b01101, 0b10110},
        {0b00111, 0b01000, 0b01001, 0b01010, 0b01111, 0b11001, 0b11010},
        {0b10000, 0b10001, 0b10010, 0b10011, 0b10100, 0b10101}
    };
    switch(inst_shift) {
        case(0): {
            return opcode_lut_0[inst_type][instruction_number];
        }
        case(1): {
            return opcode_lut_1[inst_type][instruction_number];
        }
    }
    printf("opcode error!\n");
    exit(1);
}

int eval_imm16(char *input_string, Label *labels) {
    int temp_label_idx = check_string_in_labels(labels, input_string);
    if (temp_label_idx != -1) {
        if (labels[temp_label_idx].label_type == LABEL_NUMBER) {
            return labels[temp_label_idx].imm_value;
        } else if (labels[temp_label_idx].label_type == LABEL_STRING) {
            return labels[temp_label_idx].imm_value;
        }
    } else if (string_is_number(input_string)) {
        return atoi(input_string);
    } else {
        printf("Operand error\n");
        exit(1);
    }
    
}

int eval_imm24(char *input_string, Label *labels) {
    int temp_label_idx = check_string_in_labels(labels, input_string);
    if (temp_label_idx != -1) {
        return labels[temp_label_idx].imm_value;
    } else if (string_is_number(input_string)) {
        return atoi(input_string);
    } else {
        printf("Operand error at offset");
        exit(1);
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

enum inst_type {
    NONE,
    NOP_TYPE,
    R_TYPE,
    I_TYPE,
    J_TYPE
};

int main(int argc, char** argv) {
    printf("ZaC-3 Assembler\n");

    /*
    if (argc != 2) {
        printf("Needs a file to assemble!\n");
        exit(1);
    }
    */

    FILE *input_file, *output_file;

    char *input_file_str = "c_program.asm";

    input_file = fopen(input_file_str, "r");
    if (!input_file) {
        printf("Invalid input file\n");
        exit(1);
    }
    output_file = fopen("program.bin", "wb");
    if (!output_file) {
        printf("Unable to make output file\n");
        exit(1);
    }

    // get filesize
    fseek(input_file, 0, SEEK_END);
    long fsize = ftell(input_file);
    fseek(input_file, 0, SEEK_SET);

    char *input_file_buf = (char *) malloc((fsize+10) * sizeof(char));
    printf("Input file malloc\n");
    if (input_file_buf == NULL) {
        printf("Memory allocation fail!\n");
        exit(1);
    } else {
        printf("Memory allocation successful at %p\n", input_file_buf);
    }

    // initialise input file buffer
    for (int i = 0; i < (fsize+10); i++) {
        input_file_buf[i] = ' ';
    }

    uint8_t *data_segment_output = (uint8_t *) malloc(65536 * sizeof(uint8_t));
    printf("Data segment malloc\n");
    if (input_file_buf == NULL) {
        printf("Memory allocation fail!\n");
        exit(1);
    } else {
        printf("Memory allocation successful at %p\n", input_file_buf);
    }
    
    // initialise data segment buffer
    for (int i = 0; i < 65536; i++) {
        data_segment_output[i] = 0x00;
    }



    // read input file into buffer
    fread(input_file_buf, sizeof(char), fsize, input_file);
    
    char instruction_string[PARSE_LENGTH] = {0};
    char reg_a_string[PARSE_LENGTH] = {0};
    char reg_b_string[PARSE_LENGTH] = {0};
    char reg_c_string[PARSE_LENGTH] = {0};
    char imm16_string[PARSE_LENGTH] = {0};
    char imm24_string[PARSE_LENGTH] = {0};
    char offset_math_string[PARSE_LENGTH] = {0};

    #define NOP_ARR_LENGTH 2
    #define R_ARR_LENGTH 10
    #define I_ARR_LENGTH 7
    #define J_ARR_LENGTH 6
    char *nop_type_inst[NOP_ARR_LENGTH] = {"nop", "halt"};
    char *r_type_inst[R_ARR_LENGTH] = {"mov", "add", "sub", "or", "and", "not", "sl", "sr", "sra", "jr"};
    char *i_type_inst[I_ARR_LENGTH] = {"addi", "subi", "ori", "andi", "movi", "mvbi", "lui"};
    char *j_type_inst[J_ARR_LENGTH] = {"jmp", "jz", "jc", "jnz", "jnc", "jal"};

    int label_idx = 0;
    int current_address = 0;
    // first pass (evaluate label addresses and values, and assembler directives)
    Label labels[LABELS_SIZE] = {0};
    // jump labels are "jump_label:"
    int input_buf_ptr = 0;
    int adrs_offset_value = 0;
    int data_segment_size = 0;
    const int data_segment_base = 0x040000;
    while(input_buf_ptr < fsize) {
        


        
        skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
        grab_string(input_file_buf, fsize, instruction_string, &input_buf_ptr);
        // detect and remove comments
        char *temp_ptr = input_buf_ptr;
        if (instruction_string[0] == ';') {
            temp_ptr--;
            remove_line_after(input_file_buf, fsize, &temp_ptr);
        }
        char directive_string[50] = {0};
        char temp_string[50] = {0};
        int directive_value = 0;
        int dummy_idx = 0;
        // evaluate assembler directives (.byte, .word, .asciiz, etc.)
        if (compare_string(instruction_string, ".byte")) {
            // ".byte byte_name = 0x01"
            printf(".byte detected\n");
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            grab_string(input_file_buf, fsize, directive_string, &input_buf_ptr); // "byte_name"
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            grab_string(input_file_buf, fsize, temp_string, &input_buf_ptr); // "="
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            grab_string(input_file_buf, fsize, temp_string, &input_buf_ptr); // "1234"
            directive_value = atoi(temp_string);
            push_labels(labels, directive_string, directive_value, adrs_offset_value, &dummy_idx, &label_idx, LABEL_NUMBER);
            data_segment_output[adrs_offset_value] = directive_value;
            adrs_offset_value = adrs_offset_value + 1;
        } else if (compare_string(instruction_string, ".word")) {
            // ".word word_name = 0x0001"
            printf(".word detected\n");
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            grab_string(input_file_buf, fsize, directive_string, &input_buf_ptr); // "word_name"
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            grab_string(input_file_buf, fsize, temp_string, &input_buf_ptr); // "="
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            grab_string(input_file_buf, fsize, temp_string, &input_buf_ptr); // "1234"
            directive_value = atoi(temp_string);
            push_labels(labels, directive_string, directive_value, adrs_offset_value, &dummy_idx, &label_idx, LABEL_NUMBER);
            data_segment_output[adrs_offset_value] = directive_value % 256;
            data_segment_output[adrs_offset_value+1] = (directive_value >> 8) % 256;
            adrs_offset_value = adrs_offset_value + 2;
        } else if (compare_string(instruction_string, ".define")) {
            // ".define define_name 01234"
            printf(".define detected\n");
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            grab_string(input_file_buf, fsize, directive_string, &input_buf_ptr); // "word_name"
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            grab_string(input_file_buf, fsize, temp_string, &input_buf_ptr); // "1234"
            directive_value = atoi(temp_string);
            push_labels(labels, directive_string, directive_value, directive_value, &dummy_idx, &label_idx, LABEL_NUMBER);
        } else if (compare_string(instruction_string, ".asciiz")) {
            // ".asciiz string_namme = "Hello, World!\n"
            printf(".asciiz detected\n");
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            grab_string(input_file_buf, fsize, directive_string, &input_buf_ptr); // "word_name"
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            grab_string(input_file_buf, fsize, temp_string, &input_buf_ptr); // "="
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            input_buf_ptr++;
            grab_quoted_string(input_file_buf, fsize, temp_string, &input_buf_ptr); // "Hello, World!\n"
            int STRING_BASE = 262144;
            push_labels(labels, directive_string, STRING_BASE + adrs_offset_value, STRING_BASE + adrs_offset_value, &dummy_idx, &label_idx, LABEL_STRING);
            int temp_str_i = 0;
            while (temp_str_i < strlen(temp_string)+1) {
                data_segment_output[adrs_offset_value + temp_str_i] = temp_string[temp_str_i];
                temp_str_i++;
            }
            adrs_offset_value = adrs_offset_value + strlen(temp_string)+1;
        } else if (compare_string(instruction_string, ".include")) {
            // ".include "include_file.asm"
            printf(".include detected\n");
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            //push_labels(labels, instruction_string, 0, &input_buf_ptr, &label_idx);
        } else if (compare_string(instruction_string, ".global")) {
            // ".global global_name"
            printf(".global detected\n");
            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
            //push_labels(labels, instruction_string, 0, &input_buf_ptr, &label_idx);
        } else if (check_string_is_non_inst(instruction_string, PARSE_LENGTH)) {
            printf("%s %d\n", &instruction_string, current_address);
            push_labels(labels, instruction_string, 0, current_address, &input_buf_ptr, &label_idx, LABEL_NUMBER);
        }

        // if instruction_string in opcode list, then increment address by 1 (PC indexes instructions by 32-bit words)
        if (check_string_in_strings(NOP_ARR_LENGTH, nop_type_inst, instruction_string) != -1) {
            current_address += 4;
        } else if (check_string_in_strings(R_ARR_LENGTH, r_type_inst, instruction_string) != -1) {
            current_address += 4;
        } else if (check_string_in_strings(I_ARR_LENGTH, i_type_inst, instruction_string) != -1) {
            current_address += 4;
        } else if (check_string_in_strings(J_ARR_LENGTH, j_type_inst, instruction_string) != -1) {
            current_address += 4;
        }
    }
    data_segment_size = adrs_offset_value;


    // second pass (machine code generation and label substitution)

    int reg_a = 0;
    int reg_b = 0;
    int reg_c = 0;
    int imm16 = 0;
    int imm24 = 0;
    

    char whitespace[64] = {' ', ',', '\t', '\n', '\0'}; // always have null-terminating character

    uint32_t *output_array = (int *) malloc(256*1024 * sizeof(uint8_t) + 65536*sizeof(uint8_t));
    printf("Code output array malloc\n");
    if (output_array == NULL) {
        printf("Memory allocation fail!\n");
        exit(1);
    } else {
        printf("Memory allocation successful at %p\n", output_array);
    }
    for (int i = 0; i < 65536; i++) {
        output_array[i] = 0;
    }

    int run = 1;

    input_buf_ptr = 0;
    int parse_string_ptr = 0;

    int inst_type = NONE;

    int opcode = 0x00;
    int inst_shift = 0;
    int code_pointer = 0;
    while(input_buf_ptr < fsize) {
        // read instruction until whitespace
        for (int i = 0; i < PARSE_LENGTH; i++) {
            instruction_string[i] = '\0';
        }
        skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
        grab_string(input_file_buf, fsize, instruction_string, &input_buf_ptr);
        //printf("Instruction: %s\n", instruction_string);
        input_buf_ptr++;
        parse_string_ptr = 0;

        // now decode instruction and grab operands as needed (R-type, I-type and J-type)

        // detect assembler directives and skip line if so
        if (instruction_string[0] == '.') {
            skip_line(input_file_buf, fsize, &input_buf_ptr);
        }

        int instruction_number = 0;
        inst_type = NONE;
        // evaluate instruction type and value
        int i = 0;
        while (inst_type == NONE && i < NOP_ARR_LENGTH) {
            if(compare_string(nop_type_inst[i], instruction_string)) {
                instruction_number = i;
                inst_type = NOP_TYPE;
                break;
            }
            i++;
        }
        i = 0;
        while (inst_type == NONE && i < R_ARR_LENGTH) {
            if(compare_string(r_type_inst[i], instruction_string)) {
                instruction_number = i;
                inst_type = R_TYPE;
                break;
            }
            i++;
        }
        i = 0;
        while (inst_type == NONE && i < I_ARR_LENGTH) {
            if(compare_string(i_type_inst[i], instruction_string)) {
                instruction_number = i;
                inst_type = I_TYPE;
                break;
            }
            i++;
        }
        i = 0;
        while (inst_type == NONE && i < J_ARR_LENGTH) {
            if(compare_string(j_type_inst[i], instruction_string)) {
                instruction_number = i;
                inst_type = J_TYPE;
                break;
            }
            i++;
        }
        if (check_string_is_jmp_label(instruction_string, PARSE_LENGTH)) {
            printf("jmp label detected\n");
        }
        if (inst_type == NONE && !check_string_is_jmp_label(instruction_string, PARSE_LENGTH) && instruction_string[0] != '.' && instruction_string[0] != '\0') {
            printf("Invalid opcode at offset: %d", input_buf_ptr);
            exit(1);
        }

        // now decode operands depending on instruction type (R-type, I-type, J-type)
        switch(inst_type) {
            case (NOP_TYPE): {
                if (compare_string(instruction_string, "halt")) {
                    break;
                }
            }
            case(R_TYPE): {
                if (compare_string(instruction_string, "jr")) {
                    // r0 format
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    grab_string(input_file_buf, fsize, reg_a_string, &input_buf_ptr);
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    inst_shift = 0;
                    reg_a = eval_register(reg_a_string);
                    reg_b = 0;
                    reg_c = 0;
                } else if (compare_string(instruction_string, "mov")) {
                    // r0, r1 format
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    grab_string(input_file_buf, fsize, reg_a_string, &input_buf_ptr);
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    grab_string(input_file_buf, fsize, reg_b_string, &input_buf_ptr);
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    inst_shift = 0;
                    reg_a = eval_register(reg_a_string);
                    reg_b = eval_register(reg_b_string);
                    reg_c = 0;
                } else {
                // r0, r1, r2 format
                skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                grab_string(input_file_buf, fsize, reg_a_string, &input_buf_ptr);
                skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                grab_string(input_file_buf, fsize, reg_b_string, &input_buf_ptr);
                skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                grab_string(input_file_buf, fsize, reg_c_string, &input_buf_ptr);
                skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                inst_shift = 0;
                reg_a = eval_register(reg_a_string);
                reg_b = eval_register(reg_b_string);
                reg_c = eval_register(reg_c_string);
                }
                break;
            }
            case(I_TYPE): {
                if (instruction_number == 4) { // movi
                    // [r1 + offset], r0 format for output
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    if (compare_string(instruction_string, "movi")) {
                        if (input_file_buf[input_buf_ptr] == '[') {
                            printf("bracket detected, memory store instruction\n");
                            input_buf_ptr++; // skip '[' character
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, reg_b_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, offset_math_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, imm16_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, reg_a_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            inst_shift = 1;
                            reg_a = eval_register(reg_a_string);
                            reg_b = eval_register(reg_b_string);
                            imm16 = eval_imm16(imm16_string, labels);
                        } else {
                            // r0, [r1 + offset] format for input
                            printf("non bracket detected, memory load instruction\n");
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, reg_a_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            input_buf_ptr++; // skip '[' character
                            grab_string(input_file_buf, fsize, reg_b_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, offset_math_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, imm16_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            inst_shift = 0;
                            reg_a = eval_register(reg_a_string);
                            reg_b = eval_register(reg_b_string);
                            imm16 = eval_imm16(imm16_string, labels);
                        }
                    }
                }
                if (instruction_number == 5) { // mvbi
                    // [r1 + offset], r0 format for output
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    if (compare_string(instruction_string, "mvbi")) {
                        if (input_file_buf[input_buf_ptr] == '[') {
                            printf("bracket detected, memory store instruction\n");
                            input_buf_ptr++; // skip '[' character
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, reg_b_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, offset_math_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, imm16_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, reg_a_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            inst_shift = 1;
                            reg_a = eval_register(reg_a_string);
                            reg_b = eval_register(reg_b_string);
                            imm16 = eval_imm16(imm16_string, labels);
                        } else {
                            // r0, [r1 + offset] format for input
                            printf("non bracket detected, memory load instruction\n");
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, reg_a_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            input_buf_ptr++; // skip '[' character
                            grab_string(input_file_buf, fsize, reg_b_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, offset_math_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            grab_string(input_file_buf, fsize, imm16_string, &input_buf_ptr);
                            skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                            inst_shift = 0;
                            reg_a = eval_register(reg_a_string);
                            reg_b = eval_register(reg_b_string);
                            imm16 = eval_imm16(imm16_string, labels);
                        }
                    }
                }

                if (instruction_number == 6) { // lui
                    // r0, imm16 format
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    grab_string(input_file_buf, fsize, reg_a_string, &input_buf_ptr);
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    grab_string(input_file_buf, fsize, imm16_string, &input_buf_ptr);
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    inst_shift = 0;
                    reg_a = eval_register(reg_a_string);
                    reg_b = 0;
                    imm16 = eval_imm16(imm16_string, labels);
                    break;
                }

                if (!compare_string(instruction_string, "movi") && !compare_string(instruction_string, "mvbi") || (compare_string(instruction_string, "lui"))) {
                    // r0, r1, imm16 format
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    grab_string(input_file_buf, fsize, reg_a_string, &input_buf_ptr);
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    grab_string(input_file_buf, fsize, reg_b_string, &input_buf_ptr);
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    grab_string(input_file_buf, fsize, imm16_string, &input_buf_ptr);
                    skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                    inst_shift = 0;
                    reg_a = eval_register(reg_a_string);
                    reg_b = eval_register(reg_b_string);
                    imm16 = eval_imm16(imm16_string, labels);
                }

                break;
            }
            case(J_TYPE): {
                // imm24 format
                skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                grab_string(input_file_buf, fsize, imm16_string, &input_buf_ptr);
                skip_whitespace(input_file_buf, fsize, &input_buf_ptr);
                imm16 = eval_imm16(imm16_string, labels);
                break;
            }
        }

        // now write code binary
        // now that opcodes and operands are decoded, construct the final instruction binary value
        // R-type: OOOO OxAA AAAB BBBB CCCC Cxxx xxxx xxxx
        // I-type: OOOO OxAA AAAB BBBB IIII IIII IIII IIII
        // J-type: OOOO Oxxx xxxx xxxx JJJJ JJJJ JJJJ JJJJ
        opcode = eval_opcode(inst_type, instruction_number, inst_shift);
        int machine_code = 0;
        switch(inst_type) {
            case (NOP_TYPE): {
                machine_code = opcode << 27;
                break;
            }
            case(R_TYPE): {
                machine_code = (opcode << 27) + (reg_a << 21) + (reg_b << 16) + (reg_c << 11);
                break;
            }
            case(I_TYPE): {
                machine_code = (opcode << 27) + (reg_a << 21) + (reg_b << 16) + ((uint16_t)imm16);
                break;
            }
            case(J_TYPE): {
                machine_code = (opcode << 27) + (imm16);
                break;
            }
        }
        if (!check_string_is_non_inst(instruction_string, PARSE_LENGTH)) {
            //printf("MACHINE CODE: ");
            //print_binary(machine_code);
            //printf(" Address: %d\n", code_pointer);
            output_array[code_pointer] = (uint32_t)machine_code;
            code_pointer++;
        }
    }

    // now write data binary in 0x04xxxx (data segment)
    const int data_segment = 0x04;
    int data_pointer = 0;
    uint8_t *byte_output_array = (uint8_t *)output_array;
    while (data_pointer < data_segment_size) {
        byte_output_array[(data_segment << 16) + data_pointer] = data_segment_output[data_pointer];
        data_pointer++;
    }





    printf("Finished!\n\n");
    printf("Code segment size: %d bytes\n", (65536*4));
    printf("Code size: %d bytes\n", code_pointer*4);
    printf("Code segment usage: %.2lf%%\n", ((double)code_pointer / (double)(65536))*100);
    printf("\n");

    printf("Data segment size: %d bytes\n", (65536));
    printf("Data size: %d bytes\n", data_pointer);
    printf("Data segment usage: %.2lf%%\n", ((double)data_pointer / (double)(65536))*100);

    // now generate final machine code binary file
    fwrite(output_array, sizeof(uint8_t), 256*1024 + 65536, output_file);

    fclose(input_file);
    fclose(output_file);
    return 0;
}

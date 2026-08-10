/*
C Compiler for ZaC-3, 32-bit CPU with 32-bit address bus.

ZaC-3 supports 1 types of pointer, 32-bit.

NEAR TODO:

- Implement casting node. This would be needed to convert 16-bit into 32-bit immediate integers when adding an immediate to a 32-bit integer variable.
    e.g.
    ...
    int _far long_ptr = buffer_base;
    long_ptr = long_ptr + 5;
    ...

    "5" is 16-bit by default, however "long_ptr" is 32-bit. So the "5" node would need a 32-bit cast before the "5" node.
    * Add
        * long_ptr
        * cast 32-bit
            * 5

- Implement "else" statement, very useful and I keep running into scenarios where I need it in programming C.

- Make far pointers. This would be done by making POINTER_WIDTH variable. So 16-bit pointers are POINTER_WIDTH=16, and 32-bit pointers are POINTER_WIDTH=32.

- (DONE) Make automated testing.

- Later I could add near/far pointers just like 8088/8086/286, but for now everything is "near" by default.

    "int far *x;", x is a far pointer (16-bit).
    "int near *x;", x is a near pointer (32-bit).

    "int near *far *x;", x is a near pointer to a far pointer.
    "int far *near *x;", x is a far pointer to a near pointer.

    The near/far keyword is just an operator immediately before the pointer, just like * or &, and it denotes the range of pointer from 16-bit to 32-bit.
    By default (no near/far keyword), pointers are near, as they are fast. Far pointers are only used if you're using big data structures requiring more than
    64KB outside the data section.

- make a dereference tree for pointer objects, to make dereferencing easier (especially when allocating memory on the stack for function parameters and
    local variables.

    MyVariable: deref -> deref -> int (would be int**).

- (DONE) make conditional expressions return 0 or 1 for condition propagation. a>1 would return 0 if a<=1, or 1 if a>1. however at the moment, conditionals just
    use jumps labels insted of 0,1 checking, which works for single layer expressions (a>1), but not for complicated expressions ((a>1)!=2).
    Each atomic operation (+, -, >, <, !=, ==, etc.) would have its intermediate result stored on the stack. this is done by allocating stack memory
    for each operation. And then each result is used if they are needed later. This is so that (a > 4) || (b < 5) is possible.
        stack + 0 = a > 4
        stack + 1 = b < 5
        stack + 2 = stack + 0 || stack + 1
        return stack + 2
    This would be done just by walking through the math tree and looking for operations, and allocating stack on each operation.

    This can also be done by making a separate stack data structure, and pushing and popping from the operation_stack to evaluate the equation.
    push a
    push 4
    > (pops 4 and a and pushes res1)
    push b
    push 5
    < (pops 5 and b and pushes res2)
    || (pops res2 and res1 and pushes res3)
        res3 is the answer

    Make it a pure stack machine first. And then when that works, then use registers for the "local stack space" and then when it overflows, then use the memory stack.


- make less-than/greater-than ALU instructions
    MIPS has an instruction called "slt" and "slti" which means "set less than" and "set less than immediate".
    This means that you can set a register 0 or 1 depending on the truth of the condition. I suppose this goes in the "logic unit" part of the ALU.
    This is handy because it removes the need for branch instructions to implement less than/greater then/equal to values, which later
    will massively help for pipelining if I were to go that far (reduces the need for branch predicition and removes prediction fail for
    those logical operations '<', '>', '!=', '==', etc.).

    By default, it's signed. This means that it can compare negative and positive values -32768 to 32767.
    Therefore there needs to be an unsigned version called sltu, which does the full range 0 to 65535.


- Make the register file get saved onto the stack before a funtion call (caller-save). This would be done by saving r1 to rX such that X is 
  the register file index used currently in the compiler to save intermediate math results.

- Since the AST_SET AST_GET got changed, this means that function parameters are stored on the register file, rather than the stack.
  I would prefer the parameters get stored on the stack to not overload the registers too much. This means that I will need to have
  different versions of AST_SET and AST_GET depending on register or stack. I might have different enums. AST_SET_REGISTER, AST_GET_REGISTER,
  AST_SET_MEMORY, AST_GET_MEMORY. So function parameters will always use AST_MEMORY and intermediate math results will use AST_REGISTER initially,
  and then when the register file gets full (r20 is maximum I think, everything past is system registers) then it "spills" onto the stack. However
  that's a future thing. For now just keep it explicit register or memory via enum.

FAR TODO:
    - ZaC-3 will be fully 32-bit CPU, and so 32-bit ints, 32-bit pointers, etc. Although it will still use the same backplane, but it will have a different bus protocol.
    32-bit A/D. It will flip-flop 32-bit address and 32-bit data depending on the A/D signal (A/D low = address, A/D high = data). And since this only takes 33 pins
    out of the 40 pins required for full 16-bit data and 24-bit address, then it can work on the existing ZaC-2 16-bit backplane, just reprogram the FPGAs to support
    32-bit A/D bus. This is NOT backwards compatible with 16-bit hardware though. But this isn't an issue because the hardware is FPGA-based, so just reflash it to
    support 32-bit A/D.

PROBLEMS:
    - (FIXED) C compiler breaks after about 200 lines of source code.
        What happens is that the AST gen seems to loop back to the start of the tokenList after finishing with main().
        I think the problem is in the lexer, the lexer is very hacky and "taped together" and i think it needs a proper re-build.
        * The problem was that C by default interpets "\n" as just 0xA, but the actual file had 0xA and 0xD so the file sizes were wrong.
            This was fixed by doing "rb" in fread instead of "r", "rb" is "read binary" which doesn't remove the 0xD from 0xA 0xD.

    - Nested function calls don't work, so printChar(getChar()); doesn't work. you have to go:
        ...
            char temp = getChar();
            printChar(temp);
        ...
    
    - Pointers with more than 1 pointer layer doesn't work, like int **double_ptr;, because the code assumes that after 1 dereference, brings out the
        size of the fully dereferenced object. So *double_ptr will still be expected to be int, not int*. I just need to add a for-loop that cycles through
        dereferencing count, rather than seeing '~*' and assuming it's fully dereferenced. It works for single pointers, but not double pointers.
    
    - (FIXED) Multi-paramter functions don't work yet (only single ones do). 

    - immediate values doesn't work in function (divide(5, 2)), you have to go (divide(a, b)) and make sure a and b have 5 and 2 respectfully.

    - expressions doesn't work on return (return a + b; doesn't work, only return a;).
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <conio.h>
#include <math.h>

#include "stack.h"
#include "Token.h"
//#include "AST_Node.h"
#include "Dictionary.h"
#include "DictionaryPointer.h"
#include "CharAppendList.h"

void pause() {
    printf("Press any key to continue . . .");
    while (!kbhit()) {}
    printf("\n");
}


#define KEYWORDS_SIZE 16
#define SEPARATORS_SIZE 6
#define OPERATORS_SIZE 24
#define WHITE_SPACE_SIZE 3
#define MODIFIERS_SIZE 4
char *KEYWORDS[KEYWORDS_SIZE] = {"void", "int", "char", "uint8_t", "uint16_t", "int8_t", "int16_t", "static", "if", "while", "for", "else", "asm", "struct", "return", "debug"};
char *SEPARATORS[SEPARATORS_SIZE] = {"{", "}", "(", ")", ";", ","};
char *OPERATORS[OPERATORS_SIZE] = {"++", "--", "==", ">=", "<=", "!=", "&&", "<<", ">>", "||", "->", ".", "+", "-", "<", "*", "/", ">", "!", "=", "&", "|", "[", "]"};
char *WHITE_SPACE[WHITE_SPACE_SIZE] = {" ", "\n", "\t"};
char *MODIFIERS[MODIFIERS_SIZE] = {"_io", "_far", "_data", "_code"};

int string_number = 0;

int non_null_compare_string(char *string_a, char *string_b, int *output_char_offset) {
    // check simple equality without need of '\0'
    int i = 0;
    while (string_a[i] == string_b[i]) {
        i++;
    }
    if (string_b[i] == '\0') {
        *output_char_offset = i;
        return 1;
    }
    *output_char_offset = -1;
    return 0;
}

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

int check_string_equals_strings(int strings_arr_length, char **strings, char* string) {
    // checks if string is in string array (strings)
    for (int i = 0; i < strings_arr_length; i++) {
        if (compare_string(strings[i], string)) {
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


int check_letter_is_number(char letter) {
    char alphabet[] = "0123456789";
    for (int i = 0; i < sizeof(alphabet); i++) {
        if (letter == alphabet[i]) {
            return 1;
        }
    }
    return 0;
}

int check_letter_is_alphabet_and_space(char letter) {
    char alphabet[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_ ";
    for (int i = 0; i < sizeof(alphabet); i++) {
        if (letter == alphabet[i]) {
            return 1;
        }
    }
    return 0;
}

int check_letter_is_alphabet(char letter) {
    char alphabet[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";
    for (int i = 0; i < sizeof(alphabet); i++) {
        if (letter == alphabet[i]) {
            return 1;
        }
    }
    return 0;
}

int check_string_is_operator(char *string, int *output_operators_idx, int *output_char_offset) {
    for (int i = 0; i < OPERATORS_SIZE; i++) {
        if (non_null_compare_string(string, OPERATORS[i], output_char_offset)) {
            *output_operators_idx = i;
            return 1;
        }
    }
    *output_operators_idx = -1;
    *output_char_offset = 0;
    return 0;
}

int check_letter_is_not_alphabet(char letter) {
    char alphabet[] = " |!+-~*/(){}[]&.,;=<>\"\'\n\t";
    for (int i = 0; i < sizeof(alphabet); i++) {
        if (letter == alphabet[i]) {
            return 1;
        }
    }
    return 0;
}

int check_letter_is_separator(char letter) {
    char alphabet[] = " \"\'\n\t";
    for (int i = 0; i < sizeof(alphabet); i++) {
        if (letter == alphabet[i]) {
            return 1;
        }
    }
    return 0;
}

void clear_string(int string_size, char *string) {
    for (int i = 0; i < string_size; i++) {
        string[i] = (char)0x00;
    }
}



void set_variable(Token *token_array, AST_Node *current_node) {
    // a = 5 + 2;

    if (token_array->token_type == IDENT) {
        current_node->type = AST_SET_VARIABLE;
    }
}

int getPrecedence (char *operator) {
    // cheap precedence map without using a hashmap
    if (strcmp(operator, "=") == 0) {
        return 0;
    } else if (strcmp(operator, "~*") == 0) {
        return 4;
    } else if (strcmp(operator, "~&") == 0) {
        return 4;
    } else if (strcmp(operator, "==") == 0) {
        return 4;
    } else if (strcmp(operator, "<=") == 0) {
        return 4;
    } else if (strcmp(operator, ">=") == 0) {
        return 4;
    } else if (strcmp(operator, "<") == 0) {
        return 4;
    } else if (strcmp(operator, ">") == 0) {
        return 4;
    } else if (strcmp(operator, "<<") == 0) {
        return 1;
    } else if (strcmp(operator, ">>") == 0) {
        return 1;
    } else if (strcmp(operator, "!=") == 0) {
        return 0;
    } else if (strcmp(operator, "^") == 0) {
        return 1;
    } else if (strcmp(operator, "-") == 0) {
        return 2;
    } else if (strcmp(operator, "+") == 0) {
        return 2;
    } else if (strcmp(operator, "*") == 0) {
        return 3;
    } else if (strcmp(operator, "/") == 0) {
        return 3;
    } else if (strcmp(operator, "&") == 0) {
        return 1;
    } else if (strcmp(operator, "&&") == 0) {
        return 1;
    } else if (strcmp(operator, "|") == 0) {
        return 1;
    } else if (strcmp(operator, "||") == 0) {
        return 1;
    } else if (strcmp(operator, "(") == 0 || strcmp(operator, ")") == 0) {
        return -2;
    } else {
        printf("Invalid operator!\n");
        exit(1);
    }
}


TokenList *convertInfixToPrefix(TokenList *localTokenList) {
    // converts infix notation to prefix notation
    // input tokenList
    // output res
    TokenList tokenStack;
    TokenListInit(&tokenStack, 0);

    TokenList outputTokenList;
    TokenListInit(&outputTokenList, 0);

    // TODO: first check for balanced brackets to avoid infinite loops

    // main stack loop
    // TODO: Algorithm still needs finishing

    // now process the expression as raw variables, numbers and operators
    int tokenListSize = localTokenList->getSize(localTokenList);
    for (int i = tokenListSize - 1; i >= 0; i--) {
        Token currentToken = localTokenList->getItem(localTokenList, i);
        if (currentToken.token_type == IDENT || currentToken.token_type == LITERAL || currentToken.token_type == TOKEN_FUNCTION || currentToken.token_type == STRING) {
            outputTokenList.push(&outputTokenList, currentToken);
        }
        if (currentToken.token_string[0] == ')') {
            tokenStack.push(&tokenStack, currentToken);
        } else if (currentToken.token_string[0] == '(') {
            while (tokenStack.isNotEmpty(&tokenStack) && tokenStack.peek(&tokenStack).token_string[0] != ')') {
                outputTokenList.push(&outputTokenList, tokenStack.pop(&tokenStack));
            }
            if (tokenStack.isNotEmpty(&tokenStack)) {
                tokenStack.pop(&tokenStack); // pop off last bracket
            }
        } else if (currentToken.token_type == OPERATOR && currentToken.token_subtype == TOKEN_DEREFERENCE) {
            tokenStack.push(&tokenStack, currentToken);
        } else if (currentToken.token_type == OPERATOR && currentToken.token_subtype == TOKEN_REFERENCE) {
            tokenStack.push(&tokenStack, currentToken);
        } else if (currentToken.token_type == OPERATOR) {
            while (tokenStack.isNotEmpty(&tokenStack) && (getPrecedence(currentToken.token_string) < getPrecedence(tokenStack.peek(&tokenStack).token_string))) {
                outputTokenList.push(&outputTokenList, tokenStack.pop(&tokenStack));
            }
            tokenStack.push(&tokenStack, currentToken);
        }
        
    }
    // now pop everything off from the stack in to the output list
    while (tokenStack.isNotEmpty(&tokenStack)) {
        outputTokenList.push(&outputTokenList, tokenStack.pop(&tokenStack));
    }
    printf("Prefix notation: ");
    // now reverse the output string
    TokenList *outputReverseTokenList = malloc(sizeof(TokenList)); // create the output object
    TokenListInit(outputReverseTokenList, 0);
    while (outputTokenList.isNotEmpty(&outputTokenList)) {
        outputReverseTokenList->push(outputReverseTokenList, outputTokenList.pop(&outputTokenList));
        printf("%s ", outputReverseTokenList->peek(outputReverseTokenList).token_string);
    }

    printf("\n");
    tokenStack.destroy(&tokenStack);
    outputTokenList.destroy(&outputTokenList);
    return outputReverseTokenList;
}

AST_Node *createTreeAux(TokenList *localTokenList, int *token_list_idx, AST_Node *current_node) {
    //printf("%s ", localTokenList->getItem(localTokenList, *token_list_idx).token_string);
    if (*token_list_idx > localTokenList->getSize(localTokenList)) {
        printf("Expression syntax tree error!\n");
        exit(1);
    }
    if (localTokenList->getItem(localTokenList, *token_list_idx).token_type == TOKEN_OPERATOR && localTokenList->getItem(localTokenList, *token_list_idx).token_subtype == TOKEN_DEREFERENCE) {
        // operators have 2 child nodes: A and B operands (i.e. a+b)
        current_node->ast_string = localTokenList->getStringReference(localTokenList, *token_list_idx);
        AST_Node *operand_a = generate_ast_node();
        *token_list_idx += 1;
        operand_a = createTreeAux(localTokenList, token_list_idx, operand_a);
        current_node->append(current_node, operand_a);
        current_node->type = AST_OPERATOR;
        current_node->subtype = AST_DEREFERENCE;
        return current_node;
    } else if (localTokenList->getItem(localTokenList, *token_list_idx).token_type == TOKEN_OPERATOR && localTokenList->getItem(localTokenList, *token_list_idx).token_subtype == TOKEN_REFERENCE) {
        // operators have 2 child nodes: A and B operands (i.e. a+b)
        current_node->ast_string = localTokenList->getStringReference(localTokenList, *token_list_idx);
        AST_Node *operand_a = generate_ast_node();
        *token_list_idx += 1;
        operand_a = createTreeAux(localTokenList, token_list_idx, operand_a);
        current_node->append(current_node, operand_a);
        current_node->type = AST_OPERATOR;
        current_node->subtype = AST_REFERENCE;
        return current_node;
    } else if (localTokenList->getItem(localTokenList, *token_list_idx).token_type == TOKEN_OPERATOR) {
        // operators have 2 child nodes: A and B operands (i.e. a+b)
        AST_Node *operand_a = generate_ast_node();
        AST_Node *operand_b = generate_ast_node();
        current_node->ast_string = localTokenList->getStringReference(localTokenList, *token_list_idx);
        *token_list_idx += 1;
        operand_a = createTreeAux(localTokenList, token_list_idx, operand_a);
        *token_list_idx += 1;
        operand_b = createTreeAux(localTokenList, token_list_idx, operand_b);
        current_node->append(current_node, operand_a);
        current_node->append(current_node, operand_b);
        current_node->type = AST_OPERATOR;
        current_node->subtype = AST_MATH;
        
        return current_node;
    } else if (localTokenList->getItem(localTokenList, *token_list_idx).token_type == TOKEN_IDENT) {
        // variable name
        AST_Node *ast_ident = generate_ast_node();
        ast_ident->type = AST_IDENT;
        ast_ident->ast_string = localTokenList->getStringReference(localTokenList, *token_list_idx);
        return ast_ident;
    } else if (localTokenList->getItem(localTokenList, *token_list_idx).token_type == TOKEN_STRING) {
        // variable name
        AST_Node *ast_ident = generate_ast_node();
        ast_ident->type = AST_STRING;
        ast_ident->ast_string = localTokenList->getStringReference(localTokenList, *token_list_idx);
        sprintf(ast_ident->ast_string_name, "string_%d", string_number++);
        ast_ident->visibility = AST_STATIC;
        return ast_ident;
    } else if (localTokenList->getItem(localTokenList, *token_list_idx).token_type == TOKEN_LITERAL) {
        // literal name (immediate number)
        AST_Node *ast_literal = generate_ast_node();
        ast_literal->type = AST_LITERAL;
        ast_literal->ast_string = localTokenList->getStringReference(localTokenList, *token_list_idx);
        //ast_literal->visibility = AST_NONE_VISIBILITY;
        return ast_literal;
    } else if (localTokenList->getItem(localTokenList, *token_list_idx).token_type == TOKEN_FUNCTION) {
        return localTokenList->getItem(localTokenList, *token_list_idx).function_tree;
    } else {
        printf("Invalid Token expression tree error!\n");
        exit(1);
    }
}

AST_Node *createTree(TokenList *localTokenList) {
    AST_Node *startNode = generate_ast_node();
    int TokenList_idx = 0;
    return createTreeAux(localTokenList, &TokenList_idx, startNode);
}



AST_Node *expression(TokenList *localTokenList, AST_Node *current_node) {
    // Just to pure math expressions at first "x + (y + 5);"
    // returns the AST_Node tree for the token expression

    // first pre-process functions and parameters
    // pre-process the expressions in parameters, make the trees and then link them up later

    if (localTokenList->getSize(localTokenList) == 0) {
        // if zero size, then return void expression
        AST_Node *void_return = generate_ast_node();
        void_return->type = AST_VOID;
        return void_return;
    }

    int tokenListSize = localTokenList->getSize(localTokenList);
    int i = 0;
    
    while (i < tokenListSize) {
        if (localTokenList->getItem(localTokenList, i).token_type == IDENT) {
            if (localTokenList->getSize(localTokenList) - i > 1) {
                if (localTokenList->getItem(localTokenList, i+1).token_string[0] == '(') {
                    printf("Function parameter expression: ");
                    int function_i_start = i;
                    // function call
                    AST_Node *function_node = generate_ast_node();
                    function_node->type = AST_FUNCTION_CALL;
                    function_node->subtype = AST_NOSUBTYPE;
                    function_node->ast_string = &localTokenList->getItemReference(localTokenList, i)->token_string[0];
                    AST_Node *params = generate_ast_node();
                    params->type = AST_CALL_PARAMS;
                    params->subtype = AST_NOSUBTYPE;
                    int bracket_count = 1;
                    i += 2;
                    TokenList *paramTokenList = generateTokenList();
                    while (bracket_count > 0) {
                        if (localTokenList->getItem(localTokenList, i).token_string[0] == '(') {
                            bracket_count++;
                        }
                        if (localTokenList->getItem(localTokenList, i).token_string[0] == ')') {
                            bracket_count--;
                        }
                        if (localTokenList->getItem(localTokenList, i).token_string[0] == ',' && bracket_count == 1) {
                            printf("\n");
                            
                            AST_Node *param = expression(paramTokenList, param);
                            printf("Function parameter expression: ");
                            params->append(params, param);
                            //paramTokenList->destroy(paramTokenList);
                            paramTokenList = generateTokenList();
                        }
                        else if (bracket_count > 0) {
                            if (localTokenList->getItem(localTokenList, i).token_type != MODIFIER) {
                                paramTokenList->append(paramTokenList, localTokenList->getItem(localTokenList, i));
                                printf("%s ", localTokenList->getItem(localTokenList, i).token_string);
                            }
                        }
                        localTokenList->getItemReference(localTokenList, i)->token_type = INVALID;
                        i++;
                    }
                    printf("\n");
                    AST_Node *param = expression(paramTokenList, param);
                    params->append(params, param);
                    function_node->append(function_node, params);
                    localTokenList->getItemReference(localTokenList, function_i_start)->function_tree_valid = 1;
                    localTokenList->getItemReference(localTokenList, function_i_start)->function_tree = function_node;
                    localTokenList->getItemReference(localTokenList, function_i_start)->token_type = TOKEN_FUNCTION;
                }
            }
        }
        i++;
    }
    
    TokenList *prefixList = convertInfixToPrefix(localTokenList);
    // the prefix is still in token representation, now build the AST tree

    AST_Node *outputTree = generate_ast_node();

    // the createTree function will replace function calls with the function parameter trees evaluated earlier
    outputTree = createTree(prefixList);

    
    return outputTree;
}

int statement(TokenList *tokenList, int tokenList_idx, AST_Node *current_node, int visibility);

int declaration(TokenList *tokenList, int tokenList_idx, AST_Node *current_node, int visibility) {
    // token parser / AST generator
    // inputs: tokenList
    // outputs: global tokenList index

    // int a = 5 + 2;

    // int _io *io_ptr;


    int local_idx = tokenList_idx;

    CharAppendList *param_array = generateCharAppendList();

    if (tokenList->getItem(tokenList, tokenList_idx).token_valid == 0) {
        printf("Token NotValid error!\n");
        exit(1);
    }

    // declaration
    if (tokenList->getItem(tokenList, local_idx+2).token_string[0] == '(') {
        // function declaration
        // function has two nodes
        // Node(0) = param tree
        // Node(1) = function body
        AST_Node *AST_params = generate_ast_node();
        AST_params->type = AST_PARAMS;
        Token *endOfLineToken = malloc(sizeof(Token));
        endOfLineToken->token_valid = 1;
        endOfLineToken->token_type = SEPARATOR;
        endOfLineToken->token_string[0] = ';';
        endOfLineToken->token_subtype = TOKEN_NOSUBTYPE;
        while (1) {
            local_idx++;
            if (tokenList->getItem(tokenList, local_idx+2).token_string[0] == ')') {
                local_idx++;
                local_idx++;
                break;
            }
            TokenList *ParamList = generateTokenList(); // generate token list for parameters and then evaluate declaration
            printf("Function parameter: ");
            while (tokenList->getItem(tokenList, local_idx+2).token_string[0] != ',' && tokenList->getItem(tokenList, local_idx+2).token_string[0] != ')') {
                ParamList->append(ParamList, tokenList->getItem(tokenList, local_idx+2));
                printf("%s ", tokenList->getItem(tokenList, local_idx+2).token_string);
                local_idx++;
            }
            if (tokenList->getItem(tokenList, local_idx+2).token_string[0] == ')') {
                local_idx--;
            }
            ParamList->append(ParamList, tokenList->getItem(tokenList, local_idx+2));
            ParamList->append(ParamList, *endOfLineToken);
            printf("\n");
            AST_Node *AST_param = generate_ast_node();
            statement(ParamList, 0, AST_param, 0);
            AST_params->append(AST_params, AST_param->getItem(AST_param, 0));
            //ParamList->destroy(ParamList);
        }
        
        local_idx++;
        TokenList tokenList_func_body;
        TokenListInit(&tokenList_func_body, 0);
        AST_Node *AST_function = generate_ast_node();
        AST_Node *AST_statement = generate_ast_node();
        
        AST_function->type = AST_FUNCTION;
        AST_function->subtype = AST_NOSUBTYPE;
        AST_statement->type = AST_BODY;
        AST_statement->subtype = AST_NOSUBTYPE;
        int body_i = local_idx;
        int if_brace_balance = 0;
        if (tokenList->getItem(tokenList, body_i).token_string[0] == '{') {
                if_brace_balance = 1;
                body_i++;
            } else {
                printf("Expected '{'\n");
                exit(1);
            }
        while (body_i < tokenList->getSize(tokenList) && if_brace_balance > 0) {
            if (tokenList->getItem(tokenList, body_i).token_string[0] == '}') {
                if_brace_balance--;
            } else if (tokenList->getItem(tokenList, body_i).token_string[0] == '{') {
                if_brace_balance++;
            }
            
            if (if_brace_balance > 0) {
                printf("%s ", tokenList->getStringReference(tokenList, body_i));
                tokenList_func_body.append(&tokenList_func_body, tokenList->getItem(tokenList, body_i));
            }
            body_i++;
        }
        if (if_brace_balance != 0 && body_i == tokenList->getSize(tokenList)) {
            printf("Expected '}'\n");
            exit(1);
        }
        int if_body_idx = 0;
        int iter = 0;
        while (iter < 10000 && if_body_idx < tokenList_func_body.getSize(&tokenList_func_body)) {
            if_body_idx = statement(&tokenList_func_body, if_body_idx, AST_statement, AST_NONE_VISIBILITY);
            iter++;
        }
        AST_function->append(AST_function, AST_params);
        AST_function->append(AST_function, AST_statement);
        current_node->type = AST_FUNCTION_DECLARATION;
        current_node->subtype = AST_NOSUBTYPE;
        
        AST_function->ast_string = tokenList->getStringReference(tokenList, tokenList_idx+1);
        current_node->append(current_node, AST_function);
        current_node->ast_string = tokenList->getStringReference(tokenList, tokenList_idx);
        current_node->token_value = tokenList->getItem(tokenList, tokenList_idx).token_value;
        local_idx = body_i;
        printf("\n");
    } else if (tokenList->getItem(tokenList, tokenList_idx).token_type == KEYWORD) {
        current_node->token_value = tokenList->getItem(tokenList, tokenList_idx).token_value;
        current_node->modifier = tokenList->getItem(tokenList, tokenList_idx).token_modifier;
        if (tokenList->getItem(tokenList, tokenList_idx).token_value == INT || tokenList->getItem(tokenList, tokenList_idx).token_value == CHAR) {    
            AST_Node *nextNode = current_node;
            int declare_idx = local_idx;
            local_idx++;
            int is_pointer = 0;
            while (1) {
                if (strcmp(tokenList->getStringReference(tokenList, local_idx), "~*") == 0) {
                    is_pointer = 1;
                    char *nextNode_string = (char *)malloc(2*sizeof(char));
                    nextNode_string[0] = '~';
                    nextNode_string[1] = '*';
                    nextNode_string[2] = (char)0x00;
                    nextNode->append(nextNode, generate_ast_node());
                    nextNode = nextNode->getItem(nextNode, 0);
                    nextNode->type = AST_OPERATOR;
                    nextNode->subtype = AST_DEREFERENCE;
                    nextNode->ast_string = nextNode_string;
                    local_idx++;
                } else if (tokenList->getItemReference(tokenList, local_idx)->token_type == MODIFIER) {
                    // modifier token (_near, _far, _i/o, _code)
                    char *nextNode_string = (char *)malloc(2*sizeof(char));
                    nextNode->append(nextNode, generate_ast_node());
                    nextNode = nextNode->getItem(nextNode, 0);
                    nextNode->type = AST_MODIFIER;
                    nextNode->subtype = AST_NOSUBTYPE;
                    nextNode->modifier = tokenList->getItemReference(tokenList, local_idx)->token_modifier;
                    nextNode->ast_string = tokenList->getStringReference(tokenList, local_idx);
                    local_idx++;
                }
                else {
                    break;
                }
            }
            if (is_pointer == 0) {
                nextNode = current_node;
                AST_Node *last_node = generate_ast_node();
                last_node->type = AST_IDENT;
                last_node->ast_string = (tokenList->getStringReference(tokenList, tokenList_idx+1));
                current_node->ast_string = (tokenList->getStringReference(tokenList, tokenList_idx));
                current_node->type = AST_DECLARATION;
                
                if (visibility == AST_STATIC) {
                    last_node->visibility = AST_STATIC;
                } else if (visibility == AST_LOCAL) {
                    last_node->visibility = AST_LOCAL;
                } else {
                    last_node->visibility = AST_NONE_VISIBILITY;
                }
                current_node->append(current_node, last_node);
            } else if (is_pointer == 1) {
                //nextNode->ast_string = tokenList->getStringReference(tokenList, tokenList_idx+1);
                AST_Node *last_node = generate_ast_node();
                last_node->type = AST_IDENT;
                last_node->subtype = AST_NOSUBTYPE;
                last_node->ast_string = (tokenList->getStringReference(tokenList, local_idx));
                current_node->ast_string = (tokenList->getStringReference(tokenList, declare_idx));
                current_node->type = AST_DECLARATION;
                
                if (visibility == AST_STATIC) {
                    last_node->visibility = AST_STATIC;
                } else if (visibility == AST_LOCAL) {
                    last_node->visibility = AST_LOCAL;
                } else {
                    last_node->visibility = AST_NONE_VISIBILITY;
                }
                nextNode->append(nextNode, last_node);
            } else {
                printf("declaration ast error\n");
                exit(1);
            }
        } else {
            printf("Invalid declaration datatype\n");
            exit(1);
        }
        local_idx += 1;
    }

    if (local_idx < tokenList->getSize(tokenList)) {
        if (strcmp(tokenList->getItem(tokenList, local_idx).token_string, "=") == 0) {
            printf("DeclareVariable expression: ");
            // declaration with variable set
            // now create local token list
            TokenList inputExpressionList;
            TokenListInit(&inputExpressionList, 0);
            // now create expession until ";" character
            int i = tokenList_idx+1;
            while (tokenList->getItem(tokenList, i).token_string[0] != ';') { // create local expression list
                printf("%s", tokenList->getItem(tokenList, i).token_string);
                inputExpressionList.append(&inputExpressionList, tokenList->getItem(tokenList, i));
                i++;
            }
            printf("\n");
            AST_Node *variableValue = generate_ast_node();
            variableValue = expression(&inputExpressionList, current_node->getItem(current_node, 0));
            current_node->append(current_node, variableValue);
            local_idx = i;
        }
    }
    return local_idx;
}


int checkTokenDeclareType(Token current_token) {
    if (strcmp(current_token.token_string, "int") == 0) {
        return 1;
    } else if (strcmp(current_token.token_string, "char") == 0) {
        return 1;
    } else if (strcmp(current_token.token_string, "uint8_t") == 0) {
        return 1;
    } else if (strcmp(current_token.token_string, "uint16_t") == 0) {
        return 1;
    } else if (strcmp(current_token.token_string, "void") == 0) {
        return 1;
    } else {
        return 0;
    }
}

int checkCompareOperator(Token current_token) {
    if (strcmp(current_token.token_string, "=") == 0) {
        return 1;
    } else if (strcmp(current_token.token_string, "==") == 0) {
        return 1;
    } else if (strcmp(current_token.token_string, "<") == 0) {
        return 1;
    } else if (strcmp(current_token.token_string, ">") == 0) {
        return 1;
    } else if (strcmp(current_token.token_string, "!=") == 0) {
        return 1;
    } else if (strcmp(current_token.token_string, "<=") == 0) {
        return 1;
    } else if (strcmp(current_token.token_string, ">=") == 0) {
        return 1;
    } else {
        return 0;
    }
}

int statement(TokenList *tokenList, int tokenList_idx, AST_Node *current_node, int visibility) {
    Token current_token = tokenList->getItem(tokenList, tokenList_idx);
    if (current_token.token_string[0] == ';') {
        return tokenList_idx + 1;
    }
    // returns local_idx
    int local_idx = tokenList_idx;
    int j = 0;

    #define TOKEN_ARRAY_SIZE 50
    if (current_token.token_valid == 0) {
        printf("Token NotValid Error!\n");
        exit(1);
    }

    if (tokenList->getItem(tokenList, tokenList_idx).token_value == STATIC) {
        AST_Node *ast_declaration_node = generate_ast_node();
        ast_declaration_node->type = AST_DECLARATION;
        current_node->append(current_node, ast_declaration_node);
        local_idx = declaration(tokenList, tokenList_idx+1, ast_declaration_node, AST_STATIC);
    } else if (current_token.token_type == KEYWORD) {
        if (checkTokenDeclareType(current_token)) {
            // declaration
            // "int x = 5;"
            
            // DELCARATION (or DECLARATION SET VARIABLE) INSTRUCTION NODE
            // Create DECLARATION NODE first
            // node(0) = Variable to declare
            // node(1) = Expression (optional)
            AST_Node *ast_declaration_node = generate_ast_node();
            ast_declaration_node->type = AST_DECLARATION;
            current_node->append(current_node, ast_declaration_node);
            local_idx = declaration(tokenList, tokenList_idx, ast_declaration_node, AST_LOCAL);
        } else if (strcmp(current_token.token_string, "if") == 0) {
            printf("if statement: ");
            // the condition in the if statement takes two expressions, and then compares them via the compare operator (==, <, >, <=, >=, !=)
            local_idx += 2; // skip the '(' of the if statement
            int bracket_count = 1;
            // if ({codition}) { {statement} }
            // if statement has 2 children. Node(0) = condition expression, Node(2) = statement body
            
            TokenList token_operand_a;
            TokenListInit(&token_operand_a, 0);

            // wait until compare operator
            while (!checkCompareOperator(tokenList->getItem(tokenList, local_idx))) {
                token_operand_a.append(&token_operand_a, tokenList->getItem(tokenList, local_idx));
                
                if (tokenList->getItem(tokenList, local_idx).token_string[0] == '(') {
                    bracket_count++;
                } else if (tokenList->getItem(tokenList, local_idx).token_string[0] == ')') {
                    bracket_count--;
                }
                local_idx++;
            }
            // now count ')' brackets until it equals '(' brackets to check for operand_b
            while (bracket_count > 0) {
                token_operand_a.append(&token_operand_a, tokenList->getItem(tokenList, local_idx));
                local_idx++;
                if (tokenList->getItem(tokenList, local_idx).token_string[0] == ')') {
                    bracket_count--;
                } else if (tokenList->getItem(tokenList, local_idx).token_string[0] == '(') {
                    bracket_count++;
                }
            }
            for (int i = 0; i < token_operand_a.getSize(&token_operand_a); i++) {
                printf("%s ", token_operand_a.getItem(&token_operand_a, i).token_string);
            }
            local_idx++;
            printf("\n");
            // now we have the 2 operand token lists ready to be evaluated as an expression
            AST_Node *AST_if_node = generate_ast_node();
            AST_Node *AST_if_condition = generate_ast_node();
            AST_Node *AST_statement = generate_ast_node();
            AST_statement->type = AST_BODY;
            AST_if_node->type = AST_IF;
            AST_if_condition = expression(&token_operand_a, AST_if_condition);
            AST_if_node->append(AST_if_node, AST_if_condition);

            // now parse the statement body
            TokenList tokenList_if_body;
            TokenListInit(&tokenList_if_body, 0);
            int body_i = local_idx;
            int if_brace_balance = 0;
            if (tokenList->getItem(tokenList, body_i).token_string[0] == '{') {
                if_brace_balance = 1;
                body_i++;
            } else {
                printf("Expected '{'\n");
                exit(1);
            }
            while (body_i < tokenList->getSize(tokenList) && if_brace_balance > 0) {
                if (tokenList->getItem(tokenList, body_i).token_string[0] == '}') {
                    if_brace_balance--;
                } else if (tokenList->getItem(tokenList, body_i).token_string[0] == '{') {
                    if_brace_balance++;
                }
                
                if (if_brace_balance > 0) {
                    printf("%s ", tokenList->getStringReference(tokenList, body_i));
                    tokenList_if_body.append(&tokenList_if_body, tokenList->getItem(tokenList, body_i));
                }
                body_i++;
            }
            if (if_brace_balance != 0 && body_i == tokenList->getSize(tokenList)) {
                printf("Expected '}'\n");
                exit(1);
            }
            int if_body_idx = 0;
            int iter = 0;
            while (iter < 10000 && if_body_idx < tokenList_if_body.getSize(&tokenList_if_body)) {
                if_body_idx = statement(&tokenList_if_body, if_body_idx, AST_statement, AST_NONE_VISIBILITY);
                iter++;
            }
            AST_if_node->append(AST_if_node, AST_statement);
            current_node->append(current_node, AST_if_node);
            local_idx = body_i;
            printf("\n");
        } else if (strcmp(current_token.token_string, "while") == 0) {
            printf("while\n");
            // the condition in the if statement takes two expressions, and then compares them via the compare operator (==, <, >, <=, >=, !=)
            local_idx += 2; // skip the '(' of the if statement
            int bracket_count = 1;
            // if ({codition}) { {statement} }
            // if statement has 2 children. Node(0) = condition expression, Node(2) = statement body
            
            TokenList token_operand_a;
            TokenListInit(&token_operand_a, 0);

            // wait until compare operator
            while (!checkCompareOperator(tokenList->getItem(tokenList, local_idx))) {
                token_operand_a.append(&token_operand_a, tokenList->getItem(tokenList, local_idx));
                
                if (tokenList->getItem(tokenList, local_idx).token_string[0] == '(') {
                    bracket_count++;
                } else if (tokenList->getItem(tokenList, local_idx).token_string[0] == ')') {
                    bracket_count--;
                }
                local_idx++;
            }
            // now count ')' brackets until it equals '(' brackets to check for operand_b
            while (bracket_count > 0) {
                token_operand_a.append(&token_operand_a, tokenList->getItem(tokenList, local_idx));
                local_idx++;
                if (tokenList->getItem(tokenList, local_idx).token_string[0] == ')') {
                    bracket_count--;
                } else if (tokenList->getItem(tokenList, local_idx).token_string[0] == '(') {
                    bracket_count++;
                }
            }
            for (int i = 0; i < token_operand_a.getSize(&token_operand_a); i++) {
                printf("%s ", token_operand_a.getItem(&token_operand_a, i).token_string);
            }
            local_idx++;
            printf("\n");
            // now we have the 2 operand token lists ready to be evaluated as an expression
            AST_Node *AST_if_node = generate_ast_node();
            AST_Node *AST_if_condition = generate_ast_node();
            AST_Node *AST_statement = generate_ast_node();
            AST_statement->type = AST_BODY;
            AST_if_node->type = AST_WHILE;
            AST_if_condition = expression(&token_operand_a, AST_if_condition);
            AST_if_node->append(AST_if_node, AST_if_condition);

            // now parse the statement body
            TokenList tokenList_if_body;
            TokenListInit(&tokenList_if_body, 0);
            int body_i = local_idx;
            int if_brace_balance = 0;
            if (tokenList->getItem(tokenList, body_i).token_string[0] == '{') {
                if_brace_balance = 1;
                body_i++;
            } else {
                printf("Expected '{'\n");
                exit(1);
            }
            while (body_i < tokenList->getSize(tokenList) && if_brace_balance > 0) {
                if (tokenList->getItem(tokenList, body_i).token_string[0] == '}') {
                    if_brace_balance--;
                } else if (tokenList->getItem(tokenList, body_i).token_string[0] == '{') {
                    if_brace_balance++;
                }
                
                if (if_brace_balance > 0) {
                    printf("%s ", tokenList->getStringReference(tokenList, body_i));
                    tokenList_if_body.append(&tokenList_if_body, tokenList->getItem(tokenList, body_i));
                }
                body_i++;
            }
            if (if_brace_balance != 0 && body_i == tokenList->getSize(tokenList)) {
                printf("Expected '}'\n");
                exit(1);
            }
            int if_body_idx = 0;
            int iter = 0;
            while (iter < 10000 && if_body_idx < tokenList_if_body.getSize(&tokenList_if_body)) {
                if_body_idx = statement(&tokenList_if_body, if_body_idx, AST_statement, AST_NONE_VISIBILITY);
                iter++;
            }
            AST_if_node->append(AST_if_node, AST_statement);
            current_node->append(current_node, AST_if_node);
            local_idx = body_i;
        } else if (strcmp(current_token.token_string, "for") == 0) {
            printf("for\n");
            // the condition in the if statement takes two expressions, and then compares them via the compare operator (==, <, >, <=, >=, !=)
            local_idx += 2; // skip the '(' of the if statement
            int bracket_count = 1;
            // for ({init; condition; iter}) { {statement} }
            // for statement has 4 children. Node(0) = condition init, Node(2) = condition expression, Node(3) = condition iter, Node(4) = statement body
            
            TokenList token_operands[3] = {0};
            for (int i = 0; i < 3; i++) {
                TokenListInit(&token_operands[i], 0);
            }

            // wait until compare operator
            while (!checkCompareOperator(tokenList->getItem(tokenList, local_idx))) {
                token_operands[0].append(&token_operands[0], tokenList->getItem(tokenList, local_idx));
                
                if (tokenList->getItem(tokenList, local_idx).token_string[0] == '(') {
                    bracket_count++;
                } else if (tokenList->getItem(tokenList, local_idx).token_string[0] == ')') {
                    bracket_count--;
                }
                local_idx++;
            }
            // now count ')' brackets until it equals '(' brackets to check for operand_b
            int current_for_operand = 0;
            while (bracket_count > 0) {
                if (tokenList->getItem(tokenList, local_idx).token_string[0] == ';') {
                    if (current_for_operand == 0) {
                        token_operands[current_for_operand].append(&token_operands[current_for_operand], tokenList->getItem(tokenList, local_idx));
                    }
                    current_for_operand++;
                    local_idx++;
                }
                token_operands[current_for_operand].append(&token_operands[current_for_operand], tokenList->getItem(tokenList, local_idx));
                local_idx++;
                if (tokenList->getItem(tokenList, local_idx).token_string[0] == ')') {
                    bracket_count--;
                } else if (tokenList->getItem(tokenList, local_idx).token_string[0] == '(') {
                    bracket_count++;
                }
            }
            printf("for init: ");
            for (int i = 0; i < token_operands[0].getSize(&token_operands[0]); i++) {
                printf("%s ", token_operands[0].getItem(&token_operands[0], i).token_string);
            }
            printf("\nfor condition: ");
            for (int i = 0; i < token_operands[1].getSize(&token_operands[1]); i++) {
                printf("%s ", token_operands[1].getItem(&token_operands[1], i).token_string);
            }
            printf("\nfor iter: ");
            for (int i = 0; i < token_operands[2].getSize(&token_operands[2]); i++) {
                printf("%s ", token_operands[2].getItem(&token_operands[2], i).token_string);
            }
            printf("\n");
            local_idx++;
            printf("\n");
            // now we have the 2 operand token lists ready to be evaluated as an expression
            AST_Node *AST_for_node = generate_ast_node();
            AST_Node *AST_for_init = generate_ast_node();
            AST_Node *AST_for_condition = generate_ast_node();
            AST_Node *AST_for_iter = generate_ast_node();
            AST_Node *AST_statement = generate_ast_node();
            AST_statement->type = AST_BODY;
            AST_for_node->type = AST_FOR;
            statement(&token_operands[0], 0, AST_for_init, AST_NONE_VISIBILITY);
            AST_for_condition = expression(&token_operands[1], AST_for_condition);
            AST_for_iter = expression(&token_operands[2], AST_for_iter);
            AST_for_init = AST_for_init->getItem(AST_for_init, 0);
            AST_for_node->append(AST_for_node, AST_for_init);
            AST_for_node->append(AST_for_node, AST_for_condition);
            AST_for_node->append(AST_for_node, AST_for_iter);

            // now parse the statement body
            TokenList tokenList_if_body;
            TokenListInit(&tokenList_if_body, 0);
            int body_i = local_idx;
            int if_brace_balance = 0;
            if (tokenList->getItem(tokenList, body_i).token_string[0] == '{') {
                if_brace_balance = 1;
                body_i++;
            } else {
                printf("Expected '{'\n");
                exit(1);
            }
            while (body_i < tokenList->getSize(tokenList) && if_brace_balance > 0) {
                if (tokenList->getItem(tokenList, body_i).token_string[0] == '}') {
                    if_brace_balance--;
                } else if (tokenList->getItem(tokenList, body_i).token_string[0] == '{') {
                    if_brace_balance++;
                }
                
                if (if_brace_balance > 0) {
                    printf("%s ", tokenList->getStringReference(tokenList, body_i));
                    tokenList_if_body.append(&tokenList_if_body, tokenList->getItem(tokenList, body_i));
                }
                body_i++;
            }
            if (if_brace_balance != 0 && body_i == tokenList->getSize(tokenList)) {
                printf("Expected '}'\n");
                exit(1);
            }
            int if_body_idx = 0;
            int iter = 0;
            while (iter < 10000 && if_body_idx < tokenList_if_body.getSize(&tokenList_if_body)) {
                if_body_idx = statement(&tokenList_if_body, if_body_idx, AST_statement, AST_NONE_VISIBILITY);
                iter++;
            }
            AST_for_node->append(AST_for_node, AST_statement);
            current_node->append(current_node, AST_for_node);
            local_idx = body_i;
        } else if (strcmp(current_token.token_string, "return") == 0) {
            printf("return\n");
            AST_Node *AST_statement = generate_ast_node();
            AST_statement->type = AST_RETURN;
            AST_statement->subtype = AST_NOSUBTYPE;
            
            TokenList token_operands;
            TokenListInit(&token_operands, 0);
            local_idx++;
            while (tokenList->getItem(tokenList, local_idx).token_string[0] != ';') {
                token_operands.append(&token_operands, tokenList->getItem(tokenList, local_idx));
                local_idx++;
            }
            for (int i = 0; i < token_operands.getSize(&token_operands); i++) {
                printf("%s ", token_operands.getItem(&token_operands, i).token_string);
            }
            AST_Node *AST_return_operand = generate_ast_node();
            AST_return_operand = expression(&token_operands, AST_return_operand);
            AST_statement->append(AST_statement, AST_return_operand);
            current_node->append(current_node, AST_statement);
            local_idx++;
        } else if (strcmp(current_token.token_string, "in") == 0) {
            
        } else if (strcmp(current_token.token_string, "out") == 0) {
            
        }
    } else if (current_token.token_type == IDENT && tokenList->getItem(tokenList, tokenList_idx+1).token_string[0] == '(') {
        // function call
        TokenList inputExpressionList;
        TokenListInit(&inputExpressionList, 0);
        // now create expession until ";" character
        int i = tokenList_idx;
        printf("FunctionCall expression: ");
        while (tokenList->getItem(tokenList, i).token_string[0] != ';') { // create local expression list
            printf("%s", tokenList->getItem(tokenList, i).token_string);
            inputExpressionList.append(&inputExpressionList, tokenList->getItem(tokenList, i));
            i++;
        }
        AST_Node *variableValue = generate_ast_node();
        variableValue = expression(&inputExpressionList, current_node);
        current_node->append(current_node, variableValue);
        local_idx = i;
    } else if (current_token.token_type == IDENT || (current_token.token_type == OPERATOR && current_token.token_subtype == TOKEN_DEREFERENCE)) {  
        // set variable
        // x = x + 1;
        // SET VARIABLE INSTRUCTION NODE
        // node(0) = Variable to set
        // node(1) = Expression

        //#warning "TODO: SET VARIABLE/IDENT in initial statement"

        AST_Node setVariableNode;
        AST_Node_init(&setVariableNode);
        // setVariableNode
        // node(0) = Variable to set
        // node(1) = Expression
        
        
        setVariableNode.purpose = INSTRUCTION;
        setVariableNode.type = AST_SET_VARIABLE;

        // node(0)


        // node(1)
        // skip over '=' into expression tokens
        TokenList inputExpressionList;
        TokenListInit(&inputExpressionList, 0);
        // now create expession until ";" character
        int i = tokenList_idx;
        printf("SetVariable expression: ");
        while (tokenList->getItem(tokenList, i).token_string[0] != ';') { // create local expression list
            printf("%s", tokenList->getItem(tokenList, i).token_string);
            inputExpressionList.append(&inputExpressionList, tokenList->getItem(tokenList, i));
            i++;
        }
        printf("\n");
        AST_Node *ast_set_variable = generate_ast_node();
        ast_set_variable->type = AST_SET_VARIABLE;
        
        AST_Node *variableValue = generate_ast_node();
        variableValue = expression(&inputExpressionList, current_node);
        variableValue->purpose = DATA;
        ast_set_variable->append(ast_set_variable, variableValue);
        current_node->append(current_node, ast_set_variable);
        local_idx = i;
    } else if (current_token.token_type == STRING) {
        local_idx++;
    } else {
        // expression
        // "x + 5;"
        printf("Syntax error\n");
        
        TokenList inputExpressionList;
        TokenListInit(&inputExpressionList, 0);
        // now create expession until ";" character
        int i = 0;
        printf("expression: ");
        while (tokenList->getItem(tokenList, i).token_string[0] != ';') { // create local expression list
            printf("%s", tokenList->getItem(tokenList, i).token_string);
            inputExpressionList.append(&inputExpressionList, tokenList->getItem(tokenList, i));
            i++;
        }
        printf("\n");
        AST_Node *variableValue = generate_ast_node();
        variableValue = expression(&inputExpressionList, current_node->getItem(current_node, 0));
        current_node->append(current_node, variableValue);
        local_idx += i;
        exit(1);
    }

    return local_idx;
}

void print_AST_type(FILE *file, AST_Node *node) {
    
    if (node->type == AST_DECLARATION) {
        fprintf(file, "Declaration");
        fprintf(file, " %s", node->ast_string);
    } else if (node->type == AST_EXPRESSION) {
        fprintf(file, "Expression");
    } else if (node->type == AST_SET_VARIABLE) {
        fprintf(file, "SetVariable");
    } else if (node->type == AST_IDENT) {
        fprintf(file, "Identifier");
        fprintf(file, " %s", node->ast_string);
    } else if (node->type == AST_OPERATOR) {
        fprintf(file, "Operator");
        fprintf(file, " %s", node->ast_string);
    } else if (node->type == AST_LITERAL) {
        fprintf(file, "Literal");
        fprintf(file, " %s", node->ast_string);
    } else if (node->type == AST_LITERAL_32) {
        fprintf(file, "Literal32");
        fprintf(file, " %s", node->ast_string);
    } else if (node->type == AST_IDENT_32) {
        fprintf(file, "Ident32");
        fprintf(file, " %s", node->ast_string);
    } else if (node->type == AST_OPERATOR_32) {
        fprintf(file, "Operator32");
        fprintf(file, " %s", node->ast_string);
    } else if (node->type == AST_SET_VARIABLE_32) {
        fprintf(file, "SetVariable32");
        fprintf(file, " %s", node->ast_string);
    } else if (node->type == AST_MAIN) {
        fprintf(file, "Main");
    } else if (node->type == AST_FUNCTION) {
        fprintf(file, "Function");
        fprintf(file, " %s", node->ast_string);
    } else if (node->type == AST_FUNCTION_CALL) {
        fprintf(file, "FunctionCall");
        fprintf(file, " %s", node->ast_string);
    } else if (node->type == AST_IF) {
        fprintf(file, "If");
    } else if (node->type == AST_WHILE) {
        fprintf(file, "While");
    } else if (node->type == AST_FOR) {
        fprintf(file, "For");
    } else if (node->type == AST_BODY) {
        fprintf(file, "Body");
    } else if (node->type == AST_PARAMS) {
        fprintf(file, "Parameters");
    } else if (node->type == AST_CALL_PARAMS) {
        fprintf(file, "CallParameters");
    } else if (node->type == AST_FUNCTION_DECLARATION) {
        fprintf(file, "FunctionDeclaration");
        fprintf(file, " %s", node->ast_string);
    } else if (node->type == AST_RETURN) {
        fprintf(file, "Return");
    } else if (node->type == AST_VOID) {
        fprintf(file, "Void");
    } else if (node->type == AST_STRING) {
        fprintf(file, "String ");
        fprintf(file, "%s: ", node->ast_string_name);
        fprintf(file, "\"%s\"", node->ast_string);
    } else if (node->type == AST_MODIFIER) {
        fprintf(file, "Modifier ");
    }
    if (node->subtype == AST_DEREFERENCE) {
        fprintf(file, " Dereference");
    } else if (node->subtype == AST_REFERENCE) {
        fprintf(file, " Reference");
    }
    if (node->visibility == AST_STATIC) {
        fprintf(file, " Static");
    } else if (node->visibility == AST_LOCAL) {
        fprintf(file, " Local");
    }
    if (node->modifier == AST_IO) {
        fprintf(file, " I/O");
    }
    if (node->modifier == AST_NEAR) {
        fprintf(file, " near");
    }
    if (node->modifier == AST_FAR) {
        fprintf(file, " far");
    }
    if (node->modifier == AST_CODE) {
        fprintf(file, " code");
    }
    if (node->modifier == AST_DATA) {
        fprintf(file, " data");
    }
    if (node->type == AST_CAST) {
        fprintf(file, " Cast");
    }
}

void print_AST_tree_aux(FILE *file, AST_Node *node, int tab_level) {
    for (int i = 0; i < tab_level; i++) {
        fprintf(file, "\t");
    }
    fprintf(file, "* ");
    print_AST_type(file, node);
    
    fprintf(file, "\n");
    for (int i = 0; i < node->getSize(node); i++) {
        print_AST_tree_aux(file, node->getItem(node, i), tab_level + 1);
    }
}

void print_AST_tree(AST_Node *node) {
    FILE *file = fopen("AST_log.txt", "w");
    fprintf(file, "\n");
    print_AST_tree_aux(file, node, 0);
    fprintf(file, "* End\n");
    fclose(file);
}


void asm_generator_symbol_table_call_params(AST_Node *current_node, Dictionary **symbol_tables, DictionaryPointer *pointer_symbol_table, int *stack, int *heap, char *current_function) {
    if (current_node->type != AST_DECLARATION) {
        if (current_node->type == AST_MAIN) {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table_call_params(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
        } else if (current_node->type == AST_FUNCTION_DECLARATION) {
            asm_generator_symbol_table_call_params(current_node->getItem(current_node, 0), symbol_tables, pointer_symbol_table, stack, heap, current_function);
        } else if (current_node->type == AST_FUNCTION) {
            //*stack = 2;
            printf("Function %s:\n", current_node->ast_string);
            current_function = current_node->ast_string;
            int *dummy_stack = 0;
            asm_generator_symbol_table(current_node->getItem(current_node, 1), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            asm_generator_symbol_table_call_params(current_node->getItem(current_node, 0), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            
            
            
            symbol_tables[2]->set(symbol_tables[2], *stack, current_node->ast_string);
            printf("function size: %d\n", symbol_tables[2]->get(symbol_tables[2], current_node->ast_string));
            printf("\n");
            return;
        } else if (current_node->type == AST_BODY) {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table_call_params(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
        } else if (current_node->type == AST_PARAMS) {
            int param_stack = *stack;
            //if (current_node->getSize(current_node) > 0) {
            //    param_stack = (current_node->getSize(current_node)*2);
            //}
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table_call_params(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, &param_stack, heap, current_function);
            }
        } else if (current_node->type == AST_IDENT) {
            char *var_string = calloc(100, sizeof(char));
            sprintf(var_string, "%s_%s", current_function, current_node->ast_string);
            current_node->ast_string = var_string;
            printf("changed identifier \"%s\"\n", current_node->ast_string);
        } else {
            // walk the AST-tree DFS syle and find variable declarations
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table_call_params(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
        }
    } else if (current_node->type == AST_DECLARATION) {
        AST_Node *declare_node = current_node->getItem(current_node, 0);
        int modifier = 0;
        char pointer_layer_string[100] = {0};
        int pointer_layer = 0;

        AST_Node *tail_node = current_node;

        while (tail_node->type != AST_IDENT) {
            if (tail_node->getItem(tail_node, 0)->modifier == IO) {
                modifier = IO;
            } else if (tail_node->getItem(tail_node, 0)->modifier == FAR) {
                modifier = FAR;
            } else if (tail_node->getItem(tail_node, 0)->modifier == MODIFIER_DATA) {
                modifier = MODIFIER_DATA;
            }
            if (strcmp(tail_node->ast_string, "~*") == 0) {
                pointer_layer_string[pointer_layer] = '*';
                pointer_layer++;
            }
            tail_node = tail_node->getItem(tail_node, 0);
        }
        declare_node = tail_node;
        char *var_string = calloc(100, sizeof(char));
        sprintf(var_string, "%s", declare_node->ast_string);
        int datatype_size = 0;
        int dereferenced_var_size = 0;
        if (pointer_layer > 0) {
            // pointers always have datatype size of 2 bytes
            datatype_size = 4;
        }
        if (current_node->token_value == INT) {
            // int datatype has 2 bytes
            dereferenced_var_size = 4;
        } else if (current_node->token_value == CHAR) {
            dereferenced_var_size = 1;
        }
        if (declare_node->visibility == AST_LOCAL) {
            const int call_overhead = 4;
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table_call_params(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
            printf("Call Parameters local variable \"%s\" set offset: %d, type: %s%s, pointer size: %d, dereferenced size: %d, modifier: %d\n", declare_node->ast_string, *stack+call_overhead, current_node->ast_string, pointer_layer_string, datatype_size, dereferenced_var_size, modifier);
            symbol_tables[0]->set(symbol_tables[0], *stack+call_overhead, declare_node->ast_string);
            symbol_tables[3]->set(symbol_tables[3], AST_LOCAL, declare_node->ast_string);
            symbol_tables[4]->set(symbol_tables[4], current_node->token_value, declare_node->ast_string);
            symbol_tables[5]->set(symbol_tables[5], datatype_size, declare_node->ast_string);
            symbol_tables[6]->set(symbol_tables[6], pointer_layer, declare_node->ast_string);
            symbol_tables[7]->set(symbol_tables[7], dereferenced_var_size, declare_node->ast_string);
            symbol_tables[8]->set(symbol_tables[8], modifier, declare_node->ast_string);
            *stack += 4;
        }
        else if (declare_node->visibility == AST_STATIC) {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table_call_params(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
            printf("Call Parameters static variable \"%s\" set offset: %d, type: %s%s, pointer size: %d, dereferenced size: %d, modifier: %d\n", declare_node->ast_string, *heap, current_node->ast_string, pointer_layer_string, datatype_size, dereferenced_var_size, modifier);
            symbol_tables[1]->set(symbol_tables[1], *heap, declare_node->ast_string);
            symbol_tables[3]->set(symbol_tables[3], AST_STATIC, declare_node->ast_string);
            symbol_tables[4]->set(symbol_tables[4], current_node->token_value, declare_node->ast_string);
            symbol_tables[5]->set(symbol_tables[5], datatype_size, declare_node->ast_string);
            symbol_tables[6]->set(symbol_tables[6], pointer_layer, declare_node->ast_string);
            symbol_tables[7]->set(symbol_tables[7], dereferenced_var_size, declare_node->ast_string);
            symbol_tables[8]->set(symbol_tables[8], modifier, declare_node->ast_string);
            *heap += 4;
        }
    }
}

void asm_generator_symbol_table(AST_Node *current_node, Dictionary **symbol_tables, DictionaryPointer *pointer_symbol_table, int *stack, int *heap, char *current_function) {
    if (current_node->type != AST_DECLARATION) {
        if (current_node->type == AST_MAIN) {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
        } else if (current_node->type == AST_FUNCTION_DECLARATION) {
            *stack = 0;
            asm_generator_symbol_table_call_params(current_node->getItem(current_node, 0), symbol_tables, pointer_symbol_table, stack, heap, current_function);
        } else if (current_node->type == AST_FUNCTION) {
            *stack = 0;
            printf("Function %s:\n", current_node->ast_string);
            current_function = current_node->ast_string;
            
            asm_generator_symbol_table_call_params(current_node->getItem(current_node, 1), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            asm_generator_symbol_table_call_params(current_node->getItem(current_node, 0), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            symbol_tables[2]->set(symbol_tables[2], *stack, current_node->ast_string);
            printf("size: %d\n", symbol_tables[2]->get(symbol_tables[2], current_node->ast_string));
            printf("\n");
            return;
        } else if (current_node->type == AST_BODY) {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
        } else if (current_node->type == AST_PARAMS) {
            int param_stack = 0;
            if (current_node->getSize(current_node) > 0) {
                param_stack = -(current_node->getSize(current_node)*2);
            }
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table_call_params(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, &param_stack, heap, current_function);
            }
        } else if (current_node->type == AST_CALL_PARAMS) {
            int param_stack = 0;
            if (current_node->getSize(current_node) > 0) {
                param_stack = -(current_node->getSize(current_node)*2);
            }
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table_call_params(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, &param_stack, heap, current_function);
            }
        } else if (current_node->type == AST_IDENT) {
            char *var_string = calloc(100, sizeof(char));
            sprintf(var_string, "%s_%s", current_function, current_node->ast_string);
            current_node->ast_string = var_string;
            printf("changed identifier \"%s\"\n", current_node->ast_string);
        } else {
            // walk the AST-tree DFS syle and find variable declarations
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
        }
    } else if (current_node->type == AST_DECLARATION) {
        AST_Node *declare_node = current_node->getItem(current_node, 0);
        int modifier = 0;
        char pointer_layer_string[100] = {0};
        int pointer_layer = 0;

        AST_Node *tail_node = current_node;

        while (tail_node->type != AST_IDENT) {
            if (tail_node->getItem(tail_node, 0)->modifier == IO) {
                modifier = IO;
            } else if (tail_node->getItem(tail_node, 0)->modifier == FAR) {
                modifier = FAR;
            } else if (tail_node->getItem(tail_node, 0)->modifier == MODIFIER_DATA) {
                modifier = MODIFIER_DATA;
            }
            if (strcmp(tail_node->ast_string, "~*") == 0) {
                pointer_layer_string[pointer_layer] = '*';
                pointer_layer++;
            }
            tail_node = tail_node->getItem(tail_node, 0);
        }
        declare_node = tail_node;
        char *var_string = calloc(100, sizeof(char));
        sprintf(var_string, "%s", declare_node->ast_string);
        int datatype_size = 0;
        int dereferenced_var_size = 0;
        if (pointer_layer > 0) {
            // pointers always have datatype size of 4 bytes
            datatype_size = 4;
        }
        if (current_node->token_value == INT) {
            // int datatype has 4 bytes
            dereferenced_var_size = 4;
        } else if (current_node->token_value == CHAR) {
            dereferenced_var_size = 1;
        }
        if (declare_node->visibility == AST_LOCAL) {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
            printf("local variable \"%s\" set offset: %d, type: %s%s, pointer size: %d, dereferenced size: %d, modifier: %d\n", declare_node->ast_string, *stack, current_node->ast_string, pointer_layer_string, datatype_size, dereferenced_var_size, modifier);
            symbol_tables[0]->set(symbol_tables[0], *stack, declare_node->ast_string);
            symbol_tables[3]->set(symbol_tables[3], AST_LOCAL, declare_node->ast_string);
            symbol_tables[4]->set(symbol_tables[4], current_node->token_value, declare_node->ast_string);
            symbol_tables[5]->set(symbol_tables[5], datatype_size, declare_node->ast_string);
            symbol_tables[6]->set(symbol_tables[6], pointer_layer, declare_node->ast_string);
            symbol_tables[7]->set(symbol_tables[7], dereferenced_var_size, declare_node->ast_string);
            symbol_tables[8]->set(symbol_tables[8], modifier, declare_node->ast_string);
            *stack += 4;
        }
        else if (declare_node->visibility == AST_STATIC) {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
            printf("static variable \"%s\" set offset: %d, type: %s%s, pointer size: %d, dereferenced size: %d, modifier: %d\n", declare_node->ast_string, *heap, current_node->ast_string, pointer_layer_string, datatype_size, dereferenced_var_size, modifier);
            symbol_tables[1]->set(symbol_tables[1], *heap, declare_node->ast_string);
            symbol_tables[3]->set(symbol_tables[3], AST_STATIC, declare_node->ast_string);
            symbol_tables[4]->set(symbol_tables[4], current_node->token_value, declare_node->ast_string);
            symbol_tables[5]->set(symbol_tables[5], datatype_size, declare_node->ast_string);
            symbol_tables[6]->set(symbol_tables[6], pointer_layer, declare_node->ast_string);
            symbol_tables[7]->set(symbol_tables[7], dereferenced_var_size, declare_node->ast_string);
            symbol_tables[8]->set(symbol_tables[8], modifier, declare_node->ast_string);
            *heap += 4;
        }
    }
}



enum asm_gen {
    ASM_NONE,
    ASM_SET,
    ASM_GET,
    ASM_SET_MEMORY,
    ASM_GET_MEMORY
};


typedef struct ExtraStuff {
    int operator_stack_offset;
} ExtraStuff;

void asm_generator_code_gen(AST_Node *current_node, CharAppendList *asm_list, Dictionary **symbol_tables, DictionaryPointer *pointer_symbol_table, int *stack, int status, int *jmp_label, int register_select, int *pointer_layer_dereference, int *ast_modifier, int *visibility, char *current_function, ExtraStuff *extra_stuff) {
    /*
    r0 = zero constant
    r1,r2 = register a
    r3,r4 = register b
    r5,r6 = result register
    function parameters and local variables are stored on the stack
    the stack grows downwards from 0xffff to 0x0000
    */
    if (current_node->type == AST_MAIN || current_node->type == AST_BODY) {
        if (current_node->type == AST_MAIN) {
            // setup registers
            /*asm_list->append(asm_list, "lui r0, 4\n");
            asm_list->append(asm_list, "lui r1, 4\n");
            asm_list->append(asm_list, "lui r2, 4\n");
            asm_list->append(asm_list, "lui r3, 4\n");
            asm_list->append(asm_list, "lui r4, 4\n");
            asm_list->append(asm_list, "lui r5, 4\n");
            asm_list->append(asm_list, "lui r6, 4\n");
            asm_list->append(asm_list, "lui r7, 4\n");*/
            asm_list->append(asm_list, "lui fp, 18\n");
            asm_list->append(asm_list, "addi sp, r0, 65532\n");
            asm_list->append(asm_list, "lui sp, 18\n");
            asm_list->append(asm_list, "addi ssp, r0, 65532\n");
            asm_list->append(asm_list, "lui ssp, 17\n");
            asm_list->append(asm_list, "lui dp, 4\n");
            asm_list->append(asm_list, "lui io, 19\n\n");
            
            
            asm_list->append(asm_list, "jmp _main\n\n");
            current_node->ast_string = "_main";
        } else if (current_node->type == AST_FUNCTION) {
            char buffer[300] = {0};
            sprintf(buffer, "%s:\n", current_node->ast_string);
            asm_list->append(asm_list, buffer);
        }
        for (int i = 0; i < current_node->getSize(current_node); i++) {
            asm_generator_code_gen(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_list->append(asm_list, "\n");
        }
    } else if (current_node->type == AST_DECLARATION) {
        char buffer[300] = {0};
        // check for pointer or non-pointer declaration
        AST_Node *nextNode;
        nextNode = current_node;
        int is_pointer = 0;
        while (nextNode->getSize(nextNode) > 0) {
            nextNode = nextNode->getItem(nextNode, 0);
            if (nextNode->ast_string[0] == '*') {
                is_pointer = 1;
            }
        }
        *ast_modifier = current_node->modifier;
        AST_Node *recursive_node = current_node;
        while (recursive_node->type != AST_IDENT) {
            recursive_node = recursive_node->getItem(recursive_node, 0);
        }
        if (recursive_node->visibility == AST_STATIC) {
            if (is_pointer) {
                sprintf(buffer, ".word %s_ptr = 0\n", recursive_node->ast_string);
            } else {
                sprintf(buffer, ".word %s = 0\n", recursive_node->ast_string);
            }
            asm_list->append(asm_list, buffer);
        } else if (current_node->getItem(current_node, 0)->visibility == AST_LOCAL) {
            if (is_pointer) {
                //sprintf(buffer, "addi sp, sp, -2\n");
            } else {
                //sprintf(buffer, "addi sp, sp, -2\n");
            }
        }
        // SetVariable in Declaration
        if (current_node->getSize(current_node) == 2) {
            //asm_generator_code_gen(current_node->getItem(current_node, 1), asm_list, symbol_tables, pointer_symbol_table, stack+1, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
            current_node = current_node->getItem(current_node, 1);
            if (strcmp(current_node->ast_string, "=") == 0) {
                AST_Node *node_a = current_node;
                while (node_a->type != AST_IDENT) {
                    node_a = node_a->getItem(node_a, 0);
                }
                CharAppendList *operand_a = generateCharAppendList();
                CharAppendList *operand_b = generateCharAppendList();
                asm_generator_code_gen(node_a, operand_a, symbol_tables, pointer_symbol_table, stack, ASM_SET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                
                asm_list->append(asm_list, operand_b->array);
                asm_list->append(asm_list, operand_a->array);
            }
        }
        
    } else if (current_node->type == AST_SET_VARIABLE) {
        asm_generator_code_gen(current_node->getItem(current_node, 0), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
    } else if (current_node->type == AST_OPERATOR && current_node->subtype == AST_MATH) {
        if (strcmp(current_node->ast_string, "=") == 0) {
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_SET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            
            
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operand_a->array);
        } else if (strcmp(current_node->ast_string, "<") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            extra_stuff->operator_stack_offset += -2;
            sprintf(buffer, "sub r1, r%d, r%d\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset+1);
            sprintf(buffer+strlen(buffer), "jc %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "jz %d_false\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 0\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;

            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
            extra_stuff->operator_stack_offset += 1;
        } else if (strcmp(current_node->ast_string, ">") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            extra_stuff->operator_stack_offset += -2;
            sprintf(buffer, "sub r1, r%d, r%d\n", extra_stuff->operator_stack_offset+1, extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jc %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "jz %d_false\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 0\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;

            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
            extra_stuff->operator_stack_offset += 1;
        } else if (strcmp(current_node->ast_string, "==") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            extra_stuff->operator_stack_offset += -2;
            sprintf(buffer, "sub r1, r%d, r%d\n", extra_stuff->operator_stack_offset+1, extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jz %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 0\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;

            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
            extra_stuff->operator_stack_offset += 1;
        } else if (strcmp(current_node->ast_string, "!=") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            extra_stuff->operator_stack_offset += -2;
            sprintf(buffer, "sub r1, r%d, r%d\n", extra_stuff->operator_stack_offset+1, extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jz %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 0\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;
            
            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
            extra_stuff->operator_stack_offset += 1;
        } else {
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            int operand_a_pointer_dereference = 0;
            int operand_b_pointer_dereference = 0;
            int *new_modifier_a = malloc(1*sizeof(int));
            int *new_modifier_b = malloc(1*sizeof(int));
            *new_modifier_a = AST_NO_MODIFIER;
            *new_modifier_b = AST_NO_MODIFIER;
            int *operand_a_modifier = new_modifier_a;
            int *operand_b_modifier = new_modifier_b;
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, &operand_a_pointer_dereference, operand_a_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, &operand_b_pointer_dereference, operand_b_modifier, visibility, current_function, extra_stuff);

            if (*operand_a_modifier != AST_NO_MODIFIER) { // sets final pointer modifier if adding a modified pointer with an integer
                *ast_modifier = *operand_a_modifier;
                printf("Set operator pointer modifier\n");
            }
            if (*operand_b_modifier != AST_NO_MODIFIER) {
                *ast_modifier = *operand_b_modifier;
                printf("Set operator pointer modifier\n");
            }
            free(new_modifier_a);
            free(new_modifier_b);


            int operand_a_pointer_layer = 0;
            int operand_b_pointer_layer = 0;

            if (current_node->getItem(current_node, 0)->type == AST_IDENT) {
                operand_a_pointer_layer = symbol_tables[6]->get(symbol_tables[6], current_node->getItem(current_node, 0)->ast_string) - operand_a_pointer_dereference;
            }
            if (current_node->getItem(current_node, 1)->type == AST_IDENT) {
                operand_b_pointer_layer = symbol_tables[6]->get(symbol_tables[6], current_node->getItem(current_node, 1)->ast_string) - operand_b_pointer_dereference;
            }

            int pointer_arithmetic_shift_amount = 0;

            if (operand_a_pointer_layer == 1) {
                // pointer arithmetic (single layer)
                if (strcmp(current_node->ast_string, "+") == 0) { // add
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    pointer_arithmetic_shift_amount = ceil(log2(symbol_tables[7]->get(symbol_tables[7], current_node->getItem(current_node, 0)->ast_string))); // scale by datatype size
                    if (pointer_arithmetic_shift_amount > 0) {
                        sprintf(buffer+strlen(buffer), "sli r2, r2, %d\n", pointer_arithmetic_shift_amount);
                    }
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "add r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;ADD_POINTER\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "-") == 0) { // subtract
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    pointer_arithmetic_shift_amount = ceil(log2(symbol_tables[7]->get(symbol_tables[7], current_node->getItem(current_node, 0)->ast_string))); // scale by datatype size
                    if (pointer_arithmetic_shift_amount > 0) {
                        sprintf(buffer+strlen(buffer), "sli r2, r2, %d\n", pointer_arithmetic_shift_amount);
                    }
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "add r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "sub r%d, r0, r1 ;SUBTRACT_POINTER\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else {
                    printf("Invalid pointer operator\n");
                    exit(1);
                }
            } else {
                if (strcmp(current_node->ast_string, "+") == 0) { // add
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "add r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;ADD\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "-") == 0) { // subtract
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "sub r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;SUB\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "&") == 0) { // bitwise and
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "and r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;BITWISE_AND\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "&&") == 0) { // logical and
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "and r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;LOGICAL_AND\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "|") == 0) { // bitwise or
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "or r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;LOGICAL_OR\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "||") == 0) { // logical or
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "or r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;LOGICAL_OR\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "<<") == 0) { // left shift
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "sl r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;LEFT_SHIFT\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, ">>") == 0) { // right shift
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "sr r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;RIGHT_SHIFT\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else {
                    printf("Invalid operator\n");
                    exit(1);
                }
            }
            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
        }
    } else if (current_node->type == AST_OPERATOR && current_node->subtype == AST_DEREFERENCE) {
        #define STACK_BASE 0x0010
        #define STATIC_BASE 0x0004
        #define IO_BASE 0x0013
        CharAppendList *operand = generateCharAppendList();
        asm_generator_code_gen(current_node->getItem(current_node, 0), operand, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, 7, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, operand->array); // assume result stored in r1
        char buffer[300] = {0};
        int modifier = *ast_modifier;
        AST_Node *tail_node = current_node;
        while (tail_node->type != AST_IDENT) {
            tail_node = tail_node->getItem(tail_node, 0);
        }
        /*if (modifier == NO_MODIFIER || current_node->subtype != AST_DEREFERENCE) {
            if (*visibility == AST_LOCAL) {
                sprintf(buffer, "addi i1, r0, %d\n", STACK_BASE); // use 32-bit index register to point anywhere in memory
            } else if (*visibility == AST_STATIC) {
                sprintf(buffer, "addi i1, r0, %d\n", STATIC_BASE); // use 32-bit index register to point anywhere in memory
            } else {
                printf("Invalid visibility\n");
                exit(1);
            }
        } else if (modifier == IO) {
            sprintf(buffer, "addi i1, r0, %d\n", IO_BASE);
        } else if (modifier == MODIFIER_DATA) {
            sprintf(buffer, "addi i1, r0, %d\n", STATIC_BASE);
        }*/
        //extra_stuff->operator_stack_offset += -1;
        //sprintf(buffer+strlen(buffer), "mov i0, r%d\n", extra_stuff->operator_stack_offset);
        /*
        if (symbol_tables[6].get(&symbol_tables[6], tail_node->ast_string) > 1) {
            // setting pointer (always 16-bit for now)
            if (status == ASM_GET) {
                if (symbol_tables[3].get(&symbol_tables[3], tail_node->ast_string) == AST_LOCAL) {
                    sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], tail_node->ast_string));
                } else {
                    sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, tail_node->ast_string);
                }
            } else if (status == ASM_SET) {
                if (symbol_tables[3].get(&symbol_tables[3], tail_node->ast_string) == AST_LOCAL) {
                    sprintf(buffer, "movi [sp + %d], r%i\n", symbol_tables[0].get(&symbol_tables[0], tail_node->ast_string), register_select);
                } else {
                    sprintf(buffer, "movi [dp + %s], r%i\n", tail_node->ast_string, register_select);
                }
            }
        } else {*/
         
            if (status == ASM_GET) {
                if (symbol_tables[4]->get(symbol_tables[4], tail_node->ast_string) == CHAR) {
                    sprintf(buffer+strlen(buffer), "mvbi r%d, [r%d + 0] ;GET\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset-1);
                    extra_stuff->operator_stack_offset += 1;
                } else {
                    sprintf(buffer+strlen(buffer), "movi r%d, [r%d + 0] ;GET\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset-1);
                    extra_stuff->operator_stack_offset += 1;
                }
            } else if (status == ASM_GET_MEMORY) {
                if (symbol_tables[4]->get(symbol_tables[4], tail_node->ast_string) == CHAR) {
                    sprintf(buffer+strlen(buffer), "mvbi r%d, [r%d + 0] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset-1);
                    extra_stuff->operator_stack_offset += 1;
                } else {
                    sprintf(buffer+strlen(buffer), "movi r%d, [r%d + 0] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset-1);
                    extra_stuff->operator_stack_offset += 1;
                }
            } else if (status == ASM_SET) {
                if (symbol_tables[4]->get(symbol_tables[4], tail_node->ast_string) == CHAR) {
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "mvbi [r%d + 0], r%d ;SET\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset-1);
                } else {
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "movi [r%d + 0], r%d ;SET\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset-1);
                }
            }
            extra_stuff->operator_stack_offset -= 1;
        //}
        asm_list->append(asm_list, buffer);
        *pointer_layer_dereference--;
    } else if (current_node->type == AST_OPERATOR && current_node->subtype == AST_REFERENCE) {
        #define STACK_BASE 0x0010
        CharAppendList *operand = generateCharAppendList();
        asm_generator_code_gen(current_node->getItem(current_node, 0), operand, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, operand->array); // assume result stored in r1
        char buffer[300] = {0};
        //sprintf(buffer, "addi i1, r0, %d\n", STACK_BASE); // use 32-bit index register to point anywhere in memory
        //sprintf(buffer+strlen(buffer), "mov i0, r1\n");
        if (status == ASM_GET) {
            sprintf(buffer+strlen(buffer), "addi r1, r0, %d\n", symbol_tables[0]->get(symbol_tables[0], current_node->getItem(current_node, 0)->ast_string), register_select);
        } else if (status == ASM_SET) {
            printf("Reference syntax error\n");
            exit(1);
            sprintf(buffer+strlen(buffer), "movi [i0 + 0], r1\n");
        }
        asm_list->append(asm_list, buffer);
        *pointer_layer_dereference++;
    } else if (current_node->type == AST_OPERATOR_32 && current_node->subtype == AST_MATH) {
        if (strcmp(current_node->ast_string, "=") == 0) {
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_SET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            
            
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operand_a->array);
        } else if (strcmp(current_node->ast_string, "<") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            extra_stuff->operator_stack_offset += -2;
            sprintf(buffer, "sub r1, r%d, r%d\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset+1);
            sprintf(buffer+strlen(buffer), "jc %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "jz %d_false\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 0\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;

            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
            extra_stuff->operator_stack_offset += 1;
        } else if (strcmp(current_node->ast_string, ">") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            extra_stuff->operator_stack_offset += -2;
            sprintf(buffer, "sub r1, r%d, r%d\n", extra_stuff->operator_stack_offset+1, extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jc %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "jz %d_false\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 0\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;

            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
            extra_stuff->operator_stack_offset += 1;
        } else if (strcmp(current_node->ast_string, "==") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            extra_stuff->operator_stack_offset += -2;
            sprintf(buffer, "sub r1, r%d, r%d\n", extra_stuff->operator_stack_offset+1, extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jz %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 0\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;

            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
            extra_stuff->operator_stack_offset += 1;
        } else if (strcmp(current_node->ast_string, "!=") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            extra_stuff->operator_stack_offset += -2;
            sprintf(buffer, "sub r1, r%d, r%d\n", extra_stuff->operator_stack_offset+1, extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jz %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 0\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;
            
            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
            extra_stuff->operator_stack_offset += 1;
        } else {
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            int operand_a_pointer_dereference = 0;
            int operand_b_pointer_dereference = 0;
            int *new_modifier_a = malloc(1*sizeof(int));
            int *new_modifier_b = malloc(1*sizeof(int));
            *new_modifier_a = AST_NO_MODIFIER;
            *new_modifier_b = AST_NO_MODIFIER;
            int *operand_a_modifier = new_modifier_a;
            int *operand_b_modifier = new_modifier_b;
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, &operand_a_pointer_dereference, operand_a_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, &operand_b_pointer_dereference, operand_b_modifier, visibility, current_function, extra_stuff);

            if (*operand_a_modifier != AST_NO_MODIFIER) { // sets final pointer modifier if adding a modified pointer with an integer
                *ast_modifier = *operand_a_modifier;
                printf("Set operator pointer modifier\n");
            }
            if (*operand_b_modifier != AST_NO_MODIFIER) {
                *ast_modifier = *operand_b_modifier;
                printf("Set operator pointer modifier\n");
            }
            free(new_modifier_a);
            free(new_modifier_b);


            int operand_a_pointer_layer = 0;
            int operand_b_pointer_layer = 0;

            if (current_node->getItem(current_node, 0)->type == AST_IDENT_32) {
                operand_a_pointer_layer = symbol_tables[6]->get(symbol_tables[6], current_node->getItem(current_node, 0)->ast_string) - operand_a_pointer_dereference;
            }
            if (current_node->getItem(current_node, 1)->type == AST_IDENT_32) {
                operand_b_pointer_layer = symbol_tables[6]->get(symbol_tables[6], current_node->getItem(current_node, 1)->ast_string) - operand_b_pointer_dereference;
            }

            int pointer_arithmetic_shift_amount = 0;

            if (operand_a_pointer_layer == 1) {
                // pointer arithmetic (single layer)
                if (strcmp(current_node->ast_string, "+") == 0) { // add
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    pointer_arithmetic_shift_amount = ceil(log2(symbol_tables[7]->get(symbol_tables[7], current_node->getItem(current_node, 0)->ast_string))); // scale by datatype size
                    if (pointer_arithmetic_shift_amount > 0) {
                        sprintf(buffer+strlen(buffer), "sli r2, r2, %d\n", pointer_arithmetic_shift_amount);
                    }
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "add r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;ADD_POINTER_32_LOW\n\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "jnc _%d\n", *jmp_label);
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "add r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;ADD_POINTER_32_HIGH\n", extra_stuff->operator_stack_offset+1);
                    sprintf(buffer+strlen(buffer), "jmp _%d\n\n", *jmp_label+1);
                    sprintf(buffer+strlen(buffer), "_%d:\n", *jmp_label);
                    *jmp_label = *jmp_label + 1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "add r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;ADD_POINTER_32_CARRY\n\n", extra_stuff->operator_stack_offset+1);
                    sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset+1);
                    sprintf(buffer+strlen(buffer), "_%d:\n", *jmp_label);
                    extra_stuff->operator_stack_offset += 2;
                    *jmp_label = *jmp_label + 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "-") == 0) { // subtract
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    pointer_arithmetic_shift_amount = ceil(log2(symbol_tables[7]->get(symbol_tables[7], current_node->getItem(current_node, 0)->ast_string))); // scale by datatype size
                    if (pointer_arithmetic_shift_amount > 0) {
                        sprintf(buffer+strlen(buffer), "sli r2, r2, %d\n", pointer_arithmetic_shift_amount);
                    }
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "add r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "sub r%d, r0, r1 ;SUBTRACT_POINTER\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else {
                    printf("Invalid pointer operator\n");
                    exit(1);
                }
            } else {
                if (strcmp(current_node->ast_string, "+") == 0) { // add
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "add r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;ADD_32\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "-") == 0) { // subtract
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "sub r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;SUB\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "&") == 0) { // bitwise and
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "and r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;BITWISE_AND\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "&&") == 0) { // logical and
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "and r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;LOGICAL_AND\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "|") == 0) { // bitwise or
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "or r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;LOGICAL_OR\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "||") == 0) { // logical or
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "or r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;LOGICAL_OR\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "<<") == 0) { // left shift
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "sl r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;LEFT_SHIFT\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, ">>") == 0) { // right shift
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "sr r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;RIGHT_SHIFT\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else {
                    printf("Invalid operator\n");
                    exit(1);
                }
            }
            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
        }
    } else if (current_node->type == AST_OPERATOR_32 && current_node->subtype == AST_REFERENCE) {
    } else if (current_node->type == AST_OPERATOR_32 && current_node->subtype == AST_DEREFERENCE) {
    } else if (current_node->type == AST_IDENT) {
        char buffer[300] = {0};
        if (symbol_tables[6]->get(symbol_tables[6], current_node->ast_string) > 0) {
            // setting pointer (always 16-bit for now)
            if (status == ASM_GET) {
                if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                    
                    //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                    sprintf(buffer, "movi r%d, [fp + %d] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                    //sprintf(buffer+strlen(buffer), "add r%d, r0, r1\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                } else {
                    
                    //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                    sprintf(buffer, "movi r%d, [dp + %s] ;GET\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                    //sprintf(buffer+strlen(buffer), "add r%d, r0, r1\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                    extra_stuff->operator_stack_offset += 1;
                }
            } else if (status == ASM_SET) {
                if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                    extra_stuff->operator_stack_offset += -1;
                    //sprintf(buffer, "movi [sp + %d], r%i\n", symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack, register_select);
                    //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "movi [fp + %d], r%d ;SET\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string), extra_stuff->operator_stack_offset);
                    
                } else {
                    extra_stuff->operator_stack_offset += -1;
                    //sprintf(buffer, "movi [dp + %s], r%i\n", current_node->ast_string, register_select);
                    //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "movi [dp + %s], r%d ;SET\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                    
                }
            } else if (status == ASM_GET_MEMORY) {
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [fp + %d] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        extra_stuff->operator_stack_offset += 1;
                    }
                } else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [fp + %d] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    }
                }
            }
        } else {
            // setting variable (char, int, uint8_t, etc.)
            if (status == ASM_GET) {
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "mvbi r%d, [fp + %d] ;/GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "mvbi r%d, [dp + %s] ;GET\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(&symbol_tables[0], current_node->ast_string) + *stack);
                        extra_stuff->operator_stack_offset += 1;
                    }
                } else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [fp + %d] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    }
                }
            } else if (status == ASM_GET_MEMORY) {
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "mvbi r%d, [fp + %d] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "mvbi r%d, [dp + %s] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        extra_stuff->operator_stack_offset += 1;
                    }
                }
                else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [fp + %d] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    }
                }
            } else if (status == ASM_SET) {
                //if (symbol_tables[4].get(&symbol_tables[4], tail_node->ast_string) == AST_
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        extra_stuff->operator_stack_offset += -1;
                        //sprintf(buffer, "mvbi [sp + %d], r%i\n", symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack, register_select);
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "mvbi [fp + %d], r%d ;SET\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string), extra_stuff->operator_stack_offset);
                        
                    } else {
                        extra_stuff->operator_stack_offset += -1;
                        //sprintf(buffer, "mvbi [dp + %s], r%i\n", current_node->ast_string, register_select);
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "mvbi [dp + %s], r%d ;SET\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                        
                        
                    }
                }
                else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        extra_stuff->operator_stack_offset += -1;
                        //sprintf(buffer, "movi [sp + %d], r%i\n", symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack, register_select);
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "movi [fp + %d], r%d ;SET\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string), extra_stuff->operator_stack_offset);
                        
                    } else {
                        //sprintf(buffer, "movi [dp + %s], r%i\n", current_node->ast_string, register_select);
                        extra_stuff->operator_stack_offset += -1;
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "movi [dp + %s], r%d ;SET\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                        
                    }
                }
            }
        }
        asm_list->append(asm_list, buffer);
        *ast_modifier = symbol_tables[8]->get(symbol_tables[8], current_node->ast_string);
        *visibility = symbol_tables[3]->get(symbol_tables[3], current_node->ast_string);
    } else if (current_node->type == AST_IDENT_32) {
        char buffer[300] = {0};
        if (symbol_tables[6]->get(symbol_tables[6], current_node->ast_string) > 0) {
            // setting pointer (always 16-bit for now)
            if (status == ASM_GET) {
                if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                    
                    //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                    sprintf(buffer, "movi r%d, [fp + %d] ;GET_32\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                    sprintf(buffer+strlen(buffer), "movi r%d, [fp + %d] ;GET_32\n", extra_stuff->operator_stack_offset+1, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string)+1);
                    //sprintf(buffer+strlen(buffer), "add r%d, r0, r1\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 2;
                } else {
                    
                    //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                    sprintf(buffer, "movi r%d, [dp + %s_0] ;GET_32\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                    sprintf(buffer+strlen(buffer), "movi r%d, [dp + %s_1] ;GET_32\n", extra_stuff->operator_stack_offset, current_node->ast_string+1);
                    //sprintf(buffer+strlen(buffer), "add r%d, r0, r1\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                    extra_stuff->operator_stack_offset += 2;
                }
            } else if (status == ASM_SET) {
                if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                    extra_stuff->operator_stack_offset += -2;
                    //sprintf(buffer, "movi [sp + %d], r%i\n", symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack, register_select);
                    //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "movi [fp + %d], r%d ;SET_32\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string), extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "movi [fp + %d], r%d ;SET_32\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string)+1, extra_stuff->operator_stack_offset+1);
                    
                } else {
                    extra_stuff->operator_stack_offset += -2;
                    //sprintf(buffer, "movi [dp + %s], r%i\n", current_node->ast_string, register_select);
                    //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "movi [dp + %s_0], r%d ;SET_32\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "movi [dp + %s_1], r%d ;SET_32\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                    
                }
            } else if (status == ASM_GET_MEMORY) {
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [fp + %d] ;GET_MEMORY_32\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        sprintf(buffer+strlen(buffer), "movi r%d, [fp + %d] ;GET_MEMORY_32\n", extra_stuff->operator_stack_offset+1, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string)+1);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 2;
                    } else {
                        
                        //sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s_0] ;GET_MEMORY_32\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                        sprintf(buffer+strlen(buffer), "movi r%d, [dp + %s_1] ;GET_MEMORY_32\n", extra_stuff->operator_stack_offset+1, current_node->ast_string);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        extra_stuff->operator_stack_offset += 2;
                    }
                } else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [fp + %d] ;GET_32\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        sprintf(buffer+strlen(buffer), "movi r%d, [fp + %d] ;GET_32\n", extra_stuff->operator_stack_offset+1, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string)+1);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 2;
                    } else {
                        
                        //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s_0] ;GET_32\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        sprintf(buffer+strlen(buffer), "movi r%d, [dp + %s_1] ;GET_32\n", extra_stuff->operator_stack_offset+1, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 2;
                    }
                }
            }
        } else {
            // setting variable (char, int, uint8_t, etc.)
            if (status == ASM_GET) {
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "mvbi r%d, [fp + %d] ;GET_32\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        sprintf(buffer+strlen(buffer), "mvbi r%d, [fp + %d] ;GET_32\n", extra_stuff->operator_stack_offset+1, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string)+1);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 2;
                    } else {
                        
                        //sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "mvbi r%d, [dp + %s_0] ;GET_32\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                        sprintf(buffer+strlen(buffer), "mvbi r%d, [dp + %s_1] ;GET_32\n", extra_stuff->operator_stack_offset+1, current_node->ast_string);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(&symbol_tables[0], current_node->ast_string) + *stack);
                        extra_stuff->operator_stack_offset += 2;
                    }
                } else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "addi r%d, r0, 0 ;GET_32\n",  extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "movi r%d, [fp + %d] ;GET_32\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        sprintf(buffer+strlen(buffer), "movi r%d, [fp + %d] ;GET_32\n", extra_stuff->operator_stack_offset+1, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string)+1);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 2;
                    } else {
                        
                        //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "addi r%d, r0, 0 ;GET_32\n",  extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "movi r%d, [dp + %s_0] ;GET_32\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        sprintf(buffer+strlen(buffer), "movi r%d, [dp + %s_1] ;GET_32\n", extra_stuff->operator_stack_offset+1, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 2;
                    }
                }
            } else if (status == ASM_GET_MEMORY) {
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "mvbi r%d, [fp + %d] ;GET_MEMORY_32\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        sprintf(buffer+strlen(buffer), "mvbi r%d, [fp + %d] ;GET_MEMORY_32\n", extra_stuff->operator_stack_offset+1, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string)+1);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 2;
                    } else {
                        
                        //sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "mvbi r%d, [dp + %s_0] ;GET_MEMORY_32\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                        sprintf(buffer+strlen(buffer), "mvbi r%d, [dp + %s_1] ;GET_MEMORY_32\n", extra_stuff->operator_stack_offset+1, current_node->ast_string);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        extra_stuff->operator_stack_offset += 2;
                    }
                }
                else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [fp + %d] ;GET_MEMORY_32\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        sprintf(buffer+strlen(buffer), "movi r%d, [fp + %d] ;GET_MEMORY_32\n", extra_stuff->operator_stack_offset+1, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string)+1);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s_0] ;GET_MEMORY_32\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        sprintf(buffer+strlen(buffer), "movi r%d, [dp + %s_1] ;GET_MEMORY_32\n", extra_stuff->operator_stack_offset+1, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    }
                }
            } else if (status == ASM_SET) {
                //if (symbol_tables[4].get(&symbol_tables[4], tail_node->ast_string) == AST_
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        extra_stuff->operator_stack_offset += -2;
                        //sprintf(buffer, "mvbi [sp + %d], r%i\n", symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack, register_select);
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "mvbi [fp + %d], r%d ;SET_32\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string), extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "mvbi [fp + %d], r%d ;SET_32\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string)+1, extra_stuff->operator_stack_offset+1);
                    } else {
                        extra_stuff->operator_stack_offset += -2;
                        //sprintf(buffer, "mvbi [dp + %s], r%i\n", current_node->ast_string, register_select);
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "mvbi [dp + %s_0], r%d ;SET_32\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "mvbi [dp + %s_1], r%d ;SET_32\n", current_node->ast_string, extra_stuff->operator_stack_offset+1);
                        
                    }
                }
                else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        extra_stuff->operator_stack_offset += -2;
                        //sprintf(buffer, "movi [sp + %d], r%i\n", symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack, register_select);
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "movi [fp + %d], r%d ;SET_32\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string), extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "movi [fp + %d], r%d ;SET_32\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string)+1, extra_stuff->operator_stack_offset+1);
                    } else {
                        //sprintf(buffer, "movi [dp + %s], r%i\n", current_node->ast_string, register_select);
                        extra_stuff->operator_stack_offset += -2;
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "movi [dp + %s_0], r%d ;SET_32\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "movi [dp + %s_1], r%d ;SET_32\n", current_node->ast_string, extra_stuff->operator_stack_offset+1);
                    }
                }
            }
        }
        asm_list->append(asm_list, buffer);
        *ast_modifier = symbol_tables[8]->get(symbol_tables[8], current_node->ast_string);
        *visibility = symbol_tables[3]->get(symbol_tables[3], current_node->ast_string);
    } else if (current_node->type == AST_LITERAL) {
        char buffer[300] = {0};
        
        if (status == ASM_GET) {
            sprintf(buffer, "addi r%d, r0, %s ;GET\n", extra_stuff->operator_stack_offset, current_node->ast_string);
            //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
            extra_stuff->operator_stack_offset += 1;
        } else if (status == ASM_GET_MEMORY) {
            //sprintf(buffer, "addi r1, r0, %s\n", current_node->ast_string);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, %s ;GET\n",  extra_stuff->operator_stack_offset, current_node->ast_string);
            extra_stuff->operator_stack_offset += 1;
        }
        
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_LITERAL_32) {
        char buffer[300] = {0};
        
        if (status == ASM_GET) {
            //sprintf(buffer, "addi r%d, r0, 0 ;GET_32\n",  extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, %d ;GET_32\n", extra_stuff->operator_stack_offset, atoi(current_node->ast_string) % 65536);
            sprintf(buffer+strlen(buffer), "lui r%d, %d ;GET_32\n", extra_stuff->operator_stack_offset, atoi(current_node->ast_string) / 65536);
            
            //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
            extra_stuff->operator_stack_offset += 2;
        } else if (status == ASM_GET_MEMORY) {
            //sprintf(buffer, "addi r1, r0, %s\n", current_node->ast_string);
            //sprintf(buffer+strlen(buffer), "addi r%d, r0, 0 ;GET_32\n",  extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, %d ;GET_32\n",  extra_stuff->operator_stack_offset, atoi(current_node->ast_string) % 65536);
            sprintf(buffer+strlen(buffer), "lui r%d, %d ;GET_32\n",  extra_stuff->operator_stack_offset, atoi(current_node->ast_string) / 65536);
            
            extra_stuff->operator_stack_offset += 2;
        }
        
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_IF) {
        //printf("If\n");
        char buffer[300] = {0};
        CharAppendList *if_condition = generateCharAppendList();
        CharAppendList *if_body = generateCharAppendList();
        int start_jmp_label = *jmp_label;
        asm_generator_code_gen(current_node->getItem(current_node, 0), if_condition, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        extra_stuff->operator_stack_offset += -1;
        sprintf(buffer, "sub r%d, r%d, r0\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset);
        asm_generator_code_gen(current_node->getItem(current_node, 1), if_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, if_condition->array);
        sprintf(buffer+strlen(buffer), "jz %d_false\n", start_jmp_label);
        asm_list->append(asm_list, buffer);
        asm_list->append(asm_list, if_body->array);
        char buffer_b[50] = {0};
        sprintf(buffer_b, "%d_false:\n", start_jmp_label);
        asm_list->append(asm_list, buffer_b);
    } else if (current_node->type == AST_WHILE) {
        CharAppendList *while_condition = generateCharAppendList();
        CharAppendList *while_body = generateCharAppendList();
        int start_jmp_label = *jmp_label;
        char buffer[300] = {0};
        sprintf(buffer, "%d_start:\n", start_jmp_label);
        asm_list->append(asm_list, buffer);
        asm_generator_code_gen(current_node->getItem(current_node, 0), while_condition, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        char buffer_c[50] = {0};
        extra_stuff->operator_stack_offset += -1;
        sprintf(buffer_c, "sub r%d, r%d, r0\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset);
        asm_generator_code_gen(current_node->getItem(current_node, 1), while_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, while_condition->array);
        
        sprintf(buffer_c+strlen(buffer_c), "jz %d_false\n", start_jmp_label);
        asm_list->append(asm_list, buffer_c);
        asm_list->append(asm_list, while_body->array);
        char buffer_b[50] = {0};
        sprintf(buffer_b, "jmp %d_start\n", start_jmp_label);
        sprintf(buffer_b+strlen(buffer_b), "%d_false:\n", start_jmp_label);
        asm_list->append(asm_list, buffer_b);
    } else if (current_node->type == AST_FOR) {
        CharAppendList *for_init = generateCharAppendList();
        CharAppendList *for_condition = generateCharAppendList();
        CharAppendList *for_iter = generateCharAppendList();
        CharAppendList *for_body = generateCharAppendList();
        int start_jmp_label = *jmp_label;
        char buffer[300] = {0};
        sprintf(buffer, "%d_start:\n", start_jmp_label);
        
        char buffer_b[50] = {0};
        asm_generator_code_gen(current_node->getItem(current_node, 0), for_init, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_generator_code_gen(current_node->getItem(current_node, 1), for_condition, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_generator_code_gen(current_node->getItem(current_node, 2), for_iter, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_generator_code_gen(current_node->getItem(current_node, 3), for_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        sprintf(buffer_b, "\n;for_init\n");
        asm_list->append(asm_list, buffer_b);
        asm_list->append(asm_list, for_init->array);
        
        sprintf(buffer_b, "\n;for_condition\n");
        asm_list->append(asm_list, buffer);
        asm_list->append(asm_list, buffer_b);
        
        asm_list->append(asm_list, for_condition->array);
        char buffer_c[50] = {0};
        sprintf(buffer_c, "sub r1, r1, r0\n");
        sprintf(buffer_c+strlen(buffer_c), "jz %d_false\n", start_jmp_label);
        asm_list->append(asm_list, buffer_c);

        sprintf(buffer_b, "\n;for_body\n");
        asm_list->append(asm_list, buffer_b);
        asm_list->append(asm_list, for_body->array);
        sprintf(buffer_b, "\n;for_iter\n");
        asm_list->append(asm_list, buffer_b);
        asm_list->append(asm_list, for_iter->array);
        sprintf(buffer_b, "jmp %d_start\n", start_jmp_label);
        sprintf(buffer_b+strlen(buffer_b), "%d_false:\n", start_jmp_label);
        asm_list->append(asm_list, buffer_b);
    } else if (current_node->type == AST_FUNCTION_DECLARATION) {
        CharAppendList *function = generateCharAppendList();
        char buffer[300] = {0};
        asm_generator_code_gen(current_node->getItem(current_node, 0), function, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, function->array);
    } else if (current_node->type == AST_FUNCTION) {
        CharAppendList *function_parameters = generateCharAppendList();
        CharAppendList *function_body = generateCharAppendList();
        char buffer[300] = {0};
        sprintf(buffer, "_%s:\n", current_node->ast_string);
        if (strcmp(current_node->ast_string, "main") == 0) {
            sprintf(buffer+strlen(buffer), "subi sp, sp, %d\n", symbol_tables[2]->get(symbol_tables[2], current_node->ast_string));
            sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
        } else {
            sprintf(buffer+strlen(buffer), "subi sp, sp, 4\n");
            sprintf(buffer+strlen(buffer), "movi [sp + 0], ra\n");
            if (symbol_tables[2]->get(symbol_tables[2], current_node->ast_string) > 0) {
                sprintf(buffer+strlen(buffer), "subi sp, sp, %d\n", symbol_tables[2]->get(symbol_tables[2], current_node->ast_string));
            }
            sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
        }
        asm_list->append(asm_list, buffer);
        // function parameters are evaluated in the asm pre-parser (first pass to evaluate symbol values)
        asm_generator_code_gen(current_node->getItem(current_node, 1), function_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_node->ast_string, extra_stuff);
        char buffer_b[50] = {0};
        asm_list->append(asm_list, function_body->array);
        if (strcmp(current_node->ast_string, "main") == 0) {
            sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
            sprintf(buffer_b, "halt\n");
        } else {
            sprintf(buffer_b+strlen(buffer_b), "addi sp, sp, %d\n", symbol_tables[2]->get(symbol_tables[2], current_node->ast_string));
            sprintf(buffer_b+strlen(buffer_b), "movi ra, [sp + 0]\n");
            sprintf(buffer_b+strlen(buffer_b), "addi sp, sp, 4\n");
            //sprintf(buffer_b+strlen(buffer_b), "add fp, r0, sp\n");
            sprintf(buffer_b+strlen(buffer_b), "jr ra\n");
        }
        asm_list->append(asm_list, buffer_b);
    } else if (current_node->type == AST_FUNCTION_CALL) {
        CharAppendList *function_parameters = generateCharAppendList();
        char buffer[300] = {0};
        if (current_node->getItem(current_node, 0)->getItem(current_node->getItem(current_node, 0), 0)->type != AST_VOID) {
            asm_generator_code_gen(current_node->getItem(current_node, 0), function_parameters, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_list->append(asm_list, function_parameters->array);
        }
        sprintf(buffer, "jal _%s\n", current_node->ast_string);
        sprintf(buffer+strlen(buffer), "add r%d, r0, r1\n", extra_stuff->operator_stack_offset);
        AST_Node *callparam_node = current_node->getItem(current_node, 0);
        if (callparam_node->getItem(callparam_node, 0)->type != AST_VOID) {
            sprintf(buffer+strlen(buffer), "addi sp, sp, %d\n", 4*callparam_node->getSize(callparam_node));
        }
        sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_PARAMS) {
        CharAppendList *function_param_code = generateCharAppendList();
        char buffer[300] = {0};
        //sprintf(buffer, "movi [sp + 0], ra\n");
        //sprintf(buffer+strlen(buffer), "addi sp, sp, -2\n");
        for (int i = 0; i < current_node->getSize(current_node); i++) {
            asm_generator_code_gen_call_params(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_list->append(asm_list, buffer);
        }
    } else if (current_node->type == AST_CALL_PARAMS) {
        // call params will recurse on a different function to this main one, as the syntax requires different interpretation
        CharAppendList *function_param_code = generateCharAppendList();
        char buffer[300] = {0};
        char buffer_b[50] = {0};
        sprintf(buffer_b, "movi [sp + 0], r%d\n", extra_stuff->operator_stack_offset);
        //sprintf(buffer, "movi [sp + 0], ra\n");
        //sprintf(buffer+strlen(buffer), "addi sp, sp, -2\n");
        int param_stack = 0;
        int null_stack = 0;
        if (current_node->getItem(current_node, 0)->type != AST_VOID) {
            for (int i = current_node->getSize(current_node) - 1; i >= 0; i--) { // output params in reverse order, since stack works in LIFO (last in first out).
                int cancel_stack = 0;
                sprintf(buffer, "subi sp, sp, 4\n");
                if (symbol_tables[0]->in(symbol_tables[0], current_node->getItem(current_node, i)->ast_string) != -1) {
                    // function call in function param
                    cancel_stack = -symbol_tables[0]->get(symbol_tables[0], current_node->getItem(current_node, i)->ast_string);
                    asm_list->append(asm_list, buffer);
                    //param_stack += 2;
                    asm_generator_code_gen(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, &param_stack, ASM_GET_MEMORY, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                    set_stack_param(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, &cancel_stack, ASM_SET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                    //asm_list->append(asm_list, buffer_b);
                    //extra_stuff->operator_stack_offset += -1;
                } else {
                    // variable in function
                    asm_list->append(asm_list, buffer);
                    //param_stack += 2;
                    asm_generator_code_gen(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, &param_stack, ASM_GET_MEMORY, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                    set_stack_param(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, &cancel_stack, ASM_SET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                    //asm_list->append(asm_list, buffer_b);
                    //extra_stuff->operator_stack_offset += -1;
                }
                //asm_list->append(asm_list, buffer);
            }
        }
        else {
            printf("void detected");
        }
    } else if (current_node->type == AST_STRING) {
        char buffer[300] = {0};
        sprintf(buffer, ".asciiz string_%d = \"%s\"\n", string_number++, current_node->ast_string);
        sprintf(buffer+strlen(buffer), "addi r%d, r0, %s\n", extra_stuff->operator_stack_offset, current_node->ast_string_name);
        asm_list->append(asm_list, buffer);
        extra_stuff->operator_stack_offset += 1;
    } else if (current_node->type == AST_RETURN) {
        char buffer[300] = {0};
        asm_generator_code_gen(current_node->getItem(current_node, 0), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        //extra_stuff->operator_stack_offset = extra_stuff->operator_stack_offset - 1;
        sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset-1);
        sprintf(buffer+strlen(buffer), "addi sp, sp, %d\n", symbol_tables[2]->get(symbol_tables[2], current_function));
        sprintf(buffer+strlen(buffer), "movi ra, [sp + 0]\n");
        sprintf(buffer+strlen(buffer), "addi sp, sp, 4\n");
        sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
        sprintf(buffer+strlen(buffer), "jr ra\n");
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_VOID) {
        // do nothing
    } else {
        printf("Invalid AST node in asm generation\n");
        exit(1);
    }
}

void set_stack_param(AST_Node *current_node, CharAppendList *asm_list, Dictionary **symbol_tables, DictionaryPointer *pointer_symbol_table, int *stack, int status, int *jmp_label, int register_select, int *pointer_layer_dereference, int *ast_modifier, int *visibility, char *current_function, ExtraStuff *extra_stuff) {
        /*
    r0 = zero constant
    r1,r2 = register a
    r3,r4 = register b
    r5,r6 = result register
    function parameters and local variables are stored on the stack
    the stack grows downwards from 0xffff to 0x0000
    */
    if (current_node->type == AST_MAIN || current_node->type == AST_BODY) {
        if (current_node->type == AST_MAIN) {
            asm_list->append(asm_list, "jmp _main\n\n");
            current_node->ast_string = "_main";
        } else if (current_node->type == AST_FUNCTION) {
            char buffer[300] = {0};
            sprintf(buffer, "%s:\n", current_node->ast_string);
            asm_list->append(asm_list, buffer);
        }
        for (int i = 0; i < current_node->getSize(current_node); i++) {
            asm_generator_code_gen(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_list->append(asm_list, "\n");
        }
    } else if (current_node->type == AST_DECLARATION) {
        char buffer[300] = {0};
        // check for pointer or non-pointer declaration
        AST_Node *nextNode;
        nextNode = current_node;
        int is_pointer = 0;
        while (nextNode->getSize(nextNode) > 0) {
            nextNode = nextNode->getItem(nextNode, 0);
            if (nextNode->ast_string[0] == '*') {
                is_pointer = 1;
            }
        }
        *ast_modifier = current_node->modifier;
        AST_Node *recursive_node = current_node;
        while (recursive_node->type != AST_IDENT) {
            recursive_node = recursive_node->getItem(recursive_node, 0);
        }
        if (recursive_node->visibility == AST_STATIC) {
            if (is_pointer) {
                sprintf(buffer, ".word %s_ptr = 0\n", recursive_node->ast_string);
            } else {
                sprintf(buffer, ".word %s = 0\n", recursive_node->ast_string);
            }
            asm_list->append(asm_list, buffer);
        } else if (current_node->getItem(current_node, 0)->visibility == AST_LOCAL) {
            if (is_pointer) {
                //sprintf(buffer, "addi sp, sp, -2\n");
            } else {
                //sprintf(buffer, "addi sp, sp, -2\n");
            }
        }
        // SetVariable in Declaration
        if (current_node->getSize(current_node) == 2) {
            //asm_generator_code_gen(current_node->getItem(current_node, 1), asm_list, symbol_tables, pointer_symbol_table, stack+1, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
            current_node = current_node->getItem(current_node, 1);
            if (strcmp(current_node->ast_string, "=") == 0) {
                AST_Node *node_a = current_node;
                while (node_a->type != AST_IDENT) {
                    node_a = node_a->getItem(node_a, 0);
                }
                CharAppendList *operand_a = generateCharAppendList();
                CharAppendList *operand_b = generateCharAppendList();
                asm_generator_code_gen(node_a, operand_a, symbol_tables, pointer_symbol_table, stack, ASM_SET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                
                asm_list->append(asm_list, operand_b->array);
                asm_list->append(asm_list, operand_a->array);
            }
        }
        
    } else if (current_node->type == AST_SET_VARIABLE) {
        asm_generator_code_gen(current_node->getItem(current_node, 0), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
    } else if (current_node->type == AST_OPERATOR && current_node->subtype == AST_MATH) {
        char buffer[300] = {0};
        extra_stuff->operator_stack_offset += -1;
        sprintf(buffer, "movi [sp + 0], r%d ;SET\n", extra_stuff->operator_stack_offset);
        asm_list->append(asm_list, buffer);
        return;
        if (strcmp(current_node->ast_string, "=") == 0) {
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_SET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            
            
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operand_a->array);
        } else if (strcmp(current_node->ast_string, "<") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            extra_stuff->operator_stack_offset += -2;
            sprintf(buffer, "sub r1, r%d, r%d\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset+1);
            sprintf(buffer+strlen(buffer), "jc %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "jz %d_false\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 0\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;

            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
            extra_stuff->operator_stack_offset += 1;
        } else if (strcmp(current_node->ast_string, ">") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            extra_stuff->operator_stack_offset += -2;
            sprintf(buffer, "sub r1, r%d, r%d\n", extra_stuff->operator_stack_offset+1, extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jc %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "jz %d_false\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 0\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;

            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
            extra_stuff->operator_stack_offset += 1;
        } else if (strcmp(current_node->ast_string, "==") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            extra_stuff->operator_stack_offset += -2;
            sprintf(buffer, "sub r1, r%d, r%d\n", extra_stuff->operator_stack_offset+1, extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jz %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 0\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;

            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
            extra_stuff->operator_stack_offset += 1;
        } else if (strcmp(current_node->ast_string, "!=") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            extra_stuff->operator_stack_offset += -2;
            sprintf(buffer, "sub r1, r%d, r%d\n", extra_stuff->operator_stack_offset+1, extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jz %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 1\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, 0\n", extra_stuff->operator_stack_offset);
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;
            
            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
            extra_stuff->operator_stack_offset += 1;
        } else {
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            int operand_a_pointer_dereference = 0;
            int operand_b_pointer_dereference = 0;
            int *new_modifier_a = malloc(1*sizeof(int));
            int *new_modifier_b = malloc(1*sizeof(int));
            *new_modifier_a = AST_NO_MODIFIER;
            *new_modifier_b = AST_NO_MODIFIER;
            int *operand_a_modifier = new_modifier_a;
            int *operand_b_modifier = new_modifier_b;
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, &operand_a_pointer_dereference, operand_a_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, &operand_b_pointer_dereference, operand_b_modifier, visibility, current_function, extra_stuff);

            if (*operand_a_modifier != AST_NO_MODIFIER) { // sets final pointer modifier if adding a modified pointer with an integer
                *ast_modifier = *operand_a_modifier;
                printf("Set operator pointer modifier\n");
            }
            if (*operand_b_modifier != AST_NO_MODIFIER) {
                *ast_modifier = *operand_b_modifier;
                printf("Set operator pointer modifier\n");
            }
            free(new_modifier_a);
            free(new_modifier_b);


            int operand_a_pointer_layer = 0;
            int operand_b_pointer_layer = 0;

            if (current_node->getItem(current_node, 0)->type == AST_IDENT) {
                operand_a_pointer_layer = symbol_tables[6]->get(symbol_tables[6], current_node->getItem(current_node, 0)->ast_string) - operand_a_pointer_dereference;
            }
            if (current_node->getItem(current_node, 1)->type == AST_IDENT) {
                operand_b_pointer_layer = symbol_tables[6]->get(symbol_tables[6], current_node->getItem(current_node, 1)->ast_string) - operand_b_pointer_dereference;
            }

            int pointer_arithmetic_shift_amount = 0;

            if (operand_a_pointer_layer == 1) {
                // pointer arithmetic (single layer)
                if (strcmp(current_node->ast_string, "+") == 0) { // add
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    pointer_arithmetic_shift_amount = ceil(log2(symbol_tables[7]->get(symbol_tables[7], current_node->getItem(current_node, 0)->ast_string))); // scale by datatype size
                    if (pointer_arithmetic_shift_amount > 0) {
                        sprintf(buffer+strlen(buffer), "sli r2, r2, %d\n", pointer_arithmetic_shift_amount);
                    }
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "add r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;ADD_POINTER\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "-") == 0) { // subtract
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    pointer_arithmetic_shift_amount = ceil(log2(symbol_tables[7]->get(symbol_tables[7], current_node->getItem(current_node, 0)->ast_string))); // scale by datatype size
                    if (pointer_arithmetic_shift_amount > 0) {
                        sprintf(buffer+strlen(buffer), "sli r2, r2, %d\n", pointer_arithmetic_shift_amount);
                    }
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "add r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "sub r%d, r0, r1 ;SUBTRACT_POINTER\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else {
                    printf("Invalid pointer operator\n");
                    exit(1);
                }
            } else {
                if (strcmp(current_node->ast_string, "+") == 0) { // add
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "add r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;ADD\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "-") == 0) { // subtract
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "sub r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;SUB\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "&") == 0) { // bitwise and
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "and r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;BITWISE_AND\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "&&") == 0) { // logical and
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "and r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;LOGICAL_AND\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "|") == 0) { // bitwise or
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "or r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;LOGICAL_OR\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "||") == 0) { // logical or
                    char buffer[300] = {0};
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer, "add r2, r0, r%d\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "or r1, r%i, r%i\n", 1, 2);
                    sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;LOGICAL_OR\n\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                    operator->array = buffer;
                } else {
                    printf("Invalid operator\n");
                    exit(1);
                }
            }
            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
        }
    } else if (current_node->type == AST_OPERATOR && current_node->subtype == AST_DEREFERENCE) {
        char buffer[300] = {0};
        extra_stuff->operator_stack_offset += -1;
        sprintf(buffer, "movi [sp + 0], r%d ;SET\n", extra_stuff->operator_stack_offset);
        asm_list->append(asm_list, buffer);
        return;
        #define STACK_BASE 0x0010
        #define STATIC_BASE 0x0004
        #define IO_BASE 0x0013
        CharAppendList *operand = generateCharAppendList();
        asm_generator_code_gen(current_node->getItem(current_node, 0), operand, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, 7, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, operand->array); // assume result stored in r1
        int modifier = *ast_modifier;
        AST_Node *tail_node = current_node;
        while (tail_node->type != AST_IDENT) {
            tail_node = tail_node->getItem(tail_node, 0);
        }

        /*
        sprintf(buffer+strlen(buffer), "mov i0, r%d\n", extra_stuff->operator_stack_offset);
        if (modifier == NO_MODIFIER || current_node->subtype != AST_DEREFERENCE) {
            if (*visibility == AST_LOCAL) {
                sprintf(buffer, "lui i1, r0, %d\n", STACK_BASE); // use 32-bit index register to point anywhere in memory
            } else if (*visibility == AST_STATIC) {
                sprintf(buffer, "lui i1, r0, %d\n", STATIC_BASE); // use 32-bit index register to point anywhere in memory
            } else {
                printf("Invalid visibility\n");
                exit(1);
            }
        } else if (modifier == IO) {
            sprintf(buffer, "lui i1, r0, %d\n", IO_BASE);
        } else if (modifier == MODIFIER_DATA) {
            sprintf(buffer, "lui i1, r0, %d\n", STATIC_BASE);
        }
        */
        
        /*
        if (symbol_tables[6].get(&symbol_tables[6], tail_node->ast_string) > 1) {
            // setting pointer (always 16-bit for now)
            if (status == ASM_GET) {
                if (symbol_tables[3].get(&symbol_tables[3], tail_node->ast_string) == AST_LOCAL) {
                    sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], tail_node->ast_string));
                } else {
                    sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, tail_node->ast_string);
                }
            } else if (status == ASM_SET) {
                if (symbol_tables[3]->get(symbol_tables[3], tail_node->ast_string) == AST_LOCAL) {
                    sprintf(buffer, "movi [sp + %d], r%i\n", symbol_tables[0]->get(symbol_tables[0], tail_node->ast_string), register_select);
                } else {
                    sprintf(buffer, "movi [dp + %s], r%i\n", tail_node->ast_string, register_select);
                }
            }
        } else {*/
            if (status == ASM_GET) {
                if (symbol_tables[4]->get(symbol_tables[4], tail_node->ast_string) == CHAR) {
                    sprintf(buffer+strlen(buffer), "mvbi r%d, [r%d + 0] ;GET\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset - 1);
                    extra_stuff->operator_stack_offset += 1;
                } else {
                    sprintf(buffer+strlen(buffer), "movi r%d, [r%d + 0] ;GET\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset - 1);
                    extra_stuff->operator_stack_offset += 1;
                }
            } else if (status == ASM_GET_MEMORY) {
                if (symbol_tables[4]->get(symbol_tables[4], tail_node->ast_string) == CHAR) {
                    sprintf(buffer+strlen(buffer), "mvbi r%d, [r%d + 0] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset - 1);
                    extra_stuff->operator_stack_offset += 1;
                } else {
                    sprintf(buffer+strlen(buffer), "movi r%d, [r%d + 0] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset - 1);
                    extra_stuff->operator_stack_offset += 1;
                }
            } else if (status == ASM_SET) {
                if (symbol_tables[4]->get(symbol_tables[4], tail_node->ast_string) == CHAR) {
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "mvbi [r%d + 0], r%d ;SET\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset - 1);
                } else {
                    extra_stuff->operator_stack_offset += -1;
                    sprintf(buffer+strlen(buffer), "movi [r%d + 0], r%d ;SET\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset - 1);
                }
            }
            extra_stuff->operator_stack_offset += -1;
        //}
        asm_list->append(asm_list, buffer);
        *pointer_layer_dereference--;
    } else if (current_node->type == AST_OPERATOR && current_node->subtype == AST_REFERENCE) {
        #define STACK_BASE 0x0010
        CharAppendList *operand = generateCharAppendList();
        asm_generator_code_gen(current_node->getItem(current_node, 0), operand, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, operand->array); // assume result stored in r1
        char buffer[300] = {0};
        //sprintf(buffer, "addi i1, r0, %d\n", STACK_BASE); // use 32-bit index register to point anywhere in memory
        //sprintf(buffer+strlen(buffer), "mov i0, r1\n");
        if (status == ASM_GET) {
            sprintf(buffer+strlen(buffer), "addi r1, r0, %d\n", symbol_tables[0]->get(symbol_tables[0], current_node->getItem(current_node, 0)->ast_string), register_select);
        } else if (status == ASM_SET) {
            printf("Reference syntax error\n");
            exit(1);
            sprintf(buffer+strlen(buffer), "movi [i0 + 0], r1\n");
        }
        asm_list->append(asm_list, buffer);
        *pointer_layer_dereference++;
    } else if (current_node->type == AST_IDENT) {
        char buffer[300] = {0};
        if (symbol_tables[6]->get(symbol_tables[6], current_node->ast_string) > 0) {
            // setting pointer (always 16-bit for now)
            if (status == ASM_GET) {
                if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                    
                    //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                    sprintf(buffer, "movi r%d, [fp + %d] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                    //sprintf(buffer+strlen(buffer), "add r%d, r0, r1\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                } else {
                    
                    //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                    sprintf(buffer, "movi r%d, [dp + %s] ;GET\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                    //sprintf(buffer+strlen(buffer), "add r%d, r0, r1\n", extra_stuff->operator_stack_offset, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                    extra_stuff->operator_stack_offset += 1;
                }
            } else if (status == ASM_SET) {
                if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                    extra_stuff->operator_stack_offset += -1;
                    //sprintf(buffer, "movi [sp + %d], r%i\n", symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack, register_select);
                    //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "movi [sp + %d], r%d ;SET\n", 0, extra_stuff->operator_stack_offset);
                    
                } else {
                    extra_stuff->operator_stack_offset += -1;
                    //sprintf(buffer, "movi [dp + %s], r%i\n", current_node->ast_string, register_select);
                    //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "movi [dp + %s], r%d ;SET\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                    
                }
            } else if (status == ASM_GET_MEMORY) {
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [fp + %d] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        extra_stuff->operator_stack_offset += 1;
                    }
                } else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [fp + %d] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    }
                }
            }
        } else {
            // setting variable (char, int, uint8_t, etc.)
            if (status == ASM_GET) {
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "mvbi r%d, [fp + %d] ;/GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "mvbi r%d, [dp + %s] ;GET\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        extra_stuff->operator_stack_offset += 1;
                    }
                } else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [fp + %d] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    }
                }
            } else if (status == ASM_GET_MEMORY) {
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "mvbi r%d, [fp + %d] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "mvbi r%d, [dp + %s] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        extra_stuff->operator_stack_offset += 1;
                    }
                }
                else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [fp + %d] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    }
                }
            } else if (status == ASM_SET) {
                //if (symbol_tables[4]->get(symbol_tables[4], tail_node->ast_string) == AST_
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        extra_stuff->operator_stack_offset += -1;
                        //sprintf(buffer, "mvbi [sp + %d], r%i\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack, register_select);
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "mvbi [sp + %d], r%d ;SET\n", 0, extra_stuff->operator_stack_offset);
                        
                    } else {
                        extra_stuff->operator_stack_offset += -1;
                        //sprintf(buffer, "mvbi [dp + %s], r%i\n", current_node->ast_string, register_select);
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "mvbi [dp + %s], r%d ;SET\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                        
                        
                    }
                }
                else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        extra_stuff->operator_stack_offset += -1;
                        //sprintf(buffer, "movi [sp + %d], r%i\n", symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack, register_select);
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "movi [sp + %d], r%d ;SET\n", 0, extra_stuff->operator_stack_offset);
                        
                    } else {
                        //sprintf(buffer, "movi [dp + %s], r%i\n", current_node->ast_string, register_select);
                        extra_stuff->operator_stack_offset += -1;
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "movi [dp + %s], r%d ;SET\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                        
                    }
                }
            }
        }
        asm_list->append(asm_list, buffer);
        *ast_modifier = symbol_tables[8]->get(symbol_tables[8], current_node->ast_string);
        *visibility = symbol_tables[3]->get(symbol_tables[3], current_node->ast_string);
    } else if (current_node->type == AST_LITERAL) {
        char buffer[300] = {0};
        
        if (status == ASM_GET) {
            sprintf(buffer, "addi r%d, r0, %s ;GET\n", extra_stuff->operator_stack_offset, current_node->ast_string);
            //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
            extra_stuff->operator_stack_offset += 1;
        } else if (status == ASM_GET_MEMORY) {
            //sprintf(buffer, "addi r1, r0, %s\n", current_node->ast_string);
            sprintf(buffer+strlen(buffer), "addi r%d, r0, %s ;GET\n",  extra_stuff->operator_stack_offset, current_node->ast_string);
            extra_stuff->operator_stack_offset += 1;
        } else if (status == ASM_SET) {
            extra_stuff->operator_stack_offset += -1;
            sprintf(buffer+strlen(buffer), "movi [sp + %d], r%d ;SET\n", 0, extra_stuff->operator_stack_offset);
        }

        
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_IF) {
        //printf("If\n");
        char buffer[300] = {0};
        CharAppendList *if_condition = generateCharAppendList();
        CharAppendList *if_body = generateCharAppendList();
        int start_jmp_label = *jmp_label;
        asm_generator_code_gen(current_node->getItem(current_node, 0), if_condition, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_generator_code_gen(current_node->getItem(current_node, 1), if_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, if_condition->array);
        extra_stuff->operator_stack_offset += -1;
        sprintf(buffer, "sub r%d, r%d, r0\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset);
        sprintf(buffer+strlen(buffer), "jz %d_false\n", start_jmp_label);
        asm_list->append(asm_list, buffer);
        asm_list->append(asm_list, if_body->array);
        char buffer_b[50] = {0};
        sprintf(buffer_b, "%d_false:\n", start_jmp_label);
        asm_list->append(asm_list, buffer_b);
    } else if (current_node->type == AST_WHILE) {
        CharAppendList *while_condition = generateCharAppendList();
        CharAppendList *while_body = generateCharAppendList();
        int start_jmp_label = *jmp_label;
        char buffer[300] = {0};
        sprintf(buffer, "%d_start:\n", start_jmp_label);
        asm_list->append(asm_list, buffer);
        asm_generator_code_gen(current_node->getItem(current_node, 0), while_condition, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        char buffer_c[50] = {0};
        extra_stuff->operator_stack_offset += -1;
        sprintf(buffer_c, "sub r%d, r%d, r0\n", extra_stuff->operator_stack_offset, extra_stuff->operator_stack_offset);
        asm_generator_code_gen(current_node->getItem(current_node, 1), while_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, while_condition->array);
        
        sprintf(buffer_c+strlen(buffer_c), "jz %d_false\n", start_jmp_label);
        asm_list->append(asm_list, buffer_c);
        asm_list->append(asm_list, while_body->array);
        char buffer_b[50] = {0};
        sprintf(buffer_b, "jmp %d_start\n", start_jmp_label);
        sprintf(buffer_b+strlen(buffer_b), "%d_false:\n", start_jmp_label);
        asm_list->append(asm_list, buffer_b);
    } else if (current_node->type == AST_FOR) {
        CharAppendList *for_init = generateCharAppendList();
        CharAppendList *for_condition = generateCharAppendList();
        CharAppendList *for_iter = generateCharAppendList();
        CharAppendList *for_body = generateCharAppendList();
        int start_jmp_label = *jmp_label;
        char buffer[300] = {0};
        sprintf(buffer, "%d_start:\n", start_jmp_label);
        
        char buffer_b[50] = {0};
        asm_generator_code_gen(current_node->getItem(current_node, 0), for_init, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_generator_code_gen(current_node->getItem(current_node, 1), for_condition, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_generator_code_gen(current_node->getItem(current_node, 2), for_iter, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_generator_code_gen(current_node->getItem(current_node, 3), for_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        sprintf(buffer_b, "\n; for init\n");
        asm_list->append(asm_list, buffer_b);
        asm_list->append(asm_list, for_init->array);
        
        sprintf(buffer_b, "\n; for condition\n");
        asm_list->append(asm_list, buffer);
        asm_list->append(asm_list, buffer_b);
        
        asm_list->append(asm_list, for_condition->array);
        char buffer_c[50] = {0};
        sprintf(buffer_c, "sub r1, r1, r0\n");
        sprintf(buffer_c+strlen(buffer_c), "jz %d_false\n", start_jmp_label);
        asm_list->append(asm_list, buffer_c);

        sprintf(buffer_b, "\n; for body\n");
        asm_list->append(asm_list, buffer_b);
        asm_list->append(asm_list, for_body->array);
        sprintf(buffer_b, "\n; for iter\n");
        asm_list->append(asm_list, buffer_b);
        asm_list->append(asm_list, for_iter->array);
        sprintf(buffer_b, "jmp %d_start\n", start_jmp_label);
        sprintf(buffer_b+strlen(buffer_b), "%d_false:\n", start_jmp_label);
        asm_list->append(asm_list, buffer_b);
    } else if (current_node->type == AST_FUNCTION_DECLARATION) {
        CharAppendList *function = generateCharAppendList();
        char buffer[300] = {0};
        asm_generator_code_gen(current_node->getItem(current_node, 0), function, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, function->array);
    } else if (current_node->type == AST_FUNCTION) {
        CharAppendList *function_parameters = generateCharAppendList();
        CharAppendList *function_body = generateCharAppendList();
        char buffer[300] = {0};
        sprintf(buffer, "_%s:\n", current_node->ast_string);
        if (strcmp(current_node->ast_string, "main") == 0) {
            sprintf(buffer+strlen(buffer), "subi sp, sp, %d\n", symbol_tables[2]->get(symbol_tables[2], current_node->ast_string));
            sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
        } else {
            sprintf(buffer+strlen(buffer), "subi sp, sp, 4\n");
            sprintf(buffer+strlen(buffer), "movi [sp + 0], ra\n");
            if (symbol_tables[2]->get(symbol_tables[2], current_node->ast_string) > 0) {
                sprintf(buffer+strlen(buffer), "subi sp, sp, %d\n", symbol_tables[2]->get(symbol_tables[2], current_node->ast_string));
            }
            sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
        }
        asm_list->append(asm_list, buffer);
        // function parameters are evaluated in the asm pre-parser (first pass to evaluate symbol values)
        asm_generator_code_gen(current_node->getItem(current_node, 1), function_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_node->ast_string, extra_stuff);
        char buffer_b[50] = {0};
        asm_list->append(asm_list, function_body->array);
        if (strcmp(current_node->ast_string, "main") == 0) {
            sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
            sprintf(buffer_b, "halt\n");
        } else {
            sprintf(buffer_b+strlen(buffer_b), "addi sp, sp, %d\n", symbol_tables[2]->get(symbol_tables[2], current_node->ast_string));
            sprintf(buffer_b+strlen(buffer_b), "movi ra, [sp + 0]\n");
            sprintf(buffer_b+strlen(buffer_b), "addi sp, sp, 4\n");
            //sprintf(buffer_b+strlen(buffer_b), "add fp, r0, sp\n");
            sprintf(buffer_b+strlen(buffer_b), "jr ra\n");
        }
        asm_list->append(asm_list, buffer_b);
    } else if (current_node->type == AST_FUNCTION_CALL) {
        CharAppendList *function_parameters = generateCharAppendList();
        char buffer[300] = {0};
        if (current_node->getItem(current_node, 0)->getItem(current_node->getItem(current_node, 0), 0)->type != AST_VOID) {
            asm_generator_code_gen(current_node->getItem(current_node, 0), function_parameters, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_list->append(asm_list, function_parameters->array);
        }
        sprintf(buffer, "jal _%s\n", current_node->ast_string);
        sprintf(buffer+strlen(buffer), "add r%d, r0, r1\n", extra_stuff->operator_stack_offset);
        AST_Node *callparam_node = current_node->getItem(current_node, 0);
        if (callparam_node->getItem(callparam_node, 0)->type != AST_VOID) {
            sprintf(buffer+strlen(buffer), "addi sp, sp, %d\n", 4*callparam_node->getSize(callparam_node));
        }
        sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_PARAMS) {
        CharAppendList *function_param_code = generateCharAppendList();
        char buffer[300] = {0};
        //sprintf(buffer, "movi [sp + 0], ra\n");
        //sprintf(buffer+strlen(buffer), "addi sp, sp, -2\n");
        for (int i = 0; i < current_node->getSize(current_node); i++) {
            asm_generator_code_gen_call_params(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_list->append(asm_list, buffer);
        }
    } else if (current_node->type == AST_CALL_PARAMS) {
        // call params will recurse on a different function to this main one, as the syntax requires different interpretation
        CharAppendList *function_param_code = generateCharAppendList();
        char buffer[300] = {0};
        char buffer_b[50] = {0};
        sprintf(buffer_b, "movi [sp + 0], r%d\n", extra_stuff->operator_stack_offset);
        //sprintf(buffer, "movi [sp + 0], ra\n");
        //sprintf(buffer+strlen(buffer), "addi sp, sp, -2\n");
        int param_stack = 0;
        int null_stack = 0;
        if (current_node->getItem(current_node, 0)->type != AST_VOID) {
            for (int i = current_node->getSize(current_node) - 1; i >= 0; i--) { // output params in reverse order, since stack works in LIFO (last in first out).
                int cancel_stack = 0;
                sprintf(buffer, "subi sp, sp, 4\n");
                if (symbol_tables[0]->in(symbol_tables[0], current_node->getItem(current_node, i)->ast_string) != -1) {
                    // function call in function param
                    cancel_stack = -symbol_tables[0]->get(symbol_tables[0], current_node->getItem(current_node, i)->ast_string);
                    asm_list->append(asm_list, buffer);
                    //param_stack += 2;
                    asm_generator_code_gen(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, &param_stack, ASM_GET_MEMORY, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                    set_stack_param(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, &cancel_stack, ASM_SET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                    //asm_list->append(asm_list, buffer_b);
                    //extra_stuff->operator_stack_offset += -1;
                } else {
                    // variable in function
                    asm_list->append(asm_list, buffer);
                    //param_stack += 2;
                    asm_generator_code_gen(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, &param_stack, ASM_GET_MEMORY, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                    set_stack_param(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, &cancel_stack, ASM_SET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                    //asm_list->append(asm_list, buffer_b);
                    //extra_stuff->operator_stack_offset += -1;
                }
                //asm_list->append(asm_list, buffer);
            }
        }
        else {
            printf("void detected");
        }
    } else if (current_node->type == AST_STRING) {
        char buffer[300] = {0};
        sprintf(buffer, ".asciiz string_%d = \"%s\"\n", string_number++, current_node->ast_string);
        sprintf(buffer+strlen(buffer), "addi r%d, r0, %s\n", extra_stuff->operator_stack_offset, current_node->ast_string_name);
        asm_list->append(asm_list, buffer);
        extra_stuff->operator_stack_offset += 1;
    } else if (current_node->type == AST_RETURN) {
        char buffer[300] = {0};
        asm_generator_code_gen(current_node->getItem(current_node, 0), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        //extra_stuff->operator_stack_offset = extra_stuff->operator_stack_offset - 1;
        sprintf(buffer+strlen(buffer), "add r1, r0, r%d\n", extra_stuff->operator_stack_offset-1);
        sprintf(buffer+strlen(buffer), "addi sp, sp, %d\n", symbol_tables[2]->get(symbol_tables[2], current_function));
        sprintf(buffer+strlen(buffer), "movi ra, [sp + 0]\n");
        sprintf(buffer+strlen(buffer), "addi sp, sp, 4\n");
        sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
        sprintf(buffer+strlen(buffer), "jr ra\n");
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_VOID) {
        // do nothing
    } else {
        printf("Invalid AST node in asm generation\n");
        exit(1);
    }
}

void asm_generator_code_gen_call_params(AST_Node *current_node, CharAppendList *asm_list, Dictionary **symbol_tables, DictionaryPointer *pointer_symbol_table, int *stack, int status, int *jmp_label, int register_select, int *pointer_layer_dereference, int *ast_modifier, int *visibility, char *current_function, ExtraStuff *extra_stuff) {
    /*
    r0 = zero constant
    r1,r2 = register a
    r3,r4 = register b
    r5,r6 = result register
    function parameters and local variables are stored on the stack
    the stack grows downwards from 0xffff to 0x0000
    */
    if (current_node->type == AST_MAIN || current_node->type == AST_BODY) {
        if (current_node->type == AST_MAIN) {
            asm_list->append(asm_list, "jmp _main\n\n");
        } else if (current_node->type == AST_FUNCTION) {
            char buffer[300] = {0};
            sprintf(buffer, "%s:\n", current_node->ast_string);
            asm_list->append(asm_list, buffer);
        }
        for (int i = 0; i < current_node->getSize(current_node); i++) {
            asm_generator_code_gen_call_params(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_list->append(asm_list, "\n");
        }
    } else if (current_node->type == AST_DECLARATION) {
        char buffer[300] = {0};
        // check for pointer or non-pointer declaration
        AST_Node *nextNode;
        nextNode = current_node;
        int is_pointer = 0;
        while (nextNode->getSize(nextNode) > 0) {
            nextNode = nextNode->getItem(nextNode, 0);
            if (nextNode->ast_string[0] == '*') {
                is_pointer = 1;
            }
        }
        *ast_modifier = current_node->modifier;
        AST_Node *recursive_node = current_node;
        while (recursive_node->type != AST_IDENT) {
            recursive_node = recursive_node->getItem(recursive_node, 0);
        }
        if (recursive_node->visibility == AST_STATIC) {
            if (is_pointer) {
                sprintf(buffer, ".word %s_ptr = 0\n", recursive_node->ast_string);
            } else {
                sprintf(buffer, ".word %s = 0\n", recursive_node->ast_string);
            }
            asm_list->append(asm_list, buffer);
        } else if (current_node->getItem(current_node, 0)->visibility == AST_LOCAL) {
            if (is_pointer) {
                //sprintf(buffer, "addi sp, sp, -2\n");
            } else {
                //sprintf(buffer, "addi sp, sp, -2\n");
            }
        }
        // SetVariable in Declaration
        if (current_node->getSize(current_node) == 2) {
            //asm_generator_code_gen(current_node->getItem(current_node, 1), asm_list, symbol_tables, pointer_symbol_table, stack+1, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
            current_node = current_node->getItem(current_node, 1);
            if (strcmp(current_node->ast_string, "=") == 0) {
                AST_Node *node_a = current_node;
                while (node_a->type != AST_IDENT) {
                    node_a = node_a->getItem(node_a, 0);
                }
                CharAppendList *operand_a = generateCharAppendList();
                CharAppendList *operand_b = generateCharAppendList();
                asm_generator_code_gen_call_params(node_a, operand_a, symbol_tables, pointer_symbol_table, stack, ASM_SET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                asm_generator_code_gen_call_params(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
                
                asm_list->append(asm_list, operand_b->array);
                asm_list->append(asm_list, operand_a->array);
            }
        }
        
    } else if (current_node->type == AST_SET_VARIABLE) {
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
    } else if (current_node->type == AST_OPERATOR && current_node->subtype == AST_MATH) {
        if (strcmp(current_node->ast_string, "=") == 0) {
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_SET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen_call_params(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operand_a->array);
        } else if (strcmp(current_node->ast_string, "<") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen_call_params(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            sprintf(buffer, "sub r%d, r%d, r%d\n", register_select, register_select+2, register_select);
            sprintf(buffer+strlen(buffer), "jnc %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "jz %d_false\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r1, r0, 0\n");
            sprintf(buffer+strlen(buffer), "jmp %d_false\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r1, r0, 1\n");
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;

            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, buffer);
        } else if (strcmp(current_node->ast_string, ">") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen_call_params(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            sprintf(buffer, "sub r%d, r%d, r%d\n", register_select, register_select+2, register_select);
            sprintf(buffer+strlen(buffer), "jc %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "jz %d_false\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r1, r0, 0\n");
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r1, r0, 1\n");
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;

            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
        } else if (strcmp(current_node->ast_string, "==") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen_call_params(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            char buffer[300] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            sprintf(buffer, "sub r%d, r%d, r%d\n", register_select, register_select+2, register_select);
            sprintf(buffer+strlen(buffer), "jz %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r1, r0, 0\n");
            sprintf(buffer+strlen(buffer), "jmp %d_false\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r1, r0, 1\n");
            sprintf(buffer+strlen(buffer), "jmp %d_end\n");
            sprintf(buffer+strlen(buffer), "jmp %d_false\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_end:\n", *jmp_label);
            *jmp_label += 1;

            operator->array = buffer;

            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
        } else {
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            int operand_a_pointer_dereference = 0;
            int operand_b_pointer_dereference = 0;
            asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, &operand_a_pointer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_generator_code_gen_call_params(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select+2, &operand_b_pointer_dereference, ast_modifier, visibility, current_function, extra_stuff);

            int operand_a_pointer_layer = 0;
            int operand_b_pointer_layer = 0;

            if (current_node->getItem(current_node, 0)->type == AST_IDENT) {
                operand_a_pointer_layer = symbol_tables[6]->get(symbol_tables[6], current_node->getItem(current_node, 0)->ast_string) - operand_a_pointer_dereference;
            }
            if (current_node->getItem(current_node, 1)->type == AST_IDENT) {
                operand_b_pointer_layer = symbol_tables[6]->get(symbol_tables[6], current_node->getItem(current_node, 1)->ast_string) - operand_b_pointer_dereference;
            }

            int pointer_arithmetic_shift_amount = 0;

            if (operand_a_pointer_layer == 1) {
                // pointer arithmetic (single layer)
                if (strcmp(current_node->ast_string, "+") == 0) { // add
                    char buffer[300] = {0};
                    pointer_arithmetic_shift_amount = ceil(log2(symbol_tables[7]->get(symbol_tables[7], current_node->getItem(current_node, 0)->ast_string)));
                    if (pointer_arithmetic_shift_amount > 0) {
                        sprintf(buffer, "sli r%i, r%i, %d\n", register_select+2, register_select+2, pointer_arithmetic_shift_amount);
                    }
                    sprintf(buffer+strlen(buffer), "add r%i, r%i, r%i\n", register_select, register_select+2, register_select);
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "-") == 0) { // subtract
                    char buffer[300] = {0};
                    sprintf(buffer, "sub r%i, r%i, r%i\n", register_select, register_select+2, register_select);
                    operator->array = buffer;
                }
            } else {
                if (strcmp(current_node->ast_string, "+") == 0) { // add
                    char buffer[300] = {0};
                    sprintf(buffer, "add r%i, r%i, r%i\n", register_select, register_select+2, register_select);
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "-") == 0) { // subtract
                    char buffer[300] = {0};
                    sprintf(buffer, "sub r%i, r%i, r%i\n", register_select, register_select+2, register_select);
                    operator->array = buffer;
                }
            }
            asm_list->append(asm_list, operand_a->array);
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operator->array);
        }
    } else if (current_node->type == AST_OPERATOR && current_node->subtype == AST_DEREFERENCE) {
        #define STACK_BASE 0x0010
        #define STATIC_BASE 0x0004
        #define IO_BASE 0x0013
        CharAppendList *operand = generateCharAppendList();
        if (status == ASM_SET) {
            int cancel_stack = -symbol_tables[0]->get(symbol_tables[0], current_node->getItem(current_node, 0)->ast_string);
            asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), asm_list, symbol_tables, pointer_symbol_table, &cancel_stack, ASM_SET, jmp_label, 7, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        } else {
            asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), operand, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, 7, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_list->append(asm_list, operand->array); // assume result stored in r1
            char buffer[300] = {0};
            int modifier = *ast_modifier;
            AST_Node *tail_node = current_node;
            while (tail_node->type != AST_IDENT) {
                tail_node = tail_node->getItem(tail_node, 0);
            }
            sprintf(buffer+strlen(buffer), "mov i0, r%d\n", extra_stuff->operator_stack_offset);
            if (modifier == NO_MODIFIER || current_node->subtype != AST_DEREFERENCE) {
                if (*visibility == AST_LOCAL) {
                    sprintf(buffer, "lui i1, %d\n", STACK_BASE); // use 32-bit index register to point anywhere in memory
                } else if (*visibility == AST_STATIC) {
                    sprintf(buffer, "lui i0, %d\n", STATIC_BASE); // use 32-bit index register to point anywhere in memory
                } else {
                    printf("Invalid visibility\n");
                    exit(1);
                }
            } else if (modifier == IO) {
                sprintf(buffer, "lui i1, %d\n", IO_BASE);
            } else if (modifier == MODIFIER_DATA) {
                sprintf(buffer, "lui i0, %d\n", STATIC_BASE);
            }
            
            /*
            if (symbol_tables[6].get(&symbol_tables[6], tail_node->ast_string) > 1) {
                // setting pointer (always 16-bit for now)
                if (status == ASM_GET) {
                    if (symbol_tables[3].get(&symbol_tables[3], tail_node->ast_string) == AST_LOCAL) {
                        sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], tail_node->ast_string));
                    } else {
                        sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, tail_node->ast_string);
                    }
                } else if (status == ASM_SET) {
                    if (symbol_tables[3].get(&symbol_tables[3], tail_node->ast_string) == AST_LOCAL) {
                        sprintf(buffer, "movi [sp + %d], r%i\n", symbol_tables[0].get(&symbol_tables[0], tail_node->ast_string), register_select);
                    } else {
                        sprintf(buffer, "movi [dp + %s], r%i\n", tail_node->ast_string, register_select);
                    }
                }
            } else {*/
                if (status == ASM_GET) {
                    if (symbol_tables[4]->get(symbol_tables[4], tail_node->ast_string) == CHAR) {
                        sprintf(buffer+strlen(buffer), "mvbi r1, [i0 + 0]\n");
                    } else {
                        sprintf(buffer+strlen(buffer), "movi r1, [i0 + 0]\n");
                    }
                } else if (status == ASM_SET) {
                    if (symbol_tables[4]->get(symbol_tables[4], tail_node->ast_string) == CHAR) {
                        sprintf(buffer+strlen(buffer), "mvbi [i0 + 0], r1\n");
                    } else {
                        sprintf(buffer+strlen(buffer), "movi [i0 + 0], r1\n");
                    }
                }
            //}
            asm_list->append(asm_list, buffer);
            *pointer_layer_dereference--;
        }
    } else if (current_node->type == AST_OPERATOR && current_node->subtype == AST_REFERENCE) {
        #define STACK_BASE 0x0010
        CharAppendList *operand = generateCharAppendList();
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), operand, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, operand->array); // assume result stored in r1
        char buffer[300] = {0};
        //sprintf(buffer, "addi i1, r0, %d\n", STACK_BASE); // use 32-bit index register to point anywhere in memory
        //sprintf(buffer+strlen(buffer), "mov i0, r1\n");
        if (status == ASM_GET) {
            sprintf(buffer+strlen(buffer), "addi r1, r0, %d\n", symbol_tables[0]->get(symbol_tables[0], current_node->getItem(current_node, 0)->ast_string), register_select);
        } else if (status == ASM_SET) {
            printf("Reference syntax error\n");
            exit(1);
            sprintf(buffer+strlen(buffer), "movi [i0 + 0], r1\n");
        }
        asm_list->append(asm_list, buffer);
        *pointer_layer_dereference++;
    } else if (current_node->type == AST_IDENT) {
        char buffer[300] = {0};
        if (symbol_tables[6]->get(symbol_tables[6], current_node->ast_string) > 0) {
            // setting pointer (always 16-bit for now)
            if (status == ASM_GET) {
                if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                    
                    //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                    sprintf(buffer, "movi r%d, [sp + %d] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                    //sprintf(buffer+strlen(buffer), "add r%d, r0, r1\n", extra_stuff->operator_stack_offset);
                    extra_stuff->operator_stack_offset += 1;
                } else {
                    
                    //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                    sprintf(buffer, "movi r%d, [dp + %s] ;GET\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                    //sprintf(buffer+strlen(buffer), "add r%d, r0, r1\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                    extra_stuff->operator_stack_offset += 1;
                }
            } else if (status == ASM_SET) {
                if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                    extra_stuff->operator_stack_offset += -1;
                    //sprintf(buffer, "movi [sp + %d], r%i\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack, register_select);
                    //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "movi [sp + %d], r%d ;SET\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack, extra_stuff->operator_stack_offset);
                    
                } else {
                    extra_stuff->operator_stack_offset += -1;
                    //sprintf(buffer, "movi [dp + %s], r%i\n", current_node->ast_string, register_select);
                    //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                    sprintf(buffer+strlen(buffer), "movi [dp + %s], r%d ;SET\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                    
                }
            } else if (status == ASM_GET_MEMORY) {
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [sp + %d] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        extra_stuff->operator_stack_offset += 1;
                    }
                } else if (status == ASM_SET_MEMORY) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [sp + %d] ;SET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s] ;SET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    }
                } else {
                    printf("status error\n");
                    exit(1);
                }
            }
        } else {
            // setting variable (char, int, uint8_t, etc.)
            if (status == ASM_GET) {
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "mvbi r%d, [sp + %d] ;/GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "mvbi r%d, [dp + %s] ;GET\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        extra_stuff->operator_stack_offset += 1;
                    }
                } else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [sp + %d] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s] ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    }
                }
            } else if (status == ASM_GET_MEMORY) {
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "mvbi r%d, [sp + %d] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "mvbi r%d, [dp + %s] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, current_node->ast_string);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        extra_stuff->operator_stack_offset += 1;
                    }
                } else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        
                        //sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        sprintf(buffer, "movi r%d, [sp + %d] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack);
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    } else {
                        
                        //sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                        sprintf(buffer, "movi r%d, [dp + %s] ;GET_MEMORY\n", extra_stuff->operator_stack_offset, symbol_tables[0]->get(symbol_tables[0], current_node->ast_string));
                        //sprintf(buffer+strlen(buffer), "add r%d, r0, r1 ;GET\n", extra_stuff->operator_stack_offset);
                        extra_stuff->operator_stack_offset += 1;
                    }
                }
            } else if (status == ASM_SET) {
                //if (symbol_tables[4]->get(symbol_tables[4], tail_node->ast_string) == AST_
                if (symbol_tables[4]->get(symbol_tables[4], current_node->ast_string) == CHAR) {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        extra_stuff->operator_stack_offset += -1;
                        //sprintf(buffer, "mvbi [sp + %d], r%i\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack, register_select);
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "mvbi [sp + %d], r%d ;SET\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack, extra_stuff->operator_stack_offset);
                        
                    } else {
                        extra_stuff->operator_stack_offset += -1;
                        //sprintf(buffer, "mvbi [dp + %s], r%i\n", current_node->ast_string, register_select);
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "mvbi [dp + %s], r%d ;SET\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                        
                        
                    }
                }
                else {
                    if (symbol_tables[3]->get(symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                        extra_stuff->operator_stack_offset += -1;
                        //sprintf(buffer, "movi [sp + %d], r%i\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack, register_select);
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "movi [sp + %d], r%d ;SET\n", symbol_tables[0]->get(symbol_tables[0], current_node->ast_string) + *stack, extra_stuff->operator_stack_offset);
                        
                    } else {
                        //sprintf(buffer, "movi [dp + %s], r%i\n", current_node->ast_string, register_select);
                        extra_stuff->operator_stack_offset += -1;
                        //sprintf(buffer, "add r1, r0, r%d ;SET\n", extra_stuff->operator_stack_offset);
                        sprintf(buffer+strlen(buffer), "movi [dp + %s], r%d ;SET\n", current_node->ast_string, extra_stuff->operator_stack_offset);
                        
                    }
                }
            }
        }
        asm_list->append(asm_list, buffer);
        *ast_modifier = symbol_tables[8]->get(symbol_tables[8], current_node->ast_string);
        *visibility = symbol_tables[3]->get(symbol_tables[3], current_node->ast_string);
    } else if (current_node->type == AST_LITERAL) {
        char buffer[300] = {0};
        if (status == ASM_SET) {
            //sprintf(buffer, "addi r1, r0, %s\n", current_node->ast_string);
            extra_stuff->operator_stack_offset += -1;
            sprintf(buffer, "movi [sp + %d], r%d ;SET\n", *stack, extra_stuff->operator_stack_offset);
           
        } else {
            sprintf(buffer, "addi r%i, r0, %s\n", register_select, current_node->ast_string);
            extra_stuff->operator_stack_offset += 1;
        }
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_IF) {
        //printf("If\n");
        CharAppendList *if_condition = generateCharAppendList();
        CharAppendList *if_body = generateCharAppendList();
        int start_jmp_label = *jmp_label;
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), if_condition, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 1), if_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, if_condition->array);
        asm_list->append(asm_list, if_body->array);
        char buffer[300] = {0};
        sprintf(buffer, "%d_false:\n", start_jmp_label);
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_WHILE) {
        CharAppendList *while_condition = generateCharAppendList();
        CharAppendList *while_body = generateCharAppendList();
        int start_jmp_label = *jmp_label;
        char buffer[300] = {0};
        sprintf(buffer, "%d_start:\n", start_jmp_label);
        asm_list->append(asm_list, buffer);
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), while_condition, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 1), while_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, while_condition->array);
        asm_list->append(asm_list, while_body->array);
        char buffer_b[50] = {0};
        sprintf(buffer_b, "jmp %d_start\n", start_jmp_label);
        sprintf(buffer_b+strlen(buffer_b), "%d_false:\n", start_jmp_label);
        asm_list->append(asm_list, buffer_b);
    } else if (current_node->type == AST_FOR) {
        CharAppendList *for_init = generateCharAppendList();
        CharAppendList *for_condition = generateCharAppendList();
        CharAppendList *for_iter = generateCharAppendList();
        CharAppendList *for_body = generateCharAppendList();
        int start_jmp_label = *jmp_label;
        char buffer[300] = {0};
        sprintf(buffer, "%d_start:\n", start_jmp_label);
        
        char buffer_b[50] = {0};
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), for_init, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 1), for_condition, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 2), for_iter, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 3), for_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        sprintf(buffer_b, "\n; for init\n");
        asm_list->append(asm_list, buffer_b);
        asm_list->append(asm_list, for_init->array);
        
        sprintf(buffer_b, "\n; for condition\n");
        asm_list->append(asm_list, buffer);
        asm_list->append(asm_list, buffer_b);
        
        asm_list->append(asm_list, for_condition->array);
        sprintf(buffer_b, "\n; for body\n");
        asm_list->append(asm_list, buffer_b);
        asm_list->append(asm_list, for_body->array);
        sprintf(buffer_b, "\n; for iter\n");
        asm_list->append(asm_list, buffer_b);
        asm_list->append(asm_list, for_iter->array);
        sprintf(buffer_b, "jmp %d_start\n", start_jmp_label);
        sprintf(buffer_b+strlen(buffer_b), "%d_false:\n", start_jmp_label);
        asm_list->append(asm_list, buffer_b);
    } else if (current_node->type == AST_FUNCTION_DECLARATION) {
        CharAppendList *function = generateCharAppendList();
        char buffer[300] = {0};
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), function, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, function->array);
    } else if (current_node->type == AST_FUNCTION) {
        CharAppendList *function_parameters = generateCharAppendList();
        CharAppendList *function_body = generateCharAppendList();
        char buffer[300] = {0};
        sprintf(buffer, "_%s:\n", current_node->ast_string);
        if (strcmp(current_node->ast_string, "main") == 0) {
            sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
            sprintf(buffer+strlen(buffer), "subi sp, sp, %d\n", symbol_tables[2]->get(symbol_tables[2], current_node->ast_string));
        } else {
            sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
            sprintf(buffer+strlen(buffer), "subi sp, sp, 4\n");
            sprintf(buffer+strlen(buffer), "movi [sp + 0], ra\n");
            sprintf(buffer+strlen(buffer), "subi sp, sp, %d\n", symbol_tables[2]->get(symbol_tables[2], current_node->ast_string));
        }
        asm_list->append(asm_list, buffer);
        // function parameters are evaluated in the asm pre-parser (first pass to evaluate symbol values)
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 1), function_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        char buffer_b[50] = {0};
        asm_list->append(asm_list, function_body->array);
        if (strcmp(current_node->ast_string, "main") == 0) {
            sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
            sprintf(buffer_b, "halt\n");
        } else {
            sprintf(buffer_b, "addi sp, sp, %d\n", symbol_tables[2]->get(symbol_tables[2], current_node->ast_string));
            sprintf(buffer_b+strlen(buffer_b), "movi ra, [sp + 0]\n");
            sprintf(buffer_b+strlen(buffer_b), "addi sp, sp, 4\n");
            sprintf(buffer_b+strlen(buffer_b), "jr ra\n");
        }
        asm_list->append(asm_list, buffer_b);
    } else if (current_node->type == AST_FUNCTION_CALL) {
        CharAppendList *function_parameters = generateCharAppendList();
        char buffer[300] = {0};
        asm_generator_code_gen_call_params(current_node->getItem(current_node, 0), function_parameters, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
        asm_list->append(asm_list, function_parameters->array);
        sprintf(buffer+strlen(buffer), "jal _%s\n", current_node->ast_string);
        sprintf(buffer+strlen(buffer), "add fp, r0, sp\n");
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_PARAMS) {
        CharAppendList *function_param_code = generateCharAppendList();
        char buffer[300] = {0};
        //sprintf(buffer, "movi [sp + 0], ra\n");
        //sprintf(buffer+strlen(buffer), "addi sp, sp, -2\n");
        for (int i = 0; i < current_node->getSize(current_node); i++) {
            asm_generator_code_gen_call_params(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_list->append(asm_list, buffer);
        }
    } else if (current_node->type == AST_CALL_PARAMS) {
        // call params will recurse on a different function to this main one, as the syntax requires different interpretation
        CharAppendList *function_param_code = generateCharAppendList();
        char buffer[300] = {0};
        //sprintf(buffer, "movi [sp + 0], ra\n");
        //sprintf(buffer+strlen(buffer), "addi sp, sp, -2\n");
        for (int i = 0; i < current_node->getSize(current_node); i++) {
            asm_generator_code_gen_call_params(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility, current_function, extra_stuff);
            asm_list->append(asm_list, buffer);
        }
    } else if (current_node->type == AST_STRING) {
        char buffer[300] = {0};
        sprintf(buffer, ".asciiz string_%d = \"%s\"\n", string_number++, current_node->ast_string);
        sprintf(buffer+strlen(buffer), "addi r%d, r0, %s\n", register_select, current_node->ast_string_name);
        asm_list->append(asm_list, buffer);
    } else {
        printf("Invalid AST node in asm generation\n");
        exit(1);
    }
}

char *asm_generator(AST_Node *start_node, DictionaryPointer *pointer_symbol_table, Dictionary **symbol_table) {
    // two pass AST traversal
    // first pass is to evaluate all local and static references and put into a symbol table
    // second pass is to do codegen

    CharAppendList *asm_list = malloc(sizeof(CharAppendList));
    CharAppendListInit(asm_list);

    Dictionary *symbol_tables = malloc(9*sizeof(Dictionary)); // local and static symbol table

    #define SYMBOL_LOCAL_VAR 0
    #define SYMBOL_STATIC_VAR 1
    #define SYMBOL_STACK_SIZE 2
    #define SYMBOL_VISIBILITY 3
    #define SYMBOL_DATATYPE 4
    #define SYMBOL_DATATYPE_SIZE 5
    #define SYMBOL_POINTER_LAYER 6
    #define SYMBOL_DEREFERNCE_SIZE 7
    #define SYMBOL_MODIFIER 8
    
    DictionaryInit(&symbol_tables[0]); // local variables
    DictionaryInit(&symbol_tables[1]); // static variables
    DictionaryInit(&symbol_tables[2]); // symbol table stack size
    DictionaryInit(&symbol_tables[3]); // variable visibility
    DictionaryInit(&symbol_tables[4]); // variable datatype enum (INT, CHAR, UINT8_T, etc.)
    DictionaryInit(&symbol_tables[5]); // variable datatype byte-size (INT: 2, CHAR: 1, UINT8_T: 1, Struct: 2^n bytes, POINTER = 2 bytes)
    DictionaryInit(&symbol_tables[6]); // variable pointer layers (int = 0, int* = 1, int** = 2, etc.)
    DictionaryInit(&symbol_tables[7]); // variable pointer dereferenced byte-size (INT: 2, CHAR: 1, UINT8_T: 1, Struct: 2^n bytes)
    DictionaryInit(&symbol_tables[8]); // modifier
    

    int jmp_label = 0;
    int stack = 0;
    int local_stack = 0;
    int heap = 0;
    int register_select = 0;
    //asm_generator_symbol_table(start_node, symbol_tables, pointer_symbol_table, &local_stack, &heap, "");
    //print_AST_tree(start_node);
    printf("starting asm gen\n");
    int pointer_layer_dereference = 0;
    string_number = 0;
    int ast_modifier = 0;
    int visibility = 0;
    char *current_function = "main";
    ExtraStuff extra_stuff = {0};
    extra_stuff.operator_stack_offset = 4;
    asm_generator_code_gen(start_node, asm_list, symbol_table, pointer_symbol_table, &stack, ASM_NONE, &jmp_label, 1, &pointer_layer_dereference, &ast_modifier, &visibility, current_function, &extra_stuff);
    asm_list->append(asm_list, "halt\n");
    return asm_list->array;
}

TokenList *lexer(char *input_file_buf, long fsize) {
    #define TOKEN_ARRAY_SIZE 1
    TokenList *tokenList = (TokenList*) malloc(1*sizeof(TokenList));
    TokenListInit(tokenList, TOKEN_ARRAY_SIZE);
    char sub_string[50] = {0};
    // read the input string until you reach a non-alphabetical character to parse the string into the lexer
    // first pass, just parse alphabetical keywords (for, while, if, etc.)
    // then second pass, parse for variable names and literals
    int j = 0;
    int token_index = 0;
    int token_type;
    int i = 0;
    int start_i = 0;
    int parse_finish = 0;
    // first check for keywords
    while (input_file_buf[i] != 0xFF && i < fsize) {
        parse_finish = 0;
        char current_char = input_file_buf[i];
        if (input_file_buf[i] == -1) {
            return tokenList;
        }
        start_i = i;
        while (check_letter_is_alphabet(input_file_buf[i])) {
            sub_string[j] = input_file_buf[i];
            i++;
            j++;
        }
        if (input_file_buf[i] == '"') {
            Token nextToken;
            i++;
            while (input_file_buf[i] != '"') {
                sub_string[j] = input_file_buf[i];
                i++;
                j++;
            }
            strcpy(nextToken.token_string, sub_string);
            printf("string detected: %s\n", sub_string);

            nextToken.token_valid = 1;
            nextToken.token_type = STRING;
            nextToken.token_subtype = TOKEN_NOSUBTYPE;
            nextToken.token_value = TOKEN_VALUE_NONE;
            nextToken.token_modifier = NO_MODIFIER;
            tokenList->append(tokenList, nextToken);
            parse_finish = 1;
            i++;
            parse_finish = 1;
        } else if (check_letter_is_not_alphabet(input_file_buf[i])) {
            // now to lexical analysis on sub_string
            //printf("sub_string = %s\n", sub_string);
            if (check_string_in_strings(MODIFIERS_SIZE, MODIFIERS, sub_string) != -1) {
                
            }
            else if (check_string_in_strings(KEYWORDS_SIZE, KEYWORDS, sub_string) != -1) {
                printf("keyword detected: %s\n", sub_string);
                Token nextToken;
                TokenInit(&nextToken);
                nextToken.token_valid = 1;
                nextToken.token_type = KEYWORD;
                nextToken.token_subtype = TOKEN_NOSUBTYPE;
                nextToken.token_value = check_string_in_strings(KEYWORDS_SIZE, KEYWORDS, sub_string);
                nextToken.token_modifier = NO_MODIFIER;
                strcpy(nextToken.token_string, sub_string);
                tokenList->append(tokenList, nextToken);
                start_i = i;
                parse_finish = 1;
            }
        clear_string(50, sub_string);
        j = 0;
        }
        if (parse_finish == 0) {
            i = start_i;
            while (check_letter_is_alphabet(input_file_buf[i])) {
                sub_string[j] = input_file_buf[i];
                i++;
                j++;
            }
            /*
            // now check modifiers (_io, near, far, code, etc.)
            if (check_letter_is_not_alphabet(input_file_buf[i])) {
                // now to lexical analysis on sub_string
                //printf("sub_string = %s\n", sub_string);
                if (check_string_in_strings(MODIFIERS_SIZE, MODIFIERS, sub_string) != -1) {
                    printf("modifier detected: %s\n", sub_string);
                    Token nextToken;
                    TokenInit(&nextToken);
                    nextToken.token_valid = 1;
                    nextToken.token_type = MODIFIER;
                    nextToken.token_subtype = TOKEN_NOSUBTYPE;
                    nextToken.token_value = check_string_in_strings(KEYWORDS_SIZE, KEYWORDS, sub_string);
                    nextToken.token_modifier = NO_MODIFIER;
                    if (strcmp(&sub_string, "_io") == 0) {
                        nextToken.token_modifier = IO;
                    } else if (strcmp(&sub_string, "_near") == 0) {
                        nextToken.token_modifier = NEAR;
                    } else if (strcmp(&sub_string, "_far") == 0) {
                        nextToken.token_modifier = FAR;
                    } else if (strcmp(&sub_string, "_data") == 0) {
                        nextToken.token_modifier = MODIFIER_DATA;
                    } else if (strcmp(&sub_string, "_code") == 0) {
                        nextToken.token_modifier = CODE;
                    }
                    strcpy(nextToken.token_string, sub_string);
                    tokenList->append(tokenList, nextToken);
                    start_i = i;
                    parse_finish = 1;
                    token_index++;
                    start_i = i;
                    parse_finish = 1;
                }
            clear_string(50, sub_string);
            j = 0;
            i++;
            }*/
        }
        clear_string(50, sub_string);
        j = 0;
        if (parse_finish == 0) {
            i = start_i;
            if (check_letter_is_not_alphabet(input_file_buf[i])) {
                sub_string[j] = input_file_buf[i];
                j++;
            }
            // now check separators
            if (check_letter_is_not_alphabet(input_file_buf[i])) {
                // now to lexical analysis on sub_string
                //printf("sub_string = %s\n", sub_string);
                if (check_string_in_strings(SEPARATORS_SIZE, SEPARATORS, sub_string) != -1) {
                    printf("separator detected: %s\n", sub_string);
                    Token nextToken;
                    TokenInit(&nextToken);
                    nextToken.token_valid = 1;
                    nextToken.token_type = SEPARATOR;
                    nextToken.token_subtype = TOKEN_NOSUBTYPE;
                    nextToken.token_value = check_string_in_strings(SEPARATORS_SIZE, SEPARATORS, sub_string);
                    nextToken.token_modifier = NO_MODIFIER;
                    strcpy(nextToken.token_string, sub_string);
                    tokenList->append(tokenList, nextToken);
                    token_index++;
                    start_i = i;
                    parse_finish = 1;
                }
            clear_string(50, sub_string);
            j = 0;
            i++;
            }
        }
        if (parse_finish == 0) {
            // now check operators
            i = start_i;
            int operator_string_idx = -1;
            int new_index_offset = 0;
            if (check_string_is_operator(input_file_buf+i, &operator_string_idx, &new_index_offset)) {
                strcpy(sub_string, OPERATORS[operator_string_idx]);
            }
            if (check_letter_is_not_alphabet(input_file_buf[i])) {
                // now to lexical analysis on sub_string
                //printf("sub_string = %s\n", sub_string);
                if (check_string_in_strings(OPERATORS_SIZE, OPERATORS, sub_string) != -1) {
                    printf("operator detected: %s\n", sub_string);
                    Token nextToken;
                    TokenInit(&nextToken);
                    nextToken.token_valid = 1;
                    nextToken.token_type = OPERATOR;
                    nextToken.token_subtype = TOKEN_NOSUBTYPE;
                    nextToken.token_value = check_string_in_strings(OPERATORS_SIZE, OPERATORS, sub_string);
                    nextToken.token_modifier = NO_MODIFIER;
                    strcpy(nextToken.token_string, OPERATORS[operator_string_idx]);
                    tokenList->append(tokenList, nextToken);
                    token_index++;
                    start_i = i;
                    parse_finish = 1;
                    i += new_index_offset;
                } else {
                    i++;
                }
            clear_string(50, sub_string);
            
            j = 0;
            }
        }
        if (parse_finish == 0) {
            // now check identifiers
            i = start_i;
                if (check_letter_is_number(input_file_buf[i])) {
                    //parse_finish = 0;
                    //break;
                }
            while (check_letter_is_alphabet(input_file_buf[i])) {
                if (check_letter_is_number(input_file_buf[i])) {
                    parse_finish = 0;
                    break;
                }
                sub_string[j] = input_file_buf[i];
                i++;
                j++;
            }
            // now check identifiers
            if (check_letter_is_not_alphabet(input_file_buf[i])) {
                // now to lexical analysis on sub_string
                //printf("sub_string = %s\n", sub_string);
                if (check_string_in_strings(KEYWORDS_SIZE, KEYWORDS, sub_string) != -1) {
                    parse_finish = 1;
                } else if (check_string_in_strings(SEPARATORS_SIZE, SEPARATORS, sub_string) != -1) {
                    parse_finish = 1;
                } else if (check_string_in_strings(OPERATORS_SIZE, OPERATORS, sub_string) != -1) {
                    parse_finish = 1;
                } else if (j > 0) {
                    // identifiers
                    printf("identifier detected: %s\n", sub_string);
                    if (!strcmp(sub_string, "main")) {
                        printf("main\n");
                    }
                    char *ident_string = (char *) malloc((j) * sizeof(char) + 1);
                    if (ident_string == NULL) {
                        printf("Memory allocation fail!\n");
                        exit(1);
                    }
                    strcpy(ident_string, sub_string);
                    Token nextToken;
                    TokenInit(&nextToken);
                    nextToken.token_valid = 1;
                    nextToken.token_type = IDENT;
                    nextToken.token_subtype = TOKEN_NOSUBTYPE;
                    nextToken.token_value = TOKEN_VALUE_NONE;
                    nextToken.token_modifier = NO_MODIFIER;
                    strcpy(nextToken.token_string, ident_string);
                    tokenList->append(tokenList, nextToken);
                    token_index++;
                    clear_string(50, sub_string);
                    j = 0;
                    parse_finish = 1;
                    start_i = i;
                }
            }
        }
        if (parse_finish == 0) {
            // now check literals
            i = start_i;
            while (check_letter_is_alphabet(input_file_buf[i])) {
                if (!check_letter_is_number(input_file_buf[i])) {
                    parse_finish = 0;
                    break;
                }
                sub_string[j] = input_file_buf[i];
                i++;
                j++;
            }
            // now check literals
            if (check_letter_is_not_alphabet(input_file_buf[i])) {
                // now to lexical analysis on sub_string
                //printf("sub_string = %s\n", sub_string);
                if (check_string_in_strings(KEYWORDS_SIZE, KEYWORDS, sub_string) != -1) {
                    parse_finish = 1;
                } else if (check_string_in_strings(SEPARATORS_SIZE, SEPARATORS, sub_string) != -1) {
                    parse_finish = 1;
                } else if (check_string_in_strings(OPERATORS_SIZE, OPERATORS, sub_string) != -1) {
                    parse_finish = 1;
                } else if (j > 0) {
                    // literals
                    printf("literal detected: %s\n", sub_string);
                    char *ident_string = (char *) malloc((j) * sizeof(char));
                    if (input_file_buf == NULL) {
                        printf("Memory allocation fail!\n");
                        exit(1);
                    }
                    strcpy(ident_string, sub_string);
                    Token nextToken;
                    TokenInit(&nextToken);
                    nextToken.token_valid = 1;
                    nextToken.token_type = LITERAL;
                    nextToken.token_subtype = TOKEN_NOSUBTYPE;
                    nextToken.token_value = TOKEN_VALUE_NONE;
                    nextToken.token_modifier = NO_MODIFIER;
                    strcpy(nextToken.token_string, ident_string);
                    tokenList->append(tokenList, nextToken);
                    token_index++;
                    clear_string(50, sub_string);
                    j = 0;
                    parse_finish = 1;
                    start_i = i;
                }
            }
        }
        if (parse_finish == 0) {
            i++;
        }
    }

    // Part 3 - Token array pass, disambiguous context-sensitive tokens (like multiplication operator and dereference operator)
    // Dereference operator is detected if an asterisk is detected but there's no identifier or literal before it in the expression.
    for (int i = 0; i < tokenList->getSize(tokenList); i++) {
        if (tokenList->getItem(tokenList, i).token_string[0] == '*') {
            if (tokenList->getItem(tokenList, i - 1).token_type == TOKEN_IDENT || tokenList->getItem(tokenList, i - 1).token_type == TOKEN_LITERAL || tokenList->getItem(tokenList, i - 1).token_string[0] == ')') {
                // '*' is a multiplication operator
                tokenList->getItemReference(tokenList, i)->token_subtype = TOKEN_MULTIPLICATION;
                printf("Multiplication operator set\n");
            } else {
                // else it's a derefernce operator
                sprintf(tokenList->getItemReference(tokenList, i)->token_string, "~*");
                tokenList->getItemReference(tokenList, i)->token_subtype = TOKEN_DEREFERENCE;
                tokenList->getItemReference(tokenList, i)->operator_single_child = 1;
                printf("Dereference operator set\n");
            }
        } else if (strcmp(tokenList->getItem(tokenList, i).token_string, "&") == 0) {
            if (tokenList->getItem(tokenList, i - 1).token_type == TOKEN_IDENT || tokenList->getItem(tokenList, i - 1).token_type == TOKEN_LITERAL || tokenList->getItem(tokenList, i - 1).token_string[0] == ')') {
                // '*' is a multiplication operator
                tokenList->getItemReference(tokenList, i)->token_subtype = TOKEN_AND;
                printf("Multiplication operator set\n");
            } else {
                // else it's a derefernce operator
                sprintf(tokenList->getItemReference(tokenList, i)->token_string, "~&");
                tokenList->getItemReference(tokenList, i)->token_subtype = TOKEN_REFERENCE;
                tokenList->getItemReference(tokenList, i)->operator_single_child = 1;
                printf("Reference operator set\n");
            }
        }
    }
    tokenList->print(tokenList);
    return tokenList;
}

Dictionary **symbol_pass(AST_Node *start_node) {
    CharAppendList *asm_list = (CharAppendList*) malloc(sizeof(CharAppendList));
    CharAppendListInit(asm_list);

    Dictionary *symbol_table = (Dictionary *) malloc(9*sizeof(Dictionary));
    Dictionary **symbol_tables = (Dictionary **) malloc(9*sizeof(Dictionary*));

    for (int i = 0; i < 9; i++) {
        symbol_tables[i] = &(symbol_table[i]);
    }

    #define SYMBOL_LOCAL_VAR 0
    #define SYMBOL_STATIC_VAR 1
    #define SYMBOL_STACK_SIZE 2
    #define SYMBOL_VISIBILITY 3
    #define SYMBOL_DATATYPE 4
    #define SYMBOL_DATATYPE_SIZE 5
    #define SYMBOL_POINTER_LAYER 6
    #define SYMBOL_DEREFERNCE_SIZE 7
    #define SYMBOL_MODIFIER 8
    
    DictionaryInit(symbol_tables[0]); // local variables
    DictionaryInit(symbol_tables[1]); // static variables
    DictionaryInit(symbol_tables[2]); // symbol table stack size
    DictionaryInit(symbol_tables[3]); // variable visibility
    DictionaryInit(symbol_tables[4]); // variable datatype enum (INT, CHAR, UINT8_T, etc.)
    DictionaryInit(symbol_tables[5]); // variable datatype byte-size (INT: 2, CHAR: 1, UINT8_T: 1, Struct: 2^n bytes, POINTER = 2 bytes)
    DictionaryInit(symbol_tables[6]); // variable pointer layers (int = 0, int* = 1, int** = 2, etc.)
    DictionaryInit(symbol_tables[7]); // variable pointer dereferenced byte-size (INT: 2, CHAR: 1, UINT8_T: 1, Struct: 2^n bytes)
    DictionaryInit(symbol_tables[8]); // modifier (no modifier, near, far, etc.)
    

    int jmp_label = 0;
    int stack = 0;
    int local_stack = 0;
    int heap = 0;
    int register_select = 0;

    Dictionary *pointer_symbol_table;

    asm_generator_symbol_table(start_node, symbol_tables, &pointer_symbol_table, &local_stack, &heap, "");
    return symbol_tables;
}

AST_Node *ast_adjust(AST_Node *current_node, Dictionary **symbol_tables) {
    // inserts type casts when necessary (i.e. converts 16-bit immediates to 32-bit for 32-bit operations).
    // or, if it finds a math operation where the identifier is 32-bit, and it has a literal on the second,
    // then it converts the 16-bit literal to a 32-bit (if it's not already 32-bit).

    // for future, this would affect floats too. So if ident is float, but literal is 16-bit int,
    // then it changes 16-bit int to a float ready for compatible asm gen.
    
    if (current_node->type == AST_IDENT) {
        return current_node;
    } else if (current_node->type == AST_LITERAL) {
        if (atoi(current_node->ast_string) > 65535 & current_node->type == AST_LITERAL) {
            // far ptr are 32-bit
            // convert operand_b to 32-bit
            current_node->type = AST_LITERAL_32;
            printf("Converted 16-bit literal to 32-bit");
                
        }
        return current_node;
    } else if (current_node->type == AST_OPERATOR) {
        if (strcmp(current_node->ast_string, "+") == 0) {
            AST_Node *operand_a = ast_adjust(current_node->getItem(current_node, 0), symbol_tables);
            AST_Node *operand_b = ast_adjust(current_node->getItem(current_node, 1), symbol_tables);
            if (operand_a->type == AST_IDENT) {
                if (atoi(operand_b->ast_string) > 65535 & operand_b->type == AST_LITERAL) {
                    // far ptr are 32-bit
                    // convert operand_b to 32-bit
                    //operand_b->type = AST_LITERAL_32;
                    //printf("Converted 16-bit literal to 32-bit");
                    //current_node->type = AST_OPERATOR_32;
                }
                //operand_a->type = AST_IDENT_32;
            } else if (operand_b->type == AST_IDENT) {
                if (atoi(operand_b->ast_string) > 65535 & operand_a->type == AST_LITERAL) {
                    //operand_a->type = AST_LITERAL_32;
                    //printf("Converted 16-bit literal to 32-bit");
                    //current_node->type = AST_OPERATOR_32;
                }
                //operand_b->type = AST_IDENT_32;
            }
        } else if (strcmp(current_node->ast_string, "=") == 0) {
            AST_Node *operand_a = ast_adjust(current_node->getItem(current_node, 0), symbol_tables);
            AST_Node *operand_b = ast_adjust(current_node->getItem(current_node, 1), symbol_tables);
            /*
            if (operand_a->type == AST_IDENT) {
                if (atoi(operand_b->ast_string) > 65535 & operand_b->type == AST_LITERAL) {
                    // far ptr are 32-bit
                    // convert operand_b to 32-bit
                    operand_b->type = AST_LITERAL_32;
                    printf("Converted 16-bit literal to 32-bit");
                    
                }
                operand_a->type = AST_IDENT_32;
                current_node->type = AST_OPERATOR_32;
            } else if (operand_b->type == AST_IDENT) {
                if (atoi(operand_a->ast_string) > 65535 & operand_a->type == AST_LITERAL) {
                    operand_a->type = AST_LITERAL_32;
                    printf("Converted 16-bit literal to 32-bit");
                }
                operand_b->type = AST_IDENT_32;
                current_node->type = AST_OPERATOR_32;
            }*/
        } else {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                ast_adjust(current_node->getItem(current_node, i), symbol_tables);
            }
        }
    } else if (current_node->getSize(current_node) == 0) {
        return current_node;
    } else {
        for (int i = 0; i < current_node->getSize(current_node); i++) {
            ast_adjust(current_node->getItem(current_node, i), symbol_tables);
        }
    }
    return current_node;
}

AST_Node *ast_adjust_2_active(AST_Node *current_node, Dictionary **symbol_tables);

AST_Node *ast_adjust_2_idle(AST_Node *current_node, Dictionary **symbol_tables) {
    // inserts type casts when necessary (i.e. converts 16-bit immediates to 32-bit for 32-bit operations).
    // or, if it finds a math operation where the identifier is 32-bit, and it has a literal on the second,
    // then it converts the 16-bit literal to a 32-bit (if it's not already 32-bit).

    // for future, this would affect floats too. So if ident is float, but literal is 16-bit int,
    // then it changes 16-bit int to a float ready for compatible asm gen.
    
    if (current_node->type == AST_IDENT) {
        return current_node;
    } else if (current_node->type == AST_LITERAL) {
        return current_node;
    } else if (current_node->type == AST_OPERATOR_32) {
        if (strcmp(current_node->ast_string, "+") == 0) {
            AST_Node *operand_a = ast_adjust_2_active(current_node->getItem(current_node, 0), symbol_tables);
            AST_Node *operand_b = ast_adjust_2_active(current_node->getItem(current_node, 1), symbol_tables);
            if (operand_a->type == AST_IDENT) {
                if (symbol_tables[SYMBOL_MODIFIER]->get(symbol_tables[SYMBOL_MODIFIER], operand_a->ast_string) == FAR && operand_b->type == AST_LITERAL) {
                    // far ptr are 32-bit
                    // convert operand_b to 32-bit
                    operand_b->type = AST_LITERAL_32;
                    printf("Converted 16-bit literal to 32-bit");
                }
                operand_a->type = AST_IDENT_32;
            } else if (operand_b->type == AST_IDENT) {
                if (symbol_tables[SYMBOL_MODIFIER]->get(symbol_tables[SYMBOL_MODIFIER], operand_b->ast_string) == FAR && operand_a->type == AST_LITERAL) {
                    operand_a->type = AST_LITERAL_32;
                    printf("Converted 16-bit literal to 32-bit");
                }
                operand_b->type = AST_IDENT_32;
            }
        } else if (strcmp(current_node->ast_string, "=") == 0) {
            AST_Node *operand_a = ast_adjust_2_active(current_node->getItem(current_node, 0), symbol_tables);
            AST_Node *operand_b = ast_adjust_2_active(current_node->getItem(current_node, 1), symbol_tables);
            //current_node->type = AST_OPERATOR_32;
            if (operand_a->type == AST_IDENT) {
                if (symbol_tables[SYMBOL_MODIFIER]->get(symbol_tables[SYMBOL_MODIFIER], operand_a->ast_string) == FAR && operand_b->type == AST_LITERAL) {
                    // far ptr are 32-bit
                    // convert operand_b to 32-bit
                    operand_b->type = AST_LITERAL_32;
                    printf("Converted 16-bit literal to 32-bit");
                }
                operand_a->type = AST_IDENT_32;
            } else if (operand_b->type == AST_IDENT) {
                if (symbol_tables[SYMBOL_MODIFIER]->get(symbol_tables[SYMBOL_MODIFIER], operand_b->ast_string) == FAR && operand_a->type == AST_LITERAL) {
                    operand_a->type = AST_LITERAL_32;
                    printf("Converted 16-bit literal to 32-bit");
                }
                operand_b->type = AST_IDENT_32;
            }
        } else {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                ast_adjust_2_idle(current_node->getItem(current_node, i), symbol_tables);
            }
        }
    } else if (current_node->getSize(current_node) == 0) {
        return current_node;
    } else {
        for (int i = 0; i < current_node->getSize(current_node); i++) {
            ast_adjust_2_idle(current_node->getItem(current_node, i), symbol_tables);
        }
    }
    return current_node;
}

AST_Node *ast_adjust_2_active(AST_Node *current_node, Dictionary **symbol_tables) {
    // inserts type casts when necessary (i.e. converts 16-bit immediates to 32-bit for 32-bit operations).
    // or, if it finds a math operation where the identifier is 32-bit, and it has a literal on the second,
    // then it converts the 16-bit literal to a 32-bit (if it's not already 32-bit).

    // for future, this would affect floats too. So if ident is float, but literal is 16-bit int,
    // then it changes 16-bit int to a float ready for compatible asm gen.
    
    if (current_node->type == AST_IDENT) {
        return current_node;
    } else if (current_node->type == AST_LITERAL) {
        return current_node;
    } else if (current_node->type == AST_OPERATOR) {
        if (strcmp(current_node->ast_string, "+") == 0) {
            AST_Node *operand_a = ast_adjust_2_active(current_node->getItem(current_node, 0), symbol_tables);
            AST_Node *operand_b = ast_adjust_2_active(current_node->getItem(current_node, 1), symbol_tables);
            current_node->type = AST_OPERATOR_32;
            if (operand_a->type == AST_IDENT) {
                if (symbol_tables[SYMBOL_MODIFIER]->get(symbol_tables[SYMBOL_MODIFIER], operand_a->ast_string) == FAR && operand_b->type == AST_LITERAL) {
                    // far ptr are 32-bit
                    // convert operand_b to 32-bit
                    operand_b->type = AST_LITERAL_32;
                    printf("Converted 16-bit literal to 32-bit");
                }
                operand_a->type = AST_IDENT_32;
            } else if (operand_b->type == AST_IDENT) {
                if (symbol_tables[SYMBOL_MODIFIER]->get(symbol_tables[SYMBOL_MODIFIER], operand_b->ast_string) == FAR && operand_a->type == AST_LITERAL) {
                    operand_a->type = AST_LITERAL_32;
                    printf("Converted 16-bit literal to 32-bit");
                }
                operand_b->type = AST_IDENT_32;
            }
        } else if (strcmp(current_node->ast_string, "=") == 0) {
            AST_Node *operand_a = ast_adjust_2_active(current_node->getItem(current_node, 0), symbol_tables);
            AST_Node *operand_b = ast_adjust_2_active(current_node->getItem(current_node, 1), symbol_tables);
            current_node->type = AST_OPERATOR_32;
            if (operand_a->type == AST_IDENT) {
                if (symbol_tables[SYMBOL_MODIFIER]->get(symbol_tables[SYMBOL_MODIFIER], operand_a->ast_string) == FAR && operand_b->type == AST_LITERAL) {
                    // far ptr are 32-bit
                    // convert operand_b to 32-bit
                    operand_b->type = AST_LITERAL_32;
                    printf("Converted 16-bit literal to 32-bit");
                }
                operand_a->type = AST_IDENT_32;
            } else if (operand_b->type == AST_IDENT) {
                if (symbol_tables[SYMBOL_MODIFIER]->get(symbol_tables[SYMBOL_MODIFIER], operand_b->ast_string) == FAR && operand_a->type == AST_LITERAL) {
                    operand_a->type = AST_LITERAL_32;
                    printf("Converted 16-bit literal to 32-bit");
                }
                operand_b->type = AST_IDENT_32;
            }
        } else {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                ast_adjust_2_active(current_node->getItem(current_node, i), symbol_tables);
            }
        }
    } else if (current_node->getSize(current_node) == 0) {
        return current_node;
    } else {
        for (int i = 0; i < current_node->getSize(current_node); i++) {
            ast_adjust_2_active(current_node->getItem(current_node, i), symbol_tables);
        }
    }
    return current_node;
}

int main(int argc, char* argv[]) {
    char *input_file_str;
    printf("ZaC-2 C Compiler\n");
    // Part 0 - initialisation
    input_file_str = "printtest.c";
    /*
    if (argc < 2) {
        printf("Not enough arguments!\n");
        input_file_str = "far_ptr_test.c";
    } else {
        input_file_str = argv[1];
    }
    */
    FILE *input_file, *output_file;
    

    input_file = fopen(input_file_str, "rb");
    output_file = fopen("c_program.asm", "wb");
    //printf("input_file = %p\n", input_file);
    //printf("output_file = %p\n", output_file);


    // ------------------------------
    // MANUAL ARRAYS, DO NOT TOUCH!!!
    // MANUAL ARRAYS, DO NOT TOUCH!!!
    // MANUAL ARRAYS, DO NOT TOUCH!!!
    // MANUAL ARRAYS, DO NOT TOUCH!!!
    //
    // get filesize
    fseek(input_file, 0, SEEK_END);
    long fsize = ftell(input_file);
    fseek(input_file, 0, SEEK_SET);
    const int padding = 100;

    char *input_file_buf = (char *) malloc((fsize+padding) * sizeof(char));
    if (input_file_buf == NULL) {
        printf("Memory allocation fail!\n");
        exit(1);
    } else {
        printf("Memory allocation successful at %p\n", input_file_buf);
    }

    // initialise input file buffer
    for (int i = 0; i < (fsize+padding); i++) {
        input_file_buf[i] = 0xFF;
    }

    // read input file into buffer
    fread(input_file_buf, sizeof(char), fsize, input_file);
    //
    // MANUAL ARRAYS, DO NOT TOUCH!!!
    // MANUAL ARRAYS, DO NOT TOUCH!!!
    // MANUAL ARRAYS, DO NOT TOUCH!!!
    // MANUAL ARRAYS, DO NOT TOUCH!!!
    // ------------------------------

    DictionaryPointer *pointer_symbol_table;
    //DictionaryPointerInit(pointer_symbol_table); // pointer chain (_io, near, far, code)
    
    // Part 1 - Pre-processor
    // Evalulates macros, defines, includes and removes comments

    // Part 2 and 3 - Lexer and tokenList modifier
    // Lexer will be just a static struct array
    TokenList *tokenList = lexer(input_file_buf, fsize);

    // Part 4 - Token array parser / AST generation
    // AST will be generated via a malloc struct tree with 4 childs per node
    int local_idx = 0;
    int iter = 0;
    const int iter_end = 10000;
    
    AST_Node *start_node = generate_ast_node();
    start_node->type = AST_MAIN;
    while (iter < iter_end && local_idx < tokenList->getSize(tokenList)) {
        local_idx = statement(tokenList, local_idx, start_node, AST_NONE_VISIBILITY);
        iter++;
    }
    if (iter >= iter_end) {
        printf("Iteration end\n");
        exit(1);
    }
    //print_AST_tree(start_node);
    
    printf("AST Iter count: %d\n", iter);

    // Part 6 - AST adjuster
    // Examples: inserts type casts when necessary (i.e. converts 16-bit immediates to 32-bit for 32-bit operations).

    Dictionary **symbol_table = symbol_pass(start_node);
    ast_adjust(start_node, symbol_table);
    print_AST_tree(start_node);


    // Part 5 - AST parser / ASM generator
    // Generates asm code for assembler.
    printf("\nAssembly output:\n");
    char *asm_output;
    
    asm_output = asm_generator(start_node, pointer_symbol_table, symbol_table);
    printf("%s\n", asm_output);
    
    // Part 6 - Machine code generator
    printf("input_file = %p\n", input_file);
    printf("output_file = %p\n", output_file);
    fprintf(output_file, "%s", asm_output);
    fclose(input_file);
    fclose(output_file);
    printf("Complete\n");
    //pause();
    system("asm.exe");
    return 0;
}


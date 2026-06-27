/*
C Compiler for ZaC-2, 16-bit CPU with 24-bit address bus.

ZaC-2 supports 2 types of pointer, 16-bit pointer and 32-bit pointer (hardware 24-bit). For now, the C compiler will ONLY support 16-bit pointers 
which point in the data section. Historically, the 8088/8086 and 286 C compilers supported near and far pointers, which were 16-bit and 32-bit.
This is quite tricky to implement with mixed-size pointers, and so to keep it simple, all pointers will be 16-bit. Integers are also 16-bit (-32768 to 32767).

NEAR TODO:
    - zcc32 is a 32-bit version of zcc, which uses 32-bit pointers, removing the need for near/far segmented memory. However this requires 2 cycles for every 
    memory access on the 16-bit machine.

FAR TODO:
    - ZaC-3 will be fully 32-bit CPU, and so 32-bit ints, 32-bit pointers, etc. Although it will still use the same backplane, but it will have a different bus protocol.
    32-bit A/D. It will flip-flop 32-bit address and 32-bit data depending on the A/D signal (A/D low = address, A/D high = data). And since this only takes 33 pins
    out of the 40 pins required for full 16-bit data and 24-bit address, then it can work on the existing ZaC-2 16-bit backplane, just reprogram the FPGAs to support
    32-bit A/D bus. This is NOT backwards compatible with 16-bit hardware though. But this isn't an issue because the hardware is FPGA-based, so just reflash it to
    support 32-bit A/D.
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


#define KEYWORDS_SIZE 15
#define SEPARATORS_SIZE 6
#define OPERATORS_SIZE 21
#define WHITE_SPACE_SIZE 3
#define MODIFIERS_SIZE 4
char *KEYWORDS[KEYWORDS_SIZE] = {"void", "int", "char", "uint8_t", "uint16_t", "int8_t", "int16_t", "static", "if", "while", "for", "else", "asm", "struct", "return"};
char *SEPARATORS[SEPARATORS_SIZE] = {"{", "}", "(", ")", ";", ","};
char *OPERATORS[OPERATORS_SIZE] = {"++", "--", "==", ">=", "<=", "!=", "&&", "<<", ">>", "||", "->", ".", "+", "-", "<", "*", "/", ">", "!", "=", "&"};
char *WHITE_SPACE[WHITE_SPACE_SIZE] = {" ", "\n", "\t"};

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
    char alphabet[] = " +-~*/(){}[]&.,;=<>\"\'\n\t";
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
        return 0;
    } else if (strcmp(operator, "<=") == 0) {
        return 0;
    } else if (strcmp(operator, ">=") == 0) {
        return 0;
    } else if (strcmp(operator, "<") == 0) {
        return 0;
    } else if (strcmp(operator, ">") == 0) {
        return 0;
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
        return 4;
    } else if (strcmp(operator, "(") == 0 || strcmp(operator, ")") == 0) {
        return -1;
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
        ast_literal->visibility = AST_NONE_VISIBILITY;
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
                    params->type = AST_PARAMS;
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
                    // modifier token (near, far, _i/o, code)
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

void print_AST_type(AST_Node *node) {
    if (node->type == AST_DECLARATION) {
        printf("Declaration");
        printf(" %s", node->ast_string);
    } else if (node->type == AST_EXPRESSION) {
        printf("Expression");
    } else if (node->type == AST_SET_VARIABLE) {
        printf("SetVariable");
    } else if (node->type == AST_IDENT) {
        printf("Identifier");
        printf(" %s", node->ast_string);
    } else if (node->type == AST_OPERATOR) {
        printf("Operator");
        printf(" %s", node->ast_string);
    } else if (node->type == AST_LITERAL) {
        printf("Literal");
        printf(" %s", node->ast_string);
    } else if (node->type == AST_MAIN) {
        printf("Main");
    } else if (node->type == AST_FUNCTION) {
        printf("Function");
        printf(" %s", node->ast_string);
    } else if (node->type == AST_FUNCTION_CALL) {
        printf("FunctionCall");
        printf(" %s", node->ast_string);
    } else if (node->type == AST_IF) {
        printf("If");
    } else if (node->type == AST_WHILE) {
        printf("While");
    } else if (node->type == AST_FOR) {
        printf("For");
    } else if (node->type == AST_BODY) {
        printf("Body");
    } else if (node->type == AST_PARAMS) {
        printf("Parameters");
    } else if (node->type == AST_FUNCTION_DECLARATION) {
        printf("FunctionDeclaration");
        printf(" %s", node->ast_string);
    } else if (node->type == AST_RETURN) {
        printf("Return");
    } else if (node->type == AST_VOID) {
        printf("Void");
    } else if (node->type == AST_STRING) {
        printf("String ");
        printf("%s: ", node->ast_string_name);
        printf("\"%s\"", node->ast_string);
    } else if (node->type == AST_MODIFIER) {
        printf("Modifier ");
    }
    if (node->subtype == AST_DEREFERENCE) {
        printf(" Dereference");
    } else if (node->subtype == AST_REFERENCE) {
        printf(" Reference");
    }
    if (node->visibility == AST_STATIC) {
        printf(" Static");
    } else if (node->visibility == AST_LOCAL) {
        printf(" Local");
    }
}

void print_AST_tree_aux(AST_Node *node, int tab_level) {
    for (int i = 0; i < tab_level; i++) {
        printf("\t");
    }
    printf("* ");
    print_AST_type(node);
    
    printf("\n");
    for (int i = 0; i < node->getSize(node); i++) {
        print_AST_tree_aux(node->getItem(node, i), tab_level + 1);
    }
}

void print_AST_tree(AST_Node *node) {
    printf("\n");
    print_AST_tree_aux(node, 0);
    printf("* End\n");
}



void asm_generator_symbol_table(AST_Node *current_node, Dictionary *symbol_tables, DictionaryPointer *pointer_symbol_table, int *stack, int *heap, char *current_function) {
    if (current_node->type != AST_DECLARATION) {
        if (current_node->type == AST_MAIN) {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
        } else if (current_node->type == AST_FUNCTION_DECLARATION) {
            asm_generator_symbol_table(current_node->getItem(current_node, 0), symbol_tables, pointer_symbol_table, stack, heap, current_function);
        } else if (current_node->type == AST_FUNCTION) {
            *stack = 2;
            printf("Function %s:\n", current_node->ast_string);
            current_function = current_node->ast_string;
            asm_generator_symbol_table(current_node->getItem(current_node, 0), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            asm_generator_symbol_table(current_node->getItem(current_node, 1), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            symbol_tables[2].set(&symbol_tables[2], *stack, current_node->ast_string);
            printf("size: %d\n", symbol_tables[2].get(&symbol_tables[2], current_node->ast_string));
            printf("\n");
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
                asm_generator_symbol_table(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, &param_stack, heap, current_function);
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
        int pointer_layer = 0;
        char pointer_layer_string[100] = {0};
        while (strcmp(declare_node->ast_string, "~*") == 0) {
            declare_node = declare_node->getItem(declare_node, 0);
            pointer_layer_string[pointer_layer] = '*';
            pointer_layer++;
        }
        char *var_string = calloc(100, sizeof(char));
        sprintf(var_string, "%s", declare_node->ast_string);
        int datatype_size = 0;
        int dereferenced_var_size = 0;
        if (pointer_layer > 0) {
            // pointers always have datatype size of 2 bytes
            datatype_size = 2;
        }
        if (current_node->token_value == INT) {
            // int datatype has 2 bytes
            dereferenced_var_size = 2;
        } else if (current_node->token_value == CHAR) {
            dereferenced_var_size = 1;
        }
        if (declare_node->visibility == AST_LOCAL) {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
            printf("local variable \"%s\" set offset: %d, type: %s%s, pointer size: %d, dereferenced size: %d\n", declare_node->ast_string, *stack, current_node->ast_string, pointer_layer_string, datatype_size, dereferenced_var_size);
            symbol_tables[0].set(&symbol_tables[0], *stack, declare_node->ast_string);
            symbol_tables[3].set(&symbol_tables[3], AST_LOCAL, declare_node->ast_string);
            symbol_tables[4].set(&symbol_tables[4], current_node->token_value, declare_node->ast_string);
            symbol_tables[5].set(&symbol_tables[5], datatype_size, declare_node->ast_string);
            symbol_tables[6].set(&symbol_tables[6], pointer_layer, declare_node->ast_string);
            symbol_tables[7].set(&symbol_tables[7], dereferenced_var_size, declare_node->ast_string);
            if (pointer_layer > 0) {
                *stack += 4;
            } else {
                *stack += 2;
            }
        }
        else if (declare_node->visibility == AST_STATIC) {
            for (int i = 0; i < current_node->getSize(current_node); i++) {
                asm_generator_symbol_table(current_node->getItem(current_node, i), symbol_tables, pointer_symbol_table, stack, heap, current_function);
            }
            printf("static variable \"%s\" set offset: %d, type: %s%s, pointer size: %d, dereferenced size: %d\n", declare_node->ast_string, *heap, current_node->ast_string, pointer_layer_string, datatype_size, dereferenced_var_size);
            symbol_tables[1].set(&symbol_tables[1], *heap, declare_node->ast_string);
            symbol_tables[3].set(&symbol_tables[3], AST_STATIC, declare_node->ast_string);
            symbol_tables[4].set(&symbol_tables[4], current_node->token_value, declare_node->ast_string);
            symbol_tables[5].set(&symbol_tables[5], datatype_size, declare_node->ast_string);
            symbol_tables[6].set(&symbol_tables[6], pointer_layer, declare_node->ast_string);
            symbol_tables[7].set(&symbol_tables[7], dereferenced_var_size, declare_node->ast_string);
            if (pointer_layer > 0) {
                *heap += 4;
            } else {
                *heap += 2;
            }
        }
    }
}

enum asm_gen {
    ASM_NONE,
    ASM_SET,
    ASM_GET
};



void asm_generator_code_gen(AST_Node *current_node, CharAppendList *asm_list, Dictionary *symbol_tables, DictionaryPointer *pointer_symbol_table, int stack, int status, int *jmp_label, int register_select, int *pointer_layer_dereference, int *ast_modifier, int *visibility) {
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
            char buffer[100] = {0};
            sprintf(buffer, "%s:\n", current_node->ast_string);
            asm_list->append(asm_list, buffer);
        }
        for (int i = 0; i < current_node->getSize(current_node); i++) {
            asm_generator_code_gen(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, 0, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
            asm_list->append(asm_list, "\n");
        }
    } else if (current_node->type == AST_DECLARATION) {
        char buffer[50] = {0};
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
            asm_generator_code_gen(current_node->getItem(current_node, 1), asm_list, symbol_tables, pointer_symbol_table, stack+1, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
        }
        
    } else if (current_node->type == AST_SET_VARIABLE) {
        asm_generator_code_gen(current_node->getItem(current_node, 0), asm_list, symbol_tables, pointer_symbol_table, stack+1, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
    } else if (current_node->type == AST_OPERATOR && current_node->subtype == AST_MATH) {
        if (strcmp(current_node->ast_string, "=") == 0) {
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_SET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
            
            asm_list->append(asm_list, operand_b->array);
            asm_list->append(asm_list, operand_a->array);
        } else if (strcmp(current_node->ast_string, "<") == 0) {
            //printf("== operator\n");
            CharAppendList *operand_a = generateCharAppendList();
            CharAppendList *operand_b = generateCharAppendList();
            CharAppendList *operator = generateCharAppendList();
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack+1, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility);
            char buffer[100] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            sprintf(buffer, "sub r%d, r%d, r%d\n", register_select, register_select+2, register_select);
            sprintf(buffer+strlen(buffer), "jzc %d_true\n", *jmp_label);
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
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack+1, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility);
            char buffer[100] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            sprintf(buffer, "sub r%d, r%d, r%d\n", register_select, register_select+2, register_select);
            sprintf(buffer+strlen(buffer), "jc %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "jz %d_false\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r1, r0, 0\n");
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r1, r0, 1\n");
            sprintf(buffer+strlen(buffer), "jmp %d_false\n", *jmp_label);
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
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack+1, ASM_GET, jmp_label, register_select+2, pointer_layer_dereference, ast_modifier, visibility);
            char buffer[100] = {0};
            // subtract to compare (if a - b == 0: a and b are equal)
            sprintf(buffer, "sub r%d, r%d, r%d\n", register_select, register_select+2, register_select);
            sprintf(buffer+strlen(buffer), "jz %d_true\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r1, r0, 0\n");
            sprintf(buffer+strlen(buffer), "jmp %d_end\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "%d_true:\n", *jmp_label);
            sprintf(buffer+strlen(buffer), "addi r1, r0, 1\n");
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
            asm_generator_code_gen(current_node->getItem(current_node, 0), operand_a, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, &operand_a_pointer_dereference, ast_modifier, visibility);
            asm_generator_code_gen(current_node->getItem(current_node, 1), operand_b, symbol_tables, pointer_symbol_table, stack + 1, ASM_GET, jmp_label, register_select+2, &operand_b_pointer_dereference, ast_modifier, visibility);

            int operand_a_pointer_layer = 0;
            int operand_b_pointer_layer = 0;

            if (current_node->getItem(current_node, 0)->type == AST_IDENT) {
                operand_a_pointer_layer = symbol_tables[6].get(&symbol_tables[6], current_node->getItem(current_node, 0)->ast_string) - operand_a_pointer_dereference;
            }
            if (current_node->getItem(current_node, 1)->type == AST_IDENT) {
                operand_b_pointer_layer = symbol_tables[6].get(&symbol_tables[6], current_node->getItem(current_node, 1)->ast_string) - operand_b_pointer_dereference;
            }

            int pointer_arithmetic_shift_amount = 0;

            if (operand_a_pointer_layer == 1) {
                // pointer arithmetic (single layer)
                if (strcmp(current_node->ast_string, "+") == 0) { // add
                    char buffer[50] = {0};
                    pointer_arithmetic_shift_amount = ceil(log2(symbol_tables[7].get(&symbol_tables[7], current_node->getItem(current_node, 0)->ast_string)));
                    if (pointer_arithmetic_shift_amount > 0) {
                        sprintf(buffer, "sli r%i, r%i, %d\n", register_select+2, register_select+2, pointer_arithmetic_shift_amount);
                    }
                    sprintf(buffer+strlen(buffer), "add r%i, r%i, r%i\n", register_select, register_select+2, register_select);
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "-") == 0) { // subtract
                    char buffer[50] = {0};
                    sprintf(buffer, "sub r%i, r%i, r%i\n", register_select, register_select+2, register_select);
                    operator->array = buffer;
                }
            } else {
                if (strcmp(current_node->ast_string, "+") == 0) { // add
                    char buffer[50] = {0};
                    sprintf(buffer, "add r%i, r%i, r%i\n", register_select, register_select+2, register_select);
                    operator->array = buffer;
                } else if (strcmp(current_node->ast_string, "-") == 0) { // subtract
                    char buffer[50] = {0};
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
        asm_generator_code_gen(current_node->getItem(current_node, 0), operand, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, 7, pointer_layer_dereference, ast_modifier, visibility);
        asm_list->append(asm_list, operand->array); // assume result stored in r1
        char buffer[50] = {0};
        int modifier = *ast_modifier;
        AST_Node *tail_node = current_node;
        while (tail_node->type != AST_IDENT) {
            tail_node = tail_node->getItem(tail_node, 0);
        }
        sprintf(buffer, "movi r1, [sp + %d]\n", symbol_tables[0].get(&symbol_tables[0], tail_node->ast_string)+1); // use 32-bit index register to point anywhere in memory
        sprintf(buffer+strlen(buffer), "mov i0, r7\n");

        if (status == ASM_GET) {
            if (symbol_tables[4].get(&symbol_tables[4], tail_node->ast_string) == CHAR) {
                sprintf(buffer+strlen(buffer), "mvbi r1, [i0 + 0]\n");
            } else {
                sprintf(buffer+strlen(buffer), "movi r1, [i0 + 0]\n");
            }
        } else if (status == ASM_SET) {
            if (symbol_tables[4].get(&symbol_tables[4], tail_node->ast_string) == CHAR) {
                sprintf(buffer+strlen(buffer), "mvbi [i0 + 0], r1\n");
            } else {
                sprintf(buffer+strlen(buffer), "movi [i0 + 0], r1\n");
            }
        }
        asm_list->append(asm_list, buffer);
        *pointer_layer_dereference--;
    } else if (current_node->type == AST_OPERATOR && current_node->subtype == AST_REFERENCE) {
        #define STACK_BASE 0x0010
        CharAppendList *operand = generateCharAppendList();
        asm_generator_code_gen(current_node->getItem(current_node, 0), operand, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
        asm_list->append(asm_list, operand->array); // assume result stored in r1
        char buffer[50] = {0};
        //sprintf(buffer, "addi i1, r0, %d\n", STACK_BASE); // use 32-bit index register to point anywhere in memory
        //sprintf(buffer+strlen(buffer), "mov i0, r1\n");
        if (status == ASM_GET) {
            sprintf(buffer+strlen(buffer), "addi r1, r0, %d\n", symbol_tables[0].get(&symbol_tables[0], current_node->getItem(current_node, 0)->ast_string), register_select);
        } else if (status == ASM_SET) {
            printf("Reference syntax error\n");
            exit(1);
            sprintf(buffer+strlen(buffer), "movi [i0 + 0], r1\n");
        }
        asm_list->append(asm_list, buffer);
        *pointer_layer_dereference++;
    } else if (current_node->type == AST_IDENT) {
        char buffer[50] = {0};
        if (status == ASM_GET) {
            if (symbol_tables[4].get(&symbol_tables[4], current_node->ast_string) == CHAR) {
                if (symbol_tables[3].get(&symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                    sprintf(buffer, "mvbi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string));
                } else {
                    sprintf(buffer, "mvbi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                }
            }
            else {
                if (symbol_tables[3].get(&symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                    sprintf(buffer, "movi r%i, [sp + %d]\n", register_select, symbol_tables[0].get(&symbol_tables[0], current_node->ast_string));
                } else {
                    sprintf(buffer, "movi r%i, [dp + %s]\n", register_select, current_node->ast_string);
                }
            }
        } else if (status == ASM_SET) {
            //if (symbol_tables[4].get(&symbol_tables[4], tail_node->ast_string) == AST_
            if (symbol_tables[4].get(&symbol_tables[4], current_node->ast_string) == CHAR) {
                if (symbol_tables[3].get(&symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                    sprintf(buffer, "mvbi [sp + %d], r%i\n", symbol_tables[0].get(&symbol_tables[0], current_node->ast_string), register_select);
                } else {
                    sprintf(buffer, "mvbi [dp + %s], r%i\n", current_node->ast_string, register_select);
                }
            }
            else {
                if (symbol_tables[3].get(&symbol_tables[3], current_node->ast_string) == AST_LOCAL) {
                    sprintf(buffer, "movi [sp + %d], r%i\n", symbol_tables[0].get(&symbol_tables[0], current_node->ast_string), register_select);
                } else {
                    sprintf(buffer, "movi [dp + %s], r%i\n", current_node->ast_string, register_select);
                }
            }
        }
        asm_list->append(asm_list, buffer);
        //*ast_modifier = symbol_tables[8].get(&symbol_tables[8], current_node->ast_string);
        *visibility = symbol_tables[3].get(&symbol_tables[3], current_node->ast_string);
    } else if (current_node->type == AST_LITERAL) {
        char buffer[50] = {0};
        sprintf(buffer, "addi r%i, r0, %s\n", register_select, current_node->ast_string);
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_IF) {
        //printf("If\n");
        CharAppendList *if_condition = generateCharAppendList();
        CharAppendList *if_body = generateCharAppendList();
        int start_jmp_label = *jmp_label;
        asm_generator_code_gen(current_node->getItem(current_node, 0), if_condition, symbol_tables, pointer_symbol_table, stack+1, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
        asm_generator_code_gen(current_node->getItem(current_node, 1), if_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
        asm_list->append(asm_list, if_condition->array);
        asm_list->append(asm_list, if_body->array);
        char buffer[50] = {0};
        sprintf(buffer, "%d_false:\n", start_jmp_label);
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_WHILE) {
        CharAppendList *while_condition = generateCharAppendList();
        CharAppendList *while_body = generateCharAppendList();
        int start_jmp_label = *jmp_label;
        char buffer[50] = {0};
        sprintf(buffer, "%d_start:\n", start_jmp_label);
        asm_list->append(asm_list, buffer);
        asm_generator_code_gen(current_node->getItem(current_node, 0), while_condition, symbol_tables, pointer_symbol_table, stack+1, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
        asm_generator_code_gen(current_node->getItem(current_node, 1), while_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
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
        char buffer[50] = {0};
        sprintf(buffer, "%d_start:\n", start_jmp_label);
        
        char buffer_b[50] = {0};
        asm_generator_code_gen(current_node->getItem(current_node, 0), for_init, symbol_tables, pointer_symbol_table, stack+1, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
        asm_generator_code_gen(current_node->getItem(current_node, 1), for_condition, symbol_tables, pointer_symbol_table, stack+1, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
        asm_generator_code_gen(current_node->getItem(current_node, 2), for_iter, symbol_tables, pointer_symbol_table, stack+1, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
        asm_generator_code_gen(current_node->getItem(current_node, 3), for_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
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
        char buffer[50] = {0};
        asm_generator_code_gen(current_node->getItem(current_node, 0), function, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
        asm_list->append(asm_list, function->array);
    } else if (current_node->type == AST_FUNCTION) {
        CharAppendList *function_parameters = generateCharAppendList();
        CharAppendList *function_body = generateCharAppendList();
        char buffer[50] = {0};
        sprintf(buffer, "_%s:\n", current_node->ast_string);
        if (strcmp(current_node->ast_string, "main") == 0) {
            sprintf(buffer+strlen(buffer), "addi sp, sp, -%d\n", symbol_tables[2].get(&symbol_tables[2], current_node->ast_string));
        } else {
            sprintf(buffer+strlen(buffer), "addi sp, sp, -2\n");
            sprintf(buffer+strlen(buffer), "movi [sp + 0], ra\n");
            sprintf(buffer+strlen(buffer), "addi sp, sp, -%d\n", symbol_tables[2].get(&symbol_tables[2], current_node->ast_string));
        }
        asm_list->append(asm_list, buffer);
        // function parameters are evaluated in the asm pre-parser (first pass to evaluate symbol values)
        asm_generator_code_gen(current_node->getItem(current_node, 1), function_body, symbol_tables, pointer_symbol_table, stack, ASM_NONE, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
        char buffer_b[50] = {0};
        asm_list->append(asm_list, function_body->array);
        if (strcmp(current_node->ast_string, "main") == 0) {
            sprintf(buffer_b, "halt\n");
        } else {
            sprintf(buffer_b, "addi sp, sp, %d\n", symbol_tables[2].get(&symbol_tables[2], current_node->ast_string));
            sprintf(buffer_b+strlen(buffer_b), "movi ra, [sp + 0]\n");
            sprintf(buffer_b+strlen(buffer_b), "addi sp, sp, -2\n");
            sprintf(buffer_b+strlen(buffer_b), "jr ra\n");
        }
        asm_list->append(asm_list, buffer_b);
    } else if (current_node->type == AST_FUNCTION_CALL) {
        CharAppendList *function_parameters = generateCharAppendList();
        char buffer[50] = {0};
        asm_generator_code_gen(current_node->getItem(current_node, 0), function_parameters, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
        asm_list->append(asm_list, function_parameters->array);
        sprintf(buffer+strlen(buffer), "jal _%s\n", current_node->ast_string);
        asm_list->append(asm_list, buffer);
    } else if (current_node->type == AST_PARAMS) {
        CharAppendList *function_param_code = generateCharAppendList();
        char buffer[50] = {0};
        //sprintf(buffer, "movi [sp + 0], ra\n");
        //sprintf(buffer+strlen(buffer), "addi sp, sp, -2\n");
        for (int i = 0; i < current_node->getSize(current_node); i++) {
            asm_generator_code_gen(current_node->getItem(current_node, i), asm_list, symbol_tables, pointer_symbol_table, stack, ASM_GET, jmp_label, register_select, pointer_layer_dereference, ast_modifier, visibility);
            asm_list->append(asm_list, buffer);
        }
    } else if (current_node->type == AST_STRING) {
        char buffer[50] = {0};
        sprintf(buffer, ".asciiz string_%d = \"%s\"\n", string_number++, current_node->ast_string);
        sprintf(buffer+strlen(buffer), "addi r%d, r0, %s\n", register_select, current_node->ast_string_name);
        asm_list->append(asm_list, buffer);
    } else {
        printf("Invalid AST node in asm generation\n");
        exit(1);
    }
}



char *asm_generator(AST_Node *start_node, DictionaryPointer *pointer_symbol_table) {
    // two pass AST traversal
    // first pass is to evaluate all local and static references and put into a symbol table
    // second pass is to do codegen

    CharAppendList *asm_list = malloc(sizeof(CharAppendList));
    CharAppendListInit(asm_list);
    Dictionary *symbol_tables = malloc(9*sizeof(Dictionary)); // local and static symbol table
    
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
    int heap = 0;
    int register_select = 0;
    asm_generator_symbol_table(start_node, symbol_tables, pointer_symbol_table, &stack, &heap, "");
    //print_AST_tree(start_node);
    int pointer_layer_dereference = 0;
    string_number = 0;
    int ast_modifier = 0;
    int visibility = 0;
    asm_generator_code_gen(start_node, asm_list, symbol_tables, pointer_symbol_table, 0, ASM_NONE, &jmp_label, 1, &pointer_layer_dereference, &ast_modifier, &visibility);
    asm_list->append(asm_list, "halt\n");
    return asm_list->array;
}

int main() {
    printf("ZaC-2 C Compiler\n");
    // Part 0 - initialisation
    FILE *input_file, *output_file;
    input_file = fopen("string_test32.c", "r");
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
    const int padding = 10;

    char *input_file_buf = (char *) malloc((fsize+padding) * sizeof(char));
    if (input_file_buf == NULL) {
        printf("Memory allocation fail!\n");
        exit(1);
    } else {
        printf("Memory allocation successful at %p\n", input_file_buf);
    }

    // initialise input file buffer
    for (int i = 0; i < (fsize); i++) {
        input_file_buf[i] = ' ';
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

    // Part 2 - Lexer
    // Lexer will be just a static struct array
    #define TOKEN_ARRAY_SIZE 50
    TokenList tokenList;
    TokenListInit(&tokenList, TOKEN_ARRAY_SIZE);
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
    while (i < fsize) {
        parse_finish = 0;
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
            tokenList.append(&tokenList, nextToken);
            parse_finish = 1;
            i++;
            parse_finish = 1;
        } else if (check_letter_is_not_alphabet(input_file_buf[i])) {
            // now to lexical analysis on sub_string
            //printf("sub_string = %s\n", sub_string);
            if (check_string_in_strings(KEYWORDS_SIZE, KEYWORDS, sub_string) != -1) {
                printf("keyword detected: %s\n", sub_string);
                Token nextToken;
                TokenInit(&nextToken);
                nextToken.token_valid = 1;
                nextToken.token_type = KEYWORD;
                nextToken.token_subtype = TOKEN_NOSUBTYPE;
                nextToken.token_value = check_string_in_strings(KEYWORDS_SIZE, KEYWORDS, sub_string);
                nextToken.token_modifier = NO_MODIFIER;
                strcpy(nextToken.token_string, sub_string);
                tokenList.append(&tokenList, nextToken);
                start_i = i;
                parse_finish = 1;
            }
        clear_string(50, sub_string);
        j = 0;
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
                    tokenList.append(&tokenList, nextToken);
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
            // now check separators
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
                    tokenList.append(&tokenList, nextToken);
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
                    char *ident_string = (char *) malloc((j) * sizeof(char));
                    if (input_file_buf == NULL) {
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
                    tokenList.append(&tokenList, nextToken);
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
                    tokenList.append(&tokenList, nextToken);
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
    for (int i = 0; i < tokenList.getSize(&tokenList); i++) {
        if (tokenList.getItem(&tokenList, i).token_string[0] == '*') {
            if (tokenList.getItem(&tokenList, i - 1).token_type == TOKEN_IDENT || tokenList.getItem(&tokenList, i - 1).token_type == TOKEN_LITERAL || tokenList.getItem(&tokenList, i - 1).token_string[0] == ')') {
                // '*' is a multiplication operator
                tokenList.getItemReference(&tokenList, i)->token_subtype = TOKEN_MULTIPLICATION;
                printf("Multiplication operator set\n");
            } else {
                // else it's a derefernce operator
                sprintf(tokenList.getItemReference(&tokenList, i)->token_string, "~*");
                tokenList.getItemReference(&tokenList, i)->token_subtype = TOKEN_DEREFERENCE;
                tokenList.getItemReference(&tokenList, i)->operator_single_child = 1;
                printf("Dereference operator set\n");
            }
        } else if (strcmp(tokenList.getItem(&tokenList, i).token_string, "&") == 0) {
            if (tokenList.getItem(&tokenList, i - 1).token_type == TOKEN_IDENT || tokenList.getItem(&tokenList, i - 1).token_type == TOKEN_LITERAL || tokenList.getItem(&tokenList, i - 1).token_string[0] == ')') {
                // '*' is a multiplication operator
                tokenList.getItemReference(&tokenList, i)->token_subtype = TOKEN_AND;
                printf("Multiplication operator set\n");
            } else {
                // else it's a derefernce operator
                sprintf(tokenList.getItemReference(&tokenList, i)->token_string, "~&");
                tokenList.getItemReference(&tokenList, i)->token_subtype = TOKEN_REFERENCE;
                tokenList.getItemReference(&tokenList, i)->operator_single_child = 1;
                printf("Reference operator set\n");
            }
        }
    }
    



    // Part 4 - Token array parser / AST generation
    // AST will be generated via a malloc struct tree with 4 childs per node
    int local_idx = 0;
    int iter = 0;
    const int iter_end = 10000;
    
    AST_Node *start_node = generate_ast_node();
    start_node->type = AST_MAIN;
    while (iter < iter_end && local_idx < tokenList.getSize(&tokenList)) {
        local_idx = statement(&tokenList, local_idx, start_node, AST_NONE_VISIBILITY);
        iter++;
    }
    //print_AST_tree(start_node);
    print_AST_tree(start_node);
    printf("AST Iter count: %d\n", iter);
    // Part 5 - AST parser / ASM generator
    
    
    printf("\nAssembly output:\n");
    
    char *asm_output;
    asm_output = asm_generator(start_node, pointer_symbol_table);
    printf("%s\n", asm_output);
    
    


    // Part 6 - Machine code generator

    
    printf("input_file = %p\n", input_file);
    printf("output_file = %p\n", output_file);
    fprintf(output_file, "%s", asm_output);
    fclose(input_file);
    fclose(output_file);
    printf("Complete\n");
    //pause();
    return 0;
}


#include <stdio.h>
#include <stdlib.h>

#include "token_value.h"
#include "AST_Node.h"

enum token_type {
    IDENT,
    KEYWORD,
    SEPARATOR,
    OPERATOR,
    LITERAL,
    STRING,
    MODIFIER,
    INVALID,
    TOKEN_FUNCTION,
    LITERAL_32BIT
};

enum token_modifier {
    NO_MODIFIER,
    IO,
    NEAR,
    FAR,
    MODIFIER_DATA,
    CODE
};

#define TOKEN_OPERATOR OPERATOR
#define TOKEN_LITERAL LITERAL
#define TOKEN_IDENT IDENT
#define TOKEN_STRING STRING


enum token_subtype {
    TOKEN_NOSUBTYPE,
    TOKEN_MULTIPLICATION, // a*b;
    TOKEN_AND, // a&b;
    TOKEN_DEREFERENCE, // *p;
    TOKEN_REFERENCE // &p;
};

#define TOKEN_STRING_SIZE 50

typedef struct Token {
    int token_valid;
    int token_type;
    int token_subtype;
    int token_value;
    int token_literal;
    int function_tree_valid;
    int operator_single_child;
    int token_modifier;
    AST_Node *function_tree;
    char token_string[TOKEN_STRING_SIZE];
} Token;

void TokenInit(Token *self) {
    self->function_tree_valid = 0;
    self->operator_single_child = 0;
    for (int i = 0; i < TOKEN_STRING_SIZE; i++) {
        self->token_string[i] = 0;
    }
}

typedef struct TokenList {
    // data
    int valid;
    int size;
    int array_size;
    Token *array;

    // methods
    void (*build)(struct TokenList*, int);
    void (*append)(struct TokenList*, struct Token);
    Token (*getItem)(struct TokenList*, int);
    Token *(*getItemReference)(struct TokenList*, int);
    char *(*getStringReference)(struct TokenList*, int);
    int (*getSize)(struct TokenList*);
    void (*push)(struct TokenList*, struct Token);
    Token (*pop)(struct TokenList*);
    Token (*peek)(struct TokenList*);
    int (*isEmpty)(struct TokenList*);
    int (*isNotEmpty)(struct TokenList*);
    void (*destroy)(struct TokenList*);
    void (*print)(struct TokenList*);
} TokenList;

void _TokenList_New(TokenList *self, int size) {
    if (size < 0) {
        printf("Invalid TokenList size!\n");
        exit(1);
    }
    int internal_size = size;
    if (size == 0) {
        internal_size = 10; // some default size
    }
    Token *new_array = (Token *) malloc((internal_size) * sizeof(Token));
    if (!new_array) {
        printf("TokenList Allocation Error!\n");
        printf("ArraySize %d\n", internal_size);
        printf("StackSize %d\n", size);
        exit(1);
    }
    for (int i = 0; i < internal_size; i++) {
        TokenInit(&new_array[i]);
    }

    //printf("Allocated TokenList\n");
    self->size = 0;
    self->array_size = internal_size;
    self->array = new_array;
    self->valid = 1;
}

void _TokenList_Append(TokenList *self, Token token) {
    if (self->size >= (self->array_size)) {
        int new_array_size = ((self->array_size + 10) * 2);
        Token *realloc_array = (Token *) realloc(self->array, sizeof(Token) * new_array_size);
        if (!realloc_array) {
            printf("\nTokenList Reallocation Error!\n");
            printf("OldArraySize %d\n", self->array_size);
            printf("NewArraySize %d\n", new_array_size);
            printf("StackSize %d\n", self->size);
            exit(1);
        }
        //printf("Reallocated TokenList\n");
        self->array = realloc_array;
        self->array_size = new_array_size;
    }
    self->array[self->size] = token;
    self->size++;
}

Token _TokenList_getItem(TokenList *self, int index) {
    if (index < 0 || index >= self->size || index >= self->array_size) {
        printf("TokenList Out Of Bounds Error! Index: %d\n", index);
        exit(1);
    }
    return self->array[index];
}

void _TokenList_Push(TokenList *self, Token token) {
    self->append(self, token);
}

int _TokenList_getSize(TokenList *self) {
    return self->size;
}

Token _TokenList_Pop(TokenList *self) {
    if (self->size == 0) {
        printf("Invalid pop, stack size is zero!\n");
        exit(1);
    }
    
    Token output = self->getItem(self, self->size - 1);
    self->size--;
    return output;

}

Token _TokenList_Peek(TokenList *self) {
    if (self->size == 0) {
        printf("Invalid peek, stack size is zero!\n");
        exit(1);
    }
    return self->getItem(self, self->size - 1);
}

int _TokenList_isEmpty(TokenList *self) {
    return self->size == 0;
}

int _TokenList_isNotEmpty(TokenList *self) {
    return self->size > 0;
}

Token *_TokenList_getItemReference(TokenList *self, int index) {
    if (index < 0 || index >= self->size || index >= self->array_size) {
        printf("TokenList Out Of Bounds Error!\n");
        exit(1);
    }
    return &self->array[index];
}

char *_TokenList_getStringReference(TokenList *self, int index) {
        if (index < 0 || index >= self->size || index >= self->array_size) {
        printf("TokenList Out Of Bounds Error!\n");
        exit(1);
    }
    return &(self->array[index].token_string[0]);
}

void *setFunctionTree(TokenList *self, int index, AST_Node *tree) {
    Token *current_token = self->getItemReference(self, index);
    current_token->function_tree = tree;
    current_token->function_tree_valid = 1;
}

AST_Node *getFunctionTree(TokenList *self, int index) {
    Token *current_token = self->getItemReference(self, index);
    if (current_token->function_tree_valid) {
        return current_token->function_tree;
    } else {
        printf("Invalid Function Tree!\n");
        exit(1);
    }
}

void _TokenList_Print(TokenList *self) {
    int size = self->getSize(self);
    FILE * file_ptr;
    file_ptr = fopen("lexer_log.txt", "w");
    if (file_ptr == NULL) {
        printf("File open error\n");
        exit(1);
    }
    fprintf(file_ptr, "\n---- TOKEN LIST START ----\n");
    for (int i = 0; i < size; i++) {
        fprintf(file_ptr, "%s ", self->getStringReference(self, i));
        if (self->getStringReference(self, i)[0] == ';') {
            fprintf(file_ptr, "\n", self->getStringReference(self, i));
        }
    }
    fprintf(file_ptr, "\n---- TOKEN LIST END ----\n");
    fclose(file_ptr);
}

void _TokenList_Destroy(TokenList *self) {
    for (int i = 0; i < self->size; i++) {
        self->array[i].function_tree_valid = 0;
        free(&self->array[i]);
    }
    free(self->array);
    // null the interface functions so if a future invalid call will segfault
    self->build = NULL;
    self->append = NULL;
    self->getItem = NULL;
    self->destroy = NULL;
    self->valid = 0;
}



void TokenListInit(TokenList *self, int size) {
    self->build = &_TokenList_New;
    self->append = &_TokenList_Append;
    self->getItem = &_TokenList_getItem;
    self->getItemReference = &_TokenList_getItemReference;
    self->getStringReference = &_TokenList_getStringReference;
    self->getSize = &_TokenList_getSize;
    self->isEmpty = &_TokenList_isEmpty;
    self->isNotEmpty = &_TokenList_isNotEmpty;
    self->destroy = &_TokenList_Destroy;
    self->push = &_TokenList_Push;
    self->pop = &_TokenList_Pop;
    self->peek = &_TokenList_Peek;
    self->print = &_TokenList_Print;
    self->build(self, size); // make new TokenList size 5
}

TokenList *generateTokenList() {
    TokenList *newTokenList = (TokenList *) malloc(sizeof(TokenList) * 1);
    TokenListInit(newTokenList, 0);
    return newTokenList;
}


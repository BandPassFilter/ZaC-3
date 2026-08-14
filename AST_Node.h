#include <stdio.h>
#include <stdlib.h>


// I WILL HAVE TWO TYPES OF AST NODES.
// INSTRUCTION NODES, AND DATA NODES.
// DO NOT PUT DATA INTO INSTRUCTION NODES.
// SET_VARIABLE IS AN INSTRUCTION NODE.
// DECLARE_VARIABLE IS AN INSTRUCTION NODE.

// INSTRUCTION NDOES HAVE DATA NODES AS CHILDREN FOR THE DATA.
// INT, CHAR, UINT8_T, UINT16_T, ARE DATA NODES.

enum AST_purpose {
    INSTRUCTION,
    DATA
};

enum AST_type {
    AST_INVALID,
    AST_FUNCTION_DECLARATION,
    AST_DECLARATION,
    AST_EXPRESSION,
    AST_SET_VARIABLE,
    AST_IDENT,
    AST_OPERATOR,
    AST_LITERAL,
    AST_MAIN,
    AST_FUNCTION,
    AST_FUNCTION_CALL,
    AST_BODY,
    AST_IF,
    AST_FOR,
    AST_WHILE,
    AST_PARAMS,
    AST_CALL_PARAMS,
    AST_PARAM,
    AST_VOID,
    AST_STRING,
    AST_RETURN,
    AST_IN,
    AST_OUT,
    AST_MODIFIER,
    AST_CAST,
    AST_LITERAL_32,
    AST_OPERATOR_32,
    AST_IDENT_32,
    AST_SET_VARIABLE_32
};

#ifndef GLOBAL_I
#define GLOBAL_I
enum AST_subtype {
    AST_NOSUBTYPE,
    AST_DEREFERENCE,
    AST_REFERENCE,
    AST_MATH
};
#endif

enum AST_visbility {
    AST_NONE_VISIBILITY,
    AST_LOCAL,
    AST_STATIC
};

enum AST_modifier {
    AST_NO_MODIFIER,
    AST_IO,
    AST_NEAR,
    AST_FAR,
    AST_DATA,
    AST_CODE
};

enum AST_datatype {
    AST_DATA_NODATA,
    AST_DATA_INT16,
    AST_DATA_UINT16,
    AST_DATA_INT32,
    AST_DATA_UINT32,
    AST_DATA_INT8,
    AST_DATA_UINT8,
    AST_DATA_CHAR,
    AST_DATA_FLOAT32
};

typedef struct AST_Node {
    // data
    int valid;
    int END_NODE;
    int type; // AST_type
    int subtype;
    int value;
    int purpose;
    int visibility;
    int operator_single_child;
    int token_value;
    int pointer_layer;
    int modifier;
    int datatype;
    int operand_size; // 8 = 8-bit, 16 = 16-bit, 32 = 32-bit, etc.
    struct _AST_List *list;
    char *ast_string;
    char *ast_string_name[50];
    struct AST_Node* parent;

    // methods
    void (*build)(struct AST_Node*);
    void (*append)(struct AST_Node*, struct AST_Node*);
    struct AST_Node *(*getItem)(struct AST_Node*, int index);
    int (*getSize)(struct AST_Node*);
    void (*destroy)(struct AST_Node*); // this will recursively destroy child nodes as well via iteration through the list
} AST_Node;

// ASTList is a private object used by AST_Node for the n-ary child nodes
typedef struct _AST_List {
    int valid;
    int size;
    int array_size;
    AST_Node **array; // list of AST_Node pointers
} _AST_List;

void _AST_List_new(AST_Node *self) {
    _AST_List *my_list = (_AST_List*) malloc(1 * sizeof(_AST_List));
    self->list = my_list;
    #define NEW_LIST_SIZE 5
    AST_Node **new_array = (AST_Node**) malloc(NEW_LIST_SIZE * sizeof(AST_Node*));
    if (new_array == NULL) {
        printf("ASTList Allocation error!\n");
        exit(1);
    }
    //printf("Allocated ASTList\n");
    self->list->array = new_array;
    self->list->size = 0;
    self->list->array_size = NEW_LIST_SIZE;
    self->list->valid = 1;
    self->valid = 1;
    self->END_NODE = 1;
}

void _AST_List_append(AST_Node *self, AST_Node *node) {
    if (!self->valid) {
        printf("Invalid node!\n");
        exit(1);
    }
    if (self->list->size >= (self->list->array_size)) {
        int new_size = (self->list->array_size * 2);
        AST_Node **new_array = (AST_Node **) realloc(self->list->array, new_size * sizeof(AST_Node*));
        if (!new_array) {
            printf("ASTList Allocation Error! Size: %d\n", self->list->size);
            exit(1);
        }
        //printf("Reallocated ASTList\n");
        self->list->array = new_array;
        self->list->array_size = new_size;
    }
    
    self->list->array[self->list->size] = node;
    self->list->size++;
    self->END_NODE = 0;
}

int _AST_List_getSize(AST_Node *self) {
    return self->list->size;
}

AST_Node *_AST_getItem(AST_Node *self, int index) {
    if (index < 0 || index >= self->list->size) {
        printf("AST_Node out of bounds!\n");
        exit(1);
    }
    if (!self->list->valid) {
        printf("Invalid node!\n");
        exit(1);
    }
    return self->list->array[index];
}

void _AST_List_destroy(AST_Node *self) {
    if (!self->list->valid) {
        printf("Invalid node destroy!\n");
        exit(1);
    }
    //for (int i = 0; i < self->getSize(self); i++) {
        // free individual nodes
    //    free(self->getItem(self, i));
    //}
    //free(self->list->array);
    self->list->size = 0;
    self->list->array_size = 0;
    self->list->valid = 0;
}

void AST_Node_init(AST_Node *self) {
    self->build = &_AST_List_new;
    self->append = &_AST_List_append;
    self->getItem = &_AST_getItem;
    self->destroy = &_AST_List_destroy;
    self->getSize = &_AST_List_getSize;
    self->valid = 0; // not valid until new array created
    self->subtype = AST_NOSUBTYPE;
    self->build(self);
}

void clear_ast_node(AST_Node *node) {
    node->value = 0;
    node->valid = 0;
    node->type = 0;
    node->token_value = TOKEN_VALUE_NONE;
    node->pointer_layer = 0;
    node->modifier = AST_NO_MODIFIER;
    node->datatype = AST_DATA_NODATA;
    AST_Node_init(node);
}

AST_Node *generate_ast_node() {
    AST_Node *new_node = (AST_Node *) malloc(1 * sizeof(AST_Node));
    if (new_node == NULL) {
        printf("generate ast node fail!\n");
        exit(1);
    } else {
        clear_ast_node(new_node);
        new_node->valid = 1;
        return new_node;
    }
}
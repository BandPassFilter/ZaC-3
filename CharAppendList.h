#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct CharAppendList {
    // data
    int size;
    int array_size;
    char *array;

    // methods
    void (*build)(struct CharAppendList*);
    void (*append)(struct CharAppendList*, char *string);
    char *(*getList)(struct CharAppendList*);
} CharAppendList;

void _CharAppendList_build(CharAppendList *self) {
    #define STRING_ARRAY_SIZE 1
    self->array_size = STRING_ARRAY_SIZE;
    char *new_array = (char *)malloc(STRING_ARRAY_SIZE * sizeof(char));
    if (!new_array) {
        printf("CharAppendList Allocation Error!\n");
        exit(1);
    }
    self->array = new_array;
}

void _CharAppendList_append(CharAppendList *self, char *string) {
    int string_size = strlen(string);
    long new_size = (self->array_size + string_size) * 2 * sizeof(char);
    //printf("CharAppendList realloc attempt %p\n", self);
    //printf("    array size: %d, string size %d\n", self->array_size, strlen(string));
    //printf("    new array size: %d, new list size: %d\n", new_size, self->size);
    if (self->size + string_size >= (self->array_size / 2)) {
        char *new_array = (char *)realloc(self->array, new_size);
        //printf("realloaction\n");
        if (!new_array) {
            printf("CharAppendList Reallocation Error! Size: %d\n", new_size);
            exit(1);
        }
        self->array = new_array;
        self->array_size = new_size;
        //printf("CharAppendList reallocation success\n");
    }
    //printf("CharAppendList append success %p\n", self);
    
    //strcpy(&self->array[self->size], string);
    for (int i = 0; i < string_size+1; i++) {
        self->array[self->size + i] = string[i];
    }
    self->size += string_size;
    printf("    String copy success\n");
}

char *_CharAppendList_getList(CharAppendList *self) {
    return self->array;
}

void CharAppendListInit(CharAppendList *self) {
    self->size = 0;
    self->array_size = 0;
    self->array = (char*)NULL;

    self->build = &_CharAppendList_build;
    self->append = &_CharAppendList_append;
    self->getList = &_CharAppendList_getList;
    self->build(self);
}

CharAppendList *generateCharAppendList() {
    CharAppendList *list = (CharAppendList *)malloc(sizeof(CharAppendList));
    if (!list) {
        printf("CharAppendList Allocation Error!\n");
        exit(1);
    }
    CharAppendListInit(list);
    return list;
}
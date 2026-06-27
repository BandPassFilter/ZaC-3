#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int __compare_string(char *string_a, char *string_b) {
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

int __check_string_in_strings(int strings_arr_length, char **strings, char* string) {
    // checks if string is in string array (strings)
    for (int i = 0; i < strings_arr_length; i++) {
        if (__compare_string(strings[i], string)) {
            return i;
        }
    }
    return -1;
}

typedef struct pointer_chain {
    int pointer_type;
    int end;
    struct pointer_chain *next;
} pointer_chain;


typedef struct DictionaryPointer {
    // just create a pseudo-dictionary with string lookups instead of ASCII hashmap calculations
    int size;
    int number_of_keys;
    int array_size;
    pointer_chain **key_values;
    char **key_strings;
    int *chain_sizes;

    void (*build)(struct DictionaryPointer*);
    void (*set)(struct DictionaryPointer*, pointer_chain*, char*);
    void (*append)(struct DictionaryPointer*, int, char*);
    struct pointer_chain* (*get)(struct DictionaryPointer*, char*);
    int (*getSize)(struct DictionaryPointer*, char*);
} DictionaryPointer;


pointer_chain* _DictionaryPointer_get(DictionaryPointer *self, char *key_string) {
    int index = __check_string_in_strings(self->number_of_keys, self->key_strings, key_string);
    if (index == -1) {
        printf("Key \"%s\" string not in dictionary!\n", key_string);
        exit(1);
    }
    return self->key_values[index];
}


void _DictionaryPointer_setSize(DictionaryPointer *self, int size, char *key_string) {
    int index = __check_string_in_strings(self->number_of_keys, self->key_strings, key_string);
    if (index == -1) {
        printf("Key \"%s\" string not in dictionary!\n", key_string);
        exit(1);
    }
    self->chain_sizes[index] = size;
}

int _DictionaryPointer_getSize(DictionaryPointer *self, char *key_string) {
    int index = __check_string_in_strings(self->number_of_keys, self->key_strings, key_string);
    if (index == -1) {
        printf("Key \"%s\" string not in dictionary!\n", key_string);
        exit(1);
    }
    return self->chain_sizes[index];
}


void _DictionaryPointer_build(DictionaryPointer *self) {
    #define DICTIONARY_SIZE 10
    pointer_chain **new_key_values_array = (pointer_chain **)malloc(DICTIONARY_SIZE * sizeof(pointer_chain*));
    char **new_key_strings_array = (char **)malloc(DICTIONARY_SIZE * sizeof(char*));
    int *chain_sizes = (int *) malloc(DICTIONARY_SIZE * sizeof(int));
    if (!new_key_values_array || !new_key_strings_array || !chain_sizes) {
        printf("DictionaryPointer Allocation Error!\n");
        exit(1);
    }
    for (int i = 0; i < DICTIONARY_SIZE; i++) {
        chain_sizes[i] = 0; // initialise chain_sizes to zero
    }
    self->key_values = new_key_values_array;
    self->key_strings = new_key_strings_array;
    self->number_of_keys = 0;
}

void _DictionaryPointer_append(DictionaryPointer *self, int key_value, char *key_string) {
    int key_string_size = strlen(key_string);
    //printf("Key: %d\n", key_value);
    //printf("String: %s\n", key_string);

    if (!__check_string_in_strings(self->number_of_keys, self->key_strings, key_string) != -1) {
        printf("New pointer chain created\n");
        char *heap_string = (char*)malloc(key_string_size * sizeof(char));
        if (!heap_string) {
            printf("String Allocation Error!\n");
            exit(1);
        }
        heap_string = strcpy(heap_string, key_string); // make the input string a permanant string in the heap
        self->key_values[self->number_of_keys]->pointer_type = key_value;
        self->key_strings[self->number_of_keys] = heap_string;
        self->size += key_string_size;
        self->number_of_keys++;
        self->key_values[self->number_of_keys]->end = 1; // set end to true
        _DictionaryPointer_setSize(self, 0, key_string);
    }
    
    // check if array needs reallcation
    if (self->size + key_string_size > self->array_size) {
        pointer_chain **new_key_values_array = (pointer_chain **)realloc(self->key_values, self->array_size * 2 * sizeof(pointer_chain*));
        char **new_key_strings_array = (char **)realloc(self->key_strings, self->array_size * 2 * sizeof(char*));
        int *new_chain_sizes = (int *) realloc(self->chain_sizes, self->array_size * 2 * sizeof(int));
        for (int i = self->array_size; i < self->array_size * 2; i++) {
            new_chain_sizes[i] = 0; // initialise new chain_sizes to zero
        }
        if (!new_key_values_array || !new_key_strings_array || !new_chain_sizes) {
            printf("DictionaryPointer Reallocation Error!\n");
            printf("%d\n", new_key_values_array);
            printf("%d\n", new_key_strings_array);
            exit(1);
        }
        self->key_values = new_key_values_array;
        self->key_strings = new_key_strings_array;
        self->chain_sizes = new_chain_sizes;
    }

    if (_DictionaryPointer_getSize(self, key_string) == 0) {
        // now append the key and string to the append list
        char *heap_string = (char*)malloc(key_string_size * sizeof(char));
        if (!heap_string) {
            printf("String Allocation Error!\n");
            exit(1);
        }
        heap_string = strcpy(heap_string, key_string); // make the input string a permanant string in the heap
        self->key_values[self->number_of_keys]->pointer_type = key_value;
        self->key_strings[self->number_of_keys] = heap_string;
        self->size += key_string_size;
        self->number_of_keys++;
        self->key_values[self->number_of_keys]->end = 1; // set end to true
        _DictionaryPointer_setSize(self, 1, key_string);
    } else {
        // now append the key and string to the append list
        char *heap_string = (char*)malloc(key_string_size * sizeof(char));
        if (!heap_string) {
            printf("String Allocation Error!\n");
            exit(1);
        }
        heap_string = strcpy(heap_string, key_string); // make the input string a permanant string in the heap
        pointer_chain *key_pointer_chain = _DictionaryPointer_get(self, key_string);
        while (key_pointer_chain->end == 0) {
            key_pointer_chain = key_pointer_chain->next; // walk the linked list until the leaf (end == 1)
        }
        key_pointer_chain->end = 0;
        key_pointer_chain->next->pointer_type = key_value;
        key_pointer_chain->next->end = 1;
    }
}

void _DictionaryPointer_set(DictionaryPointer *self, pointer_chain *key_value, char *key_string) {
    int key_string_size = strlen(key_string);
    //printf("Key: %d\n", key_value);
    //printf("String: %s\n", key_string);

    if (__check_string_in_strings(self->number_of_keys, self->key_strings, key_string) != -1) {
        printf("Key string already in dictionary!\n");
        exit(1);
    }
    
    // check if array needs reallcation
    if (self->size + key_string_size > self->array_size) {
        pointer_chain **new_key_values_array = (pointer_chain **)realloc(self->key_values, self->array_size * 2 * sizeof(pointer_chain*));
        char **new_key_strings_array = (char **)realloc(self->key_strings, self->array_size * 2 * sizeof(char*));
        if (!new_key_values_array || !new_key_strings_array) {
            printf("DictionaryPointer Reallocation Error!\n");
            printf("%d\n", new_key_values_array);
            printf("%d\n", new_key_strings_array);
            exit(1);
        }
        self->key_values = new_key_values_array;
        self->key_strings = new_key_strings_array;
    }

    // now append the key and string to the append list
    char *heap_string = (char*)malloc(key_string_size * sizeof(char));
    if (!heap_string) {
        printf("String Allocation Error!\n");
        exit(1);
    }
    heap_string = strcpy(heap_string, key_string); // make the input string a permanant string in the heap
    self->key_values[self->number_of_keys] = key_value;
    self->key_strings[self->number_of_keys] = heap_string;
    self->size += key_string_size;
    self->number_of_keys++;
}




void DictionaryPointerInit(DictionaryPointer *self) {
    self->size = 0;
    self->array_size = DICTIONARY_SIZE;

    self->build = &_DictionaryPointer_build;
    self->set = &_DictionaryPointer_set;
    self->get = &_DictionaryPointer_get;
    self->append = &_DictionaryPointer_append;
    self->getSize = &_DictionaryPointer_getSize;
    self->build(self);
}
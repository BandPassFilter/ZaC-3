#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
int _compare_string(char *string_a, char *string_b) {
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


int _check_string_in_strings(int strings_arr_length, char **strings, char* string) {
    // checks if string is in string array (strings)
    for (int i = 0; i < strings_arr_length; i++) {
        if (_compare_string(strings[i], string)) {
            return i;
        }
    }
    return -1;
}
*/

typedef struct DictionaryPointer {
    // just create a pseudo-dictionary with string lookups instead of ASCII hashmap calculations
    int size;
    int number_of_keys;
    int array_size;
    void **key_values;
    char **key_strings;

    void (*build)(struct DictionaryPointer*);
    void (*set)(struct DictionaryPointer*, void*, char*);
    void *(*get)(struct DictionaryPointer*, char*);
    int (*in)(struct DictionaryPointer*, char*);
} DictionaryPointer;

void _DictionaryPointer_build(DictionaryPointer *self) {
    #define DICTIONARY_SIZE 10
    void **new_key_values_array = (void *)malloc(DICTIONARY_SIZE * sizeof(void*));
    char **new_key_strings_array = (char **)malloc(DICTIONARY_SIZE * sizeof(char*));
    if (!new_key_values_array || !new_key_strings_array) {
        printf("DictionaryPointer Allocation Error!\n");
        exit(1);
    }
    self->key_values = new_key_values_array;
    self->key_strings = new_key_strings_array;
    self->number_of_keys = 0;
}

void _DictionaryPointer_set(DictionaryPointer *self, void *key_value, char *key_string) {
    int key_string_size = strlen(key_string);
    //printf("Key: %d\n", key_value);
    //printf("String: %s\n", key_string);
    //printf("DictionaryPointer: %p\n", self);

    if (_check_string_in_strings(self->number_of_keys, self->key_strings, key_string) != -1) {
        printf("Key string already in dictionary!\n");
        exit(1);
    }
    
    // check if array needs reallcation
    if (self->number_of_keys > (self->array_size) / 2) {
        void **new_key_values_array = (void **)realloc(self->key_values, self->array_size * 2 * sizeof(void*));
        char **new_key_strings_array = (char **)realloc(self->key_strings, self->array_size * 2 * sizeof(char*));
        if (!new_key_values_array || !new_key_strings_array) {
            printf("DictionaryPointer Reallocation Error!\n");
            printf("%d\n", new_key_values_array);
            printf("%d\n", new_key_strings_array);
            printf("DictionaryPointer size: %d\n", self->number_of_keys);
            printf("%d\n", key_value);
            printf("%s\n", key_string);
            exit(1);
        }
        self->key_values = new_key_values_array;
        self->key_strings = new_key_strings_array;
        self->array_size = self->array_size * 2;
    }

    // now append the key and string to the append list
    char *heap_string = (char*)malloc((key_string_size+1) * sizeof(char));
    if (!heap_string) {
        printf("String Allocation Error!\n");
        printf("String size: %d", key_string_size);
        exit(1);
    }
    heap_string = strcpy(heap_string, key_string); // make the input string a permanant string in the heap
    self->key_values[self->number_of_keys] = key_value;
    self->key_strings[self->number_of_keys] = heap_string;
    self->size += key_string_size;
    self->number_of_keys++;
}

void *_DictionaryPointer_get(DictionaryPointer *self, char *key_string) {
    int index = _check_string_in_strings(self->number_of_keys, self->key_strings, key_string);
    if (index == -1) {
        printf("Key \"%s\" string not in dictionary!\n", key_string);
        printf("DictionaryPointer: %p\n", self);
        exit(1);
    }
    return self->key_values[index];
}

int _DictionaryPointer_in(DictionaryPointer *self, char *key_string) {
    int index = _check_string_in_strings(self->number_of_keys, self->key_strings, key_string);
    if (index == -1) {
        return -1;
    }
    return index;
}

void DictionaryPointerInit(DictionaryPointer *self) {
    self->size = 0;
    self->array_size = DICTIONARY_SIZE;

    self->build = &_DictionaryPointer_build;
    self->set = &_DictionaryPointer_set;
    self->get = &_DictionaryPointer_get;
    self->in = &_DictionaryPointer_in;
    self->build(self);
}
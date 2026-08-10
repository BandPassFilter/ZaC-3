#include <stdio.h>
#include <stdlib.h>

typedef struct NewString {
    char *string;
    int string_size;

    void (*build)(struct NewString*);
    void (*writeSring)(struct NewString*, char *string);
    char *(*getString)(struct NewString*);
    int (*getLength)(struct NewString*);
} NewString;

void _NewString_build(NewString *self) {
    
}

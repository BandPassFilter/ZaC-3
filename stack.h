typedef struct charStack {
    int size;
    int internal_size;
    char stack_arr[20];
    char *current_pos;
    char (*getValue)(struct charStack*);
    void (*increment)(struct charStack*);
    void (*decrement)(struct charStack*);
    void (*setValue)(struct charStack*, char);
    void (*push)(struct charStack*, char);
    char (*pop)(struct charStack*);
} charStack;

char _char_stack_get_value(charStack *my_stack) {
    return *(my_stack->current_pos);
}

void _char_stack_increment(charStack *my_stack) {
    my_stack->current_pos++;
}

void _char_stack_decrement(charStack *my_stack) {
    my_stack->current_pos--;
}

void _char_stack_set_value(charStack *my_stack, char value) {
    *(my_stack->current_pos) = value;
}

void _stack_push(charStack *my_stack, char value) {
    if (my_stack->size >= my_stack->internal_size) {
        printf("Stack out of bounds!\n");
        exit(1);
    }
    my_stack->size++;
    _char_stack_set_value(my_stack, value);
    //_char_stack_increment(my_stack);
    my_stack->current_pos++;
}

char _stack_pop(charStack *my_stack) {
    //_char_stack_decrement(my_stack);
    my_stack->current_pos--;
    return _char_stack_get_value(my_stack);
}

void stackInit(charStack *my_stack) {
    for (int i = 0; i < 20; i++) {
        *((my_stack->stack_arr)+i) = (char)0x00;
    }
    my_stack->internal_size = 20;

    my_stack->getValue = &_char_stack_get_value;
    my_stack->increment = &_char_stack_increment;
    my_stack->decrement = &_char_stack_decrement;
    my_stack->setValue = &_char_stack_set_value;
    my_stack->push = &_stack_push;
    my_stack->pop = &_stack_pop;
}
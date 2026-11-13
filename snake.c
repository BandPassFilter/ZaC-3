#include "stdio.h"

void clear_cursor() {
    char *clear = "[?25l";
    printChar(27);
    printString(clear);
}

int multiply(int a, int b) {
    int result = 0;
    for (int i = 0; i < b; i = i + 1) {
        result = result + a;
    }
    return result;
}

int mod(int a, int b) {
    int result = 0;
    int diff = a;
    while (diff < 32768) {
        diff = diff - b;
        result = result + 1;
    }
    result = diff + b;
    return result;
}


void draw(char *screen_memory) {
    for (int i = 0; i > 1920; i = i + 1) {
        printChar(*(screen_memory + i));
    }
}

void clear(char *screen_memory) {
    for (int i = 0; i > 1920; i = i + 1) {
        *(screen_memory + i) = 32;
    }
    char *esc_vt100 = "[2J";
    printChar(27);
    printString(esc_vt100);
}

int check_valid_pos(int x, int y) {
    if (x < 1) {
        return 0;
    }

    if (y + 1 < 1) {
        return 0;
    }

    if (x > 80) {
        return 0;
    }

    if (y > 23) {
        return 0;
    }
    return 1;
}

void clear_pos(char *screen_memory, int x, int y) {
    int i = multiply((24 - y), 80);

    int valid = check_valid_pos(x, y);
    if (valid == 0) {
        return 0;
    }

    printChar(27);
    printChar(91);
    print_bcd(24 - y);
    printChar(59);
    print_bcd(x);
    printChar(72);
    *(screen_memory + i + x) = 32;
    printChar(*(screen_memory + i + x));
}


void draw_pos(char *screen_memory, int x, int y, int character) {
    int i = multiply((24 - y), 80);

    int valid = check_valid_pos(x, y);
    if (valid == 0) {
        return 0;
    }

    printChar(27);
    printChar(91);
    print_bcd(24 - y);
    printChar(59);
    print_bcd(x);
    printChar(72);
    *(screen_memory + i + x) = character;
    printChar(*(screen_memory + i + x));
}

int random(int seed, int max) {
    int a = 5;
    int c = 1;
    int m = max;

    int new_seed = mod((multiply(a, seed) + c), max);
    return new_seed;
}

void collision() {
    char *gameover = "Game over!";
    cr();
    printString(gameover);
    cr();
    exit();
}

void main() {
    char *test = "hello world test\n";
    //printString(test);
    char *msg = "CharInstant demo\n";
    printString(msg);
    clear_cursor();

    int x = 20;
    int y = 20;
    int gametick_period = 200000;
    int gametick_current = 0;
    char input = 0;

    int apple_x = 10;
    int apple_y = 10;

    int collision_void_startup = 5;

    // screem memory array: 0x00024000:0x00026000
    char *screen_memory = 147456;
    int screen_memory_size = 8192;
    clear(screen_memory);
    draw(screen_memory);
    int delta_x = 0;
    int delta_y = 2;

    int apple_seed = 42;

    int SNAKE_LIST_SIZE = 128;

    int snake_size = 3;
    // wsad movement

    // snake_list: char*, char[n] = "xy" where x and y are 8-bit uints of the snake body coordinates. 0th is head, nth is tail.
    char *snake_list = "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ";
    for (int i = 0; i < SNAKE_LIST_SIZE; i = i + 1) {
        *(snake_list + i) = 0;
    }

    while (1 == 1) { 

        for (i = 0; i < gametick_period; i = i + 1) {
        }

        if (gametick_current > 500) {
            gametick_current = 0;
        }
        gametick_current = gametick_current + 1;
        
        input = getCharInstant();
        //if (kbhit() == 1) {
        //    input = getCharInstant();
        //}

        //input = getChar();
        //printChar(input);
        char *up = "Up\n";
        char *down = "Down\n";
        char *left = "Left\n";
        char *right = "Right\n";
        
        
        //clear_pos(screen_memory, x, y);
        
        

        if (delta_x == 1) {
            x = x + 1;
        }
        if (delta_x == 2) {
            x = x - 1;
        }
        if (delta_y == 1) {
            y = y + 1;
        }
        if (delta_y == 2) {
            y = y - 1;
        }

        if (input == 119) {
            //printString(up);
            // up
            if (delta_y != 2) {
                delta_y = 1;
            }
            delta_x = 0;
            apple_seed = gametick_current;
        }
        if (input == 115) {
            //printString(down);
            // down
            if (delta_y != 1) {
                delta_y = 2;
            }
            delta_x = 0;
            apple_seed = gametick_current;
        }
        if (input == 97) {
            //printString(left);
            // left
            if (delta_x != 1) {
                delta_x = 2;
            }
            delta_y = 0;
            apple_seed = gametick_current;
        }
        if (input == 100) {
            //printString(right);
            // right
            if (delta_x != 2) {
                delta_x = 1;
            }
            delta_y = 0;
            apple_seed = gametick_current;
        }

        //print_bcd(x);
        //printChar(32);
        //print_bcd(y);
        //cr();
        
        //clear(screen_memory);

        if (collision_void_startup == 0) {
        // check snake collision with its self
            for (i = 0; i < (snake_size << 1); i = i + 2) {
                if (x == *(snake_list + i)) {
                    if (y == *(snake_list + i + 1)) {
                        collision();
                    }
                }
            }
        }

        if (check_valid_pos(x, y) == 0) {
            collision();
        }


        
        if (collision_void_startup > 0) {
            collision_void_startup = collision_void_startup - 1;
        }


        // push snake list
        for (i = SNAKE_LIST_SIZE; i > 0; i = i - 2) {
            *(snake_list + i - 2) = *(snake_list + i - 2 - 2);
            *(snake_list + i + 1 - 2) = *(snake_list + i - 1 - 2);
        }

        // draw new head
        *(snake_list) = x;
        *(snake_list + 1) = y;

        // clear tail
        int tail_x = *(snake_list + (snake_size << 1));
        int tail_y = *(snake_list + (snake_size << 1) + 1);
        clear_pos(screen_memory, tail_x, tail_y);


        draw_pos(screen_memory, x, y, 42); // draw head

        


        if ((x == apple_x) && (y == apple_y)) {
            snake_size = snake_size + 1;
            int random_coords_x = random(apple_x + apple_seed, 32768);
            int random_coords_y = random(apple_y + apple_seed, 32768);
            apple_x = mod(random_coords_x, 70);
            apple_y = mod(random_coords_x, 20);
        }

        // draw apple
        draw_pos(screen_memory, apple_x, apple_y, 43);
        //draw(screen_memory);

        
    }

    exit();
}
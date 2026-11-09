#include "stdio.h"

void main() {
    char *test = "hello world test\n";
    //printString(test);
    char *msg = "CharInstant demo\n";
    printString(msg);

    int x = 0;
    int y = 0;
    int gametick_period = 100000;
    char input = 0;


    // wsad movement

    while (1 == 1) { 
        for (int i = 0; i < gametick_period; i = i + 1) {
        }

        if (kbhit() == 1) {
            input = getCharInstant();
        }
        //printChar(input);
        char *up = "Up\n";
        char *down = "Down\n";
        char *left = "Left\n";
        char *right = "Right\n";

        if (input == 119) {
            //printString(up);
            // up
            y = y + 1;
        }
        if (input == 115) {
            //printString(down);
            // down
            y = y - 1;
        }
        if (input == 97) {
            //printString(left);
            // left
            x = x - 1;
        }
        if (input == 100) {
            //printString(right);
            // right
            x = x + 1;
        }

        print_bcd(x);
        printChar(32);
        print_bcd(y);
        cr();



    }

    exit();
}
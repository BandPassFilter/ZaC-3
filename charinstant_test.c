#include "stdio.h"

void main() {
    char *test = "hello world test\n";
    //printString(test);
    char *msg = "CharInstant demo\n";
    printString(msg);
    int time = 0;
    int seconds = 0;
    int minutes = 0;
    int hours = 0;
    int dummy = 0;
    cr();

    while (1 == 1) { 
        print_bcd(hours);
        printChar(32);
        print_bcd(minutes);
        printChar(32);
        print_bcd(seconds);
        cr();
        if (seconds < 60) {
            seconds = seconds + 1;
        }
        if (seconds == 60) {
            seconds = 0;
            minutes = minutes + 1;
        }
        if (minutes == 60) {
            minutes = 0;
            hours = hours + 1;
        }
        if (hours == 24) {
            hours = 0;
        }
        time = time + 1;
        for (int i = 0; i < 4650; i = i + 1) {
            dummy = 0;
            char input = getCharInstant();
            printChar(input);
        }
    }

    exit();
}
int a;
int b;
int *c;
a = 30-5;
b = 59;
a = a+b;

if (a == b) {
    b = b + a;
}

while (a == b) {
    a = a + 1;
    if (a + 2 == b - 1) {
        a = a + 1;
        *(a+5) = a;
    }
}


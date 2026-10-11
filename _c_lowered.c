int func(int func_a , int func_b   ) {
int func_c ;
func_c = 1;
return func_a ;

}

void main() {
char *main_debug ;
main_debug = 9000000;
*main_debug = 0;

int main_a ;
main_a = 1 + 2 + 3;
int main_b ;
main_b = 5;
int main_c ;
main_c = 0;
main_a = 3 + 4 - main_b ;

if (main_a == 1) {
	main_a = 3;

}

main_c = 0;
int var_0 = main_a  + 123;
int var_1 = main_b;

main_c = func(var_0, var_1);
;

int var_3 = 523 + main_b ;
int var_4 = main_a;

func(var_3, var_4);

main_a = 0;
int var_6 = main_c;
int var_7 = main_b  + main_a ;

main_a = func(var_6, var_7);
;

while (main_a == 0) {
	main_a = 1;

}

for (main_a = 0;main_a < 5; main_a = main_a  + 1) {
	main_a = 1;

}

}


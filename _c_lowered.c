int func() {
int func_b;
func_b = 1;
return func_b ;

}

void main() {
int main_a;
main_a = 1 + 2 + 3;
int main_b;
main_b = 5;
main_a = 3 + 4 - main_b ;

if (main_a == 1) {
	main_a = 3;

}

func(main_a );

}


main: main.o assignment1.o
	gcc -o main main.o assignment1.o -lm

main.o: main.c
	gcc -ggdb -O2 -std=c11 -Wall -Werror -pedantic -fsanitize=address -fsanitize=leak -fsanitize=undefined -fno-sanitize-recover -c main.c -o main.o

assignment1.o: assignment1.c
	gcc -ggdb -O2 -std=c11 -Wall -Werror -pedantic -fsanitize=address -fsanitize=leak -fsanitize=undefined -fno-sanitize-recover -c assignment1.c -o assignment1.o
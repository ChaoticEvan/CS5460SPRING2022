SRCS = main.c assignment1.c
TARG = assignment1
LIBS = -lm

# This translates SRCS from .c to .o files
OBJS = $(SRCS:.c=.o)

all: $(TARG)

$(TARG): $(OBJS)
	gcc -ggdb -O2 -std=c11 -g -Wall -Werror -pedantic -fsanitize=address -fsanitize=leak -fsanitize=undefined -fno-sanitize-recover -o $(TARG) $(OBJS) $(LIBS)

assignment1.o:
	gcc -ggdb -O2 -std=c11 -g -Wall -Werror -pedantic -fsanitize=address -fsanitize=leak -fsanitize=undefined -fno-sanitize-recover -c assignment1.c -o assignment1.o

main.o:
	gcc -ggdb -O2 -std=c11 -g -Wall -Werror -pedantic -fsanitize=address -fsanitize=leak -fsanitize=undefined -fno-sanitize-recover -c main.c -o main.o

clean:
	rm -f $(OBJS) $(TARG)
SRCS = main.c assignment1.c
TARG = assignment1
CC = gcc
OPTS = -ggdb -O2 -std=c11 -Wall -Werror -pedantic -fsanitize=address -fsanitize=leak -fsanitize=undefined -fno-sanitize-recover
LIBS = -lm

# This translates SRCS from .c to .o files
OBJS = $(SRCS:.c=.o)

all: $(TARG)

$(TARG): $(OBJS)
	$(CC) -o $(TARG) $(OBJS) $(LIBS)

%.o: %.c
	$(CC) $(OPTS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARG)
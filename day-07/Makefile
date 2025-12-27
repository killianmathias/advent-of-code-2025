CC      = gcc
CFLAGS  = -std=c99 -Wall -Wextra

part1: part1.c
	$(CC) $(CFLAGS) -o part1 part1.c

part2: part2.c
	$(CC) $(CFLAGS) -o part2 part2.c

run1: part1
	./part1

run2: part2
	./part2

clean:
	rm -f part1 part2

.PHONY: part1 part2 run1 run2 clean
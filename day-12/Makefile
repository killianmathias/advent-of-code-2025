CXX = g++
CXXFLAGS = -std=c++20 -O2 -Wall -Wextra

.PHONY: all part1 part2 run1 run2 clean

all: part1 part2

part1: part1.cc
	$(CXX) $(CXXFLAGS) part1.cc -o part1

part2: part2.cc
	$(CXX) $(CXXFLAGS) part2.cc -o part2

run1: part1
	./part1

run2: part2
	./part2

clean:
	rm -f part1 part2
CC=mpicc
# CFLAGS=-Wall -O3 -march=native -g -fopenmp
CFLAGS=-Wall -O1 -g -fopenmp
LDFLAGS=$(CFLAGS)

OBJ=$(patsubst %.c,%.o,$(wildcard *.c))

all: main
main: $(OBJ)

clean:
	rm -f $(OBJ) main vgcore.*

test: main
	mpirun -np 2 ./main input/small.mnt

debug: main
	mpirun -np 2 -xterm gdb ./main input/small.mnt

gdb: main
	gdb main
# si un .h ou le makefile change tout recompiler :
$(OBJ): $(wildcard *.h) Makefile

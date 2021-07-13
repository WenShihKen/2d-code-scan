CC = g++
CFLAGS = -O3
SQLITE = -l sqlite3
LIBS = $(SQLITE)
OBJ = main.o sql.o

all: main.out

main.out: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)
%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS) $(LIBS)

.PHONT: clean

clean:
	rm -f *.o *.out *.txt
run:
	./main.out

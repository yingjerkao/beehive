CC=gcc

%.o: %.c
	$(CC) -c $< -fopenmp

thread.e: thread.o
	$(CC) -o $@  -fopenmp $<
clean:
	rm *.o *.e

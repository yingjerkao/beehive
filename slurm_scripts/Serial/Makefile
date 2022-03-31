CC=gcc

%.o: %.c
	$(CC) -c $< 

single.e: single.o
	$(CC) -o $@ $<

clean:
	rm *.o *.e

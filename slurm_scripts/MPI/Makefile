MPICC=mpicc

%.o: %.c
	$(MPICC) -c $< 

mpi_test.e: mpi_test.o
	$(MPICC) -o $@   $<
clean:
	rm *.o *.e

#include <stdio.h>
#include "mpi.h"

int main (int argc, char *argv[])
{
  int id, np;
  char name[MPI_MAX_PROCESSOR_NAME];
  int namelen;
  int i;

  MPI_Init (&argc, &argv);

  MPI_Comm_size (MPI_COMM_WORLD, &np);
  MPI_Comm_rank (MPI_COMM_WORLD, &id);
  MPI_Get_processor_name (name, &namelen);

  printf ("This is Process %2d out of %2d running on host %s\n", id, np, name);

  MPI_Finalize ();

  return (0);
}


// programme principal
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <omp.h>
#include <time.h>
#include "type.h"
#include "io.h"
#include "darboux.h"

#define HYPERTHREADING 0

int main(int argc, char **argv)
{
  MPI_Init(&argc, &argv);

  // Initialisation de la communication
  int rank, size;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  //Données de test
  double time_ref, time_ker, speedup, efficiency;


  mnt *m, *d;
  m = malloc(sizeof(mnt));

  if(argc < 2)
  {
    fprintf(stderr, "Usage: %s <input filename> [<output filename>]\n", argv[0]);
    exit(1);
  }

  // READ INPUT
  m = mnt_read(argv[1]);

  // COMPUTE
  time_ref = omp_get_wtime();
  d = darboux_ref(m);
  time_ref = omp_get_wtime() - time_ref;
  double total_time_ref = 0.;
  MPI_Reduce(&time_ref, &total_time_ref, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
  
  
  time_ker = omp_get_wtime();
  d = darboux(m);  
  time_ker = omp_get_wtime() - time_ker;
  double total_time_ker = 0.;
  MPI_Reduce(&time_ker, &total_time_ker, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
  
  // WRITE OUTPUT
  if(rank==0){
    FILE *out;
    if(argc == 3)
      out = fopen(argv[2], "w");
    else
      out = stdout;
    mnt_write(d, out);
    if(argc == 3)
      fclose(out);
    else
      mnt_write_lakes(m, d, stdout);

    // free
        free(m->terrain);
        free(m);
        free(d->terrain);
        free(d);

  }
  MPI_Barrier(MPI_COMM_WORLD);

  if(rank==0){
    printf("Reference time - : %3.5lf s\n", total_time_ref);
    printf("Parallelized time: %3.5lf s\n", total_time_ker);
    speedup = total_time_ref / total_time_ker;
    efficiency = speedup / (omp_get_num_procs() / (1 + HYPERTHREADING));
    printf("Speedup -------- : %3.5lf\n", speedup);
    printf("Efficiency------ : %3.5lf\n", efficiency);
  }
  
  MPI_Finalize();
  
  return 0; 
}

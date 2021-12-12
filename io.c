// fonctions d'entrée/sortie

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#include "check.h"
#include "type.h"
#include "io.h"

mnt *mnt_read(char *fname)
{
  int rank, size;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  mnt *m;
  FILE *f;
  CHECK((m = malloc(sizeof(*m))) != NULL);
  CHECK((f = fopen(fname, "r")) != NULL);
  if(rank==0){
    CHECK(fscanf(f, "%d", &m->ncols) == 1);
    CHECK(fscanf(f, "%d", &m->nrows) == 1);
    CHECK(fscanf(f, "%f", &m->xllcorner) == 1);
    CHECK(fscanf(f, "%f", &m->yllcorner) == 1);
    CHECK(fscanf(f, "%f", &m->cellsize) == 1);
    CHECK(fscanf(f, "%f", &m->no_data) == 1);
  }

  MPI_Bcast(&m->ncols,1,MPI_INT,0,MPI_COMM_WORLD);
  MPI_Bcast(&m->nrows,1,MPI_INT,0,MPI_COMM_WORLD);

  CHECK((m->terrain = calloc(1, m->ncols * m->nrows * sizeof(float))) != NULL);

  //DEBUG
  if(rank==0){
    for(int i = 0 ; i < m->ncols * m->nrows ; i++)
    {
      CHECK(fscanf(f, "%f", &m->terrain[i]) == 1);
    }
  }
  MPI_Bcast(&m->no_data, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);

  int disps[size];
  disps[0] = 0;
  for(size_t i = 1; i<size; i++)
    disps[i] = disps[i-1] + m->ncols;
  
  int counts[size];
  for(size_t i = 0; i<size-1; i++)
    counts[i] = m->ncols*(m->nrows / size);
  counts[size-1] = m->ncols*(m->nrows / size) + m->nrows%size;
  
  MPI_Scatterv(m->terrain, counts, disps, MPI_FLOAT, m->terrain, m->ncols*m->nrows/size, MPI_FLOAT, 0, MPI_COMM_WORLD);
  
  CHECK(fclose(f) == 0);

  return(m);
}

void mnt_write(mnt *m, FILE *f)
{
  CHECK(f != NULL);

  fprintf(f, "%d\n", m->ncols);
  fprintf(f, "%d\n", m->nrows);
  fprintf(f, "%.2f\n", m->xllcorner);
  fprintf(f, "%.2f\n", m->yllcorner);
  fprintf(f, "%.2f\n", m->cellsize);
  fprintf(f, "%.2f\n", m->no_data);

  for(int i = 0 ; i < m->nrows ; i++)
  {
    for(int j = 0 ; j < m->ncols ; j++)
    {
      fprintf(f, "%.2f ", TERRAIN(m,i,j));
    }
    fprintf(f, "\n");
  }
}

void mnt_write_lakes(mnt *m, mnt *d, FILE *f)
{
  CHECK(f != NULL);

  for(int i = 0 ; i < m->nrows ; i++)
  {
    for(int j = 0 ; j < m->ncols ; j++)
    {
      const float dif = TERRAIN(d,i,j)-TERRAIN(m,i,j);
      fprintf(f, "%c", (dif>1.)?'#':(dif>0.)?'+':'.' );
    }
    fprintf(f, "\n");
  }
}

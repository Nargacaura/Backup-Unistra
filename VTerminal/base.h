#ifndef BASE_H
#define BASE_H

#include <vector>
#include <algorithm>
#include <assert.h>
#include <cstdlib>
#include <iostream>
#include <string>
#include <stdio.h>

#define BOMB 0
#define DEFUSING 1
#define SECURE 2
#define SHERLOCK_HOLMES 0
#define JAMES_MORIARTY 1

/**
  Ce fichier est là pour qu'on y mette les constantes ou variables jugées Globales
  ou d'autres choses ...
*/

#define NAMESIZE 50                                 // taille du pseudo de joueur
#define NBCARD 5                                    // Nombre de carte par joueur
typedef int WIRE;
typedef int TEAM;

unsigned int getAleatInt(int min, int max);
#endif 

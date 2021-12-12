#include "base.h" 

unsigned int getAleatInt(int min, int max){
     return unsigned((rand() % (max - min + 1)) + min);
}

// 1. ¿Qué problema tiene este programa?
// 2. ¿Por qué ocurre a nivel de memoria (stack)?
// 3. Corrige el código usando memoria dinámica.

// #include <stdio.h>
// int *crear() {
//   int x = 10;
//   return &x;
// }
//
// int main() {
//   int *p = crear();
//   printf("%d\n", *p);
//   return 0;
// }

// 1.- El problema es que la función intenta devolver
// la dirección de memoria de una variable local (x).
// En C, las variables locales se almacenan en el Stack
// y su tiempo de vida termina en cuanto la función
// llega a su fin.

// 2.- Lo que sucede es que el stack llama a crear()
// crea un espacio y cuando llama a &x termina todo
// y todo lo que se estaba haciendo adentro se borra.

#include <stdio.h>
#include <stdlib.h>

int *crear() {
  int *p = malloc(sizeof(int));
  if (p != NULL) {
    *p = 10;
  }
  return p;
}

int main() {
  int *p = crear();
  if (p != NULL) {
    printf("%d", *p);
    free(p);
  }
  return 0;
}

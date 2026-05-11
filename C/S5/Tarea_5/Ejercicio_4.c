#include <stdio.h>
#include <stdlib.h>

int *demostracion_memoria(int tamano) {
  int arreglo_stack[5] = {1, 2, 3, 4, 5};

  int *arreglo_dinamico = (int *)malloc(tamano * sizeof(int));

  if (arreglo_dinamico == NULL)
    return NULL;

  for (int i = 0; i < tamano; i++) {
    arreglo_dinamico[i] = i + 2;
  }

  printf("--- Dentro de la funcion ---\n");
  printf("Arreglo Stack: ");
  for (int j = 0; j < tamano; j++) {
    printf(" %d", arreglo_stack[j]);
  }
  printf("\nArreglo Dinamico: ");
  for (int j = 0; j < tamano; j++) {
    printf(" %d", arreglo_dinamico[j]);
  }
  return arreglo_dinamico;
}

int main() {
  int n = 5;
  int *p = demostracion_memoria(n);

  if (p != NULL) {
    printf("\n\nValor en el Heap: %d\n", p[0]);

    free(p);
    printf("Memoria liberada correctamente.\n");
  }

  return 0;
}

// Ocurre un comportamiento indefinido donde puede
// pasar 3 cosas devuelva valores basuras, se cuelgue
// el programa o sea exitoso lo cual puede ser error
// que suceden aveces ahora porque ocurre eso es al principio
// se guarda la memoria pero al llegar al return se elimina
// ya que se guardo como local por asi decirlo

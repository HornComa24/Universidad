#include <stdio.h>
#include <stdlib.h>

int main() {
  int n, i;
  int *vector;

  // Establece el tamaño del vector
  printf("Introduce el número de elementos para el vector: ");
  scanf("%d", &n);

  // Asignación de memoria dinámica
  vector = (int *)malloc(n * sizeof(int));

  // Validar si la asignación fue exitosa
  if (vector == NULL) {
    printf("Error: No se pudo asignar memoria.\n");
    return 1;
  }

  // Leer los valores del vector
  printf("\nIntroduce %d números enteros\n", n);
  for (i = 0; i < n; i++) {
    printf("Elemento [%d]: ", i);
    scanf("%d", &vector[i]);
  }

  // Imprimir los valores
  printf("\nLos valores en el vector son: ");
  for (i = 0; i < n; i++) {
    printf("%d ", vector[i]);
  }

  // Liberar memoria
  free(vector);
   
  return 0;
}

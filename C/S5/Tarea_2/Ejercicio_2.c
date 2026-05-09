#include <stdio.h>
#include <stdlib.h>

int main() {
  int n, i, suma = 0; // Inicializado en 0 para evitar errores
  int *vector;

  printf("Introduce el número de elementos para el vector: ");
  scanf("%d", &n);

  vector = (int *)malloc(n * sizeof(int));

  if (vector == NULL) {
    printf("Error: No se pudo asignar memoria.\n");
    return 1;
  }

  printf("\nIntroduce %d números enteros\n", n);
  for (i = 0; i < n; i++) {
    printf("Elemento [%d]; ", i);
    scanf("%d", &vector[i]);
  }
   
  // Suma de los elementos 
  for (i = 0; i < n; i++) {
    suma = suma + vector[i];
  }
   
  printf("\nElemento sumados dan: %d ", suma);

  printf("\nLos valores en el vector son: ");
  for (i = 0; i < n; i++) {
    printf("%d ", vector[i]);
  }

  free(vector);
   
  return 0;
}

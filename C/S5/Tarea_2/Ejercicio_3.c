#include <stdio.h>
#include <stdlib.h>

int main() {
  int n, i;
  int *vector, *vector1;

  printf("Introduce el número de elementos para el vector: ");
  scanf("%d", &n);

  // Asignación de memoria para ambos vectores
  vector = (int *)malloc(n * sizeof(int));
  vector1 = (int *)malloc(n * sizeof(int));

  if (vector == NULL || vector1 == NULL) {
    printf("Error: No se pudo asignar memoria.\n");
    return 1;
  }

  printf("\nIntroduce %d números enteros\n", n);
  for (i = 0; i < n; i++) { 
    printf("Elemento [%d]; ", i);
    scanf("%d", &vector[i]);
  }

  // Proceso de copia
  for (i = 0; i < n; i++) {
    vector1[i] = vector[i]; 
  }
   
  printf("\nLos valores en el vector original son: ");
  for (i = 0; i < n; i++) {
    printf("%d ", vector[i]);
  }

  printf("\nLos valores en el vector copiado son: ");
  for (i = 0; i < n; i++) {
    printf("%d ", vector1[i]);
  }

  // Liberar ambos espacios de memoria
  free(vector);
  free(vector1);

  return 0;
}

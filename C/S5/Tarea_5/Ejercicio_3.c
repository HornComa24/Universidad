#include <stdio.h>

int main() {
  int a[5] = {5, 4, 2, 6, 1};
  int n = 5;

  printf("Recorrido con indices:\n");
  for (int i = 0; i < n; i++) {
    printf("a[%d] = %d\n", i, a[i]);
  }

  printf("\nRecorrido con punteros (p + i):\n");
  int *p = a;
  for (int i = 0; i < n; i++) {
    printf("*(p + %d) = %d\n", i, *(p + i));
  }

  int suma = 0;
  int *ptr = a;
  for (int i = 0; i < n; i++) {
    suma += *(ptr + i);
  }
  printf("\nLa suma de los elementos es: %d\n", suma);

  return 0;
}

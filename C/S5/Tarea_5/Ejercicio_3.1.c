#include <stdio.h>

float calcular_promedio(int *ptr, int tamano) {
  int suma = 0;

  for (int i = 0; i < tamano; i++) {
    suma += *(ptr + i);
  }
  return (float)suma / tamano;
}

int main() {
  int valores[] = {5, 4, 2, 6, 1};
  int n = 5;

  float promedio = calcular_promedio(valores, n);

  printf("El promedio del arreglo es: %.2f\n", promedio);

  return 0;
}

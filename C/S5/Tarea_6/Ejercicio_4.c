
// void contar(int *arr, int n, int *pares, int *impares);

// La función debe:
// • Recorrer el arreglo
// • Contar cuántos números son pares e impares
// • Guardar los resultados en pares e impares

// Restricción:
// No puedes retornar valores directamente (solo usar punteros).

#include <stdio.h>

void contar(int *arr, int n, int *pares, int *impares) {
  *pares = 0;
  *impares = 0;

  for (int i = 0; i < n; i++) {
    if (arr[i] % 2 == 0) {
      (*pares)++; // Accedemos al valor y le sumamos 1
    } else {
      (*impares)++; // Accedemos al valor y le sumamos 1
    }
  }
}

int main() {
  int datos[] = {10, 15, 20, 25, 30};
  int p, im;

  // Pasamos el arreglo, su tamaño y las DIRECCIONES de p e im
  contar(datos, 5, &p, &im);

  printf("Pares: %d\n", p);    // Imprimirá 3
  printf("Impares: %d\n", im); // Imprimirá 2
  return 0;
}

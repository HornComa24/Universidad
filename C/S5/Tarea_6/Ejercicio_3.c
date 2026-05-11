
// int suma_subarreglo(int *inicio, int *fin);
//  Donde:
//   inicio apunta al primer elemento del subarreglo.
//   fin apunta al elemento después del último (como en C estándar).
//   La función debe calcular la suma.
//   Ejemplo de uso:
//  int a[] = {1,2,3,4,5};
//  suma_subarreglo(&a[1], &a[4]); // suma 2+3+4

#include <stdio.h>
int suma_subarreglo(int *inicio, int *fin) {
  int suma = 0;

  while (inicio < fin) {
    suma += *inicio; // Sumamos el contenido de la dirección actual
    inicio++;        // Movemos el puntero a la siguiente "casa" (dirección)
  }
  return suma;
}

int main() {
  int a[] = {1, 2, 3, 4, 5};
  printf("La suma del subarreglos desde %d a %d es = %d", a[1], a[4],
         suma_subarreglo(&a[1], &a[4]));
}

// 2.- el inicio guarda la dirección del primer número que quieres sumar
// osea 2 como a[1] es < a[4] entonces lo guarda en suma entonces suma = 2
// y despues de inicia le suma 1 entonces este te queda como a[2] = 3 y vuelve a
// comprobar siguiendo asi para a ser a[3] = 4 hasta llegar a a[4] = 5 y ahi
// termina devolviendo 2 + 3 + 4 = 9 dando que la suma es = a 9

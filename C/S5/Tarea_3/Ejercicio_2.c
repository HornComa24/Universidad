// Impresión de los Números Naturales en Orden Inverso:
// Escribir una función recursiva que imprima los números naturales desde n hasta 1 en orden inverso.
// Ejemplo de entrada: n=3
// Ejemplo de salida: 3, 2, 1

#include <stdio.h>

int OrdenI(int n) {

  if (n < 1) {
    return 1;
  }
  printf("%d", n);
  OrdenI(n-1);
}

int main() {
  int v = 3;
  printf("El valor inverso de los %d números consecutivos es: ",v);
  OrdenI(v);
}

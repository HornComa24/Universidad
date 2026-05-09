// Cálculo de la Potencia de un Número:
// Escribir una función recursiva que calcule la potencia de un número entero 
// x elevado a la potencia entera no negativa b.
// Ejemplo de entrada: a=2, b=3
// Ejemplo de salida: 2^3 = 8

#include <stdio.h>

int potencia(int a, int b) {
  if (b == 0) {
    return 1;
  } else {
    return a * potencia(a , b-1);
  }
}

int main() {
  int x = 2, y = 3;
  printf("El valor de la potencia %d^%d es: %d\n", x, y, potencia(x,y));
}

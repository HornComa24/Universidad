
// Cálculo de la Suma de los Números Naturales:
// Escribir una función recursiva que calcule la suma de los primeros n números naturales.
// Ejemplo de entrada: n=5
// Ejemplo de salida: 1+2+3+4+5=15

#include <stdio.h>

int suma(int n) {
  if (n == 1){
    return 1;
  } else {
    return n + suma(n-1);
  }
}

int main() {
  int j,v = 5;
  for (j=1; j<=v; j++){
    printf("%d",j);
    if (j < v) {
      printf(" + ");
    } else {
      printf(" = %d", suma(v));
    }
  }
}

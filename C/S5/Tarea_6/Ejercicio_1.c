
// 1. Indica qué se imprime en pantalla.
// 2. Dibuja el estado del stack en cada llamada.
// 3. Explica cuándo se crean y destruyen las variables.

#include <stdio.h>

void f(int a) {
  int b = a + 1;
  printf("f: a=%d, b=%d\n", a, b);
}

void g(int x) {
  int y = x * 2;
  f(y);
  printf("g: x=%d, y=%d\n", x, y);
}

int main() {
  int n = 3;
  g(n);
  return 0;
}

// 1.- Lo que se imprime en la consola es esto
//     f: a=6, b=7
//     g: x=3, y=6

// 2.- a = 6, b = 7   -- Ultimo que entra
//
//     x = 3, y = 6
//
//     n = 3          -- Primero que entra

// 3.- La primera variable creada es n = 3
// llamando la funcion g(n) se crea la variable
// x = 3 despues se crea la variable y usando
// x * 2 y para finalizar en la funcion f(y)
// se crea la variable a = 6 se usa la variable
// a + 1 creando asi la variable b para despues
// destruir la variable a y b siguiendole las
// variable y e x y finalizando con la variable n

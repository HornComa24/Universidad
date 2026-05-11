#include <stdio.h>

int x = 5;
int *p = &x;

int main() {
  printf("El valor de x es: %d", x);
  printf("\nLa direccion de x es: %p", (void *)&x);
  printf("\nEl valor de x es: %d", *p);
  printf("\nLa direccion de x es: %p", (void *)p);

  *p = 20;
  printf("\n\nModificaciones mediante puntero");
  printf("\nEl valor de x es: %d", x);

  return 0;
}

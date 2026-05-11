#include <stdio.h>

void swap_valor(int a, int b) {
  int temp = a;
  a = b;
  b = temp;
}

void swap_referencia(int *a, int *b) {
  int temp = *a;
  *a = *b;
  *b = temp;
}

int main() {
  int x = 10, y = 50;

  printf("Valores originales: x = %d, y = %d\n", x, y);

  swap_valor(x, y);
  printf("Despues de swap_valor: x = %d, y = %d (No cambia)\n", x, y);

  swap_referencia(&x, &y);
  printf("Despues de swap_referencia: x = %d, y = %d (Si cambia)\n", x, y);

  return 0;
}

// El porque la funcion swap_valor no cambia el valor y la de swap_referencia si
// lo cambia es por la memoria como tu sabes si tu dices que a = b significa que
// el valor de a tomara el de b pero como no sabe donde esta ubicado este no
// cambia por lo que ahi es donde entra punteros donde tu dices tu valor de b
// que esta ubicado en tal parte cambiara el valor de b que esta ubicado en tal
// parte por lo que lo que hacen los punteros es dirigirte a donde se encuentra
// la variable en la memoria para que pueda ser cambiado

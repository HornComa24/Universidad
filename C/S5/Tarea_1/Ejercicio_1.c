#include <stdio.h>

// Definición de variables globales
int i, vm;
int numeros[5] = {2, 3, 1, 6, 5};

// Función para buscar el mínimo
int minimo() {
    // El valor mínimo inicial es el primer dato del arreglo
    vm = numeros[0];

    // Busca en el arreglo de valores de 0 hasta 4
    for (i = 0; i < 5; i++) {
        // Si encuentra un valor menor al actual, lo reemplaza
        if (numeros[i] < vm) {
            vm = numeros[i];
        }
    }
    // Retorna el valor mínimo encontrado
    return vm;
}

int main() {
    // Imprime el valor mínimo en la consola
    printf("El valor es: %d\n", minimo());
    return 0;
}

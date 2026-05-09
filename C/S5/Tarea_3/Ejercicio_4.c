// Ordenamiento de un Arreglo usando Recursión:
// Escribir una función recursiva que ordene un arreglo de enteros en orden ascendente utilizando el algoritmo de
// ordenamiento de selección o cualquier otro algoritmo de ordenamiento basado en comparación.
// Ejemplo de entrada: arreglo={5,2,8,1,4}
// Ejemplo de salida: arreglo={1,2,4,5,8}

#include <stdio.h>

void intercambiar(int *a, int *b) {
    int temporal = *a;
    *a = *b;
    *b = temporal;
}

void ordenamiento(int arr[], int n, int i) {

    if (i >= n - 1) {
        return;
    }

    int m = i;
    for (int j = i + 1; j < n; j++) {
        if (arr[j] < arr[m]) {
            m = j;
        }
    }

    if (m != i) {
        intercambiar(&arr[m], &arr[i]);
    }

    ordenamiento(arr, n, i + 1);
}

int main() {
    int datos[] = {5, 2, 8, 1, 4};
    int n = sizeof(datos) / sizeof(datos[0]);

    ordenamiento(datos, n, 0);

    printf("Arreglo ordenado recursivamente: ");
    for (int k = 0; k < n; k++) {
        printf("%d ", datos[k]);
    }
}

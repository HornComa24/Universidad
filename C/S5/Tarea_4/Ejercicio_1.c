
// Ejercicio 1: Montos de compras
// Contexto
// Un sistema registra los montos de compras de clientes en un día.
// Enunciado
// • Solicite al usuario ingresar N montos de compras (máximo 20)
// • Guarde los valores en un arreglo
// • Ordene los montos usando QuickSort
// • Muestre:
// Lista original
// Lista ordenada (de menor a mayor)

#include <stdio.h>

// Función para intercambiar dos elementos
void intercambiar(float *a, float *b) {
    float temporal = *a;
    *a = *b;
    *b = temporal;
}

// Función de partición
int particion(float arreglo[], int bajo, int alto) {
    float pivote = arreglo[alto]; // Elegimos el último elemento como pivote
    int i = (bajo - 1); 

    for (int j = bajo; j <= alto - 1; j++) {
        if (arreglo[j] < pivote) {
            i++;
            intercambiar(&arreglo[i], &arreglo[j]);
        }
    }
    intercambiar(&arreglo[i + 1], &arreglo[alto]);
    return (i + 1);
}

// Función principal de QuickSort
void quickSort(float arreglo[], int bajo, int alto) {
    if (bajo < alto) {
        int pi = particion(arreglo, bajo, alto);

        // Ordenar elementos antes y después de la partición
        quickSort(arreglo, bajo, pi - 1);
        quickSort(arreglo, pi + 1, alto);
    }
}

int main() {
    int n;
    float montos[20];

    // 1. Solicitar N montos
    printf("¿Cuántos montos desea ingresar? (Máximo 20): ");
    scanf("%d", &n);

    if (n > 20 || n <= 0) {
        printf("Cantidad no válida.\n");
        return 1;
    }

    for (int i = 0; i < n; i++) {
        printf("Ingrese el monto %d: ", i + 1);
        scanf("%f", &montos[i]);
    }

    // 2. Mostrar lista original
    printf("\nLista original:\n");
    for (int i = 0; i < n; i++) {
        printf("%.f ", montos[i]);
    }

    // 3. Ordenar usando QuickSort
    quickSort(montos, 0, n - 1);

    // 4. Mostrar lista ordenada
    printf("\n\nLista ordenada (menor a mayor):\n");
    for (int i = 0; i < n; i++) {
        printf("%.f ", montos[i]);
    }
    printf("\n");

    return 0;
}

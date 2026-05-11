
// Ejercicio 2: Medio — Facturas y ranking
// Contexto
// Una empresa quiere ordenar las facturas del día según su monto.
// Enunciado
// • Ingrese:
// • Cantidad de facturas (máx 30)
// • Montos de cada factura
// • Ordene los datos con QuickSort
// • Muestre:
// • Facturas ordenadas
// • Las 3 facturas más altas

#include <stdio.h>

// Función para intercambiar valores
void intercambiar(float *a, float *b) {
    float temp = *a;
    *a = *b;
    *b = temp;
}

// Función de partición para QuickSort
int particion(float facturas[], int bajo, int alto) {
    float pivote = facturas[alto];
    int i = (bajo - 1);

    for (int j = bajo; j <= alto - 1; j++) {
        if (facturas[j] < pivote) {
            i++;
            intercambiar(&facturas[i], &facturas[j]);
        }
    }
    intercambiar(&facturas[i + 1], &facturas[alto]);
    return (i + 1);
}

void quickSort(float facturas[], int bajo, int alto) {
    if (bajo < alto) {
        int pi = particion(facturas, bajo, alto);
        quickSort(facturas, bajo, pi - 1);
        quickSort(facturas, pi + 1, alto);
    }
}

int main() {
    int n;
    float facturas[30];

    printf("Ingrese la cantidad de facturas (máximo 30): ");
    scanf("%d", &n);

    if (n > 30 || n <= 0) {
        printf("Cantidad no válida.\n");
        return 1;
    }

    for (int i = 0; i < n; i++) {
        printf("Monto factura %d: ", i + 1);
        scanf("%f", &facturas[i]);
    }

    // Ordenar de menor a mayor
    quickSort(facturas, 0, n - 1);

    // Mostrar facturas ordenadas
    printf("\n--- Facturas Ordenadas (Menor a Mayor) ---\n");
    for (int i = 0; i < n; i++) {
        printf("$%.f ", facturas[i]);
    }

    // Mostrar las 3 facturas más altas
    printf("\n\n--- Top 3 Facturas Más Altas ---\n");
    int count = 0;
    // Empezamos desde la última posición del arreglo
    for (int i = n - 1; i >= 0 && count < 3; i--) {
        printf("%d. $%.f\n", count + 1, facturas[i]);
        count++;
    }

    return 0;
}

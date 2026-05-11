// Ejercicio 4: Medio — Ventas semanales
// Contexto
// Un negocio registra las ventas de cada día de la semana.
// Enunciado
// • Ingrese las ventas de 7 días en un arreglo:
// int ventas[7];
// • Ordene las ventas usando Bubble Sort
// • Muestre:
// • Ventas ordenadas
// • El día con menor venta
// • El día con mayor venta
// • Mostrar las ventas en orden descendente

#include <stdio.h>

// Función de ordenamiento Burbuja (Bubble Sort)
void bubbleSort(int arreglo[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            // Comparación de elementos adyacentes
            if (arreglo[j] > arreglo[j + 1]) {
                int temporal = arreglo[j];
                arreglo[j] = arreglo[j + 1];
                arreglo[j + 1] = temporal;
            }
        }
    }
}

int main() {
    int ventas[7];
    char *dias[] = {"Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"};

    // 1. Ingreso de ventas
    printf("Registro de ventas semanales\n");
    printf("----------------------------\n");
    for (int i = 0; i < 7; i++) {
        printf("Ventas del %s: ", dias[i]);
        scanf("%d", &ventas[i]);
    }

    // 2. Ordenar usando Bubble Sort (Ascendente)
    bubbleSort(ventas, 7);

    // 3. Mostrar ventas ordenadas de menor a mayor
    printf("\n--- Ventas ordenadas (Ascendente) ---\n");
    for (int i = 0; i < 7; i++) {
        printf("%d ", ventas[i]);
    }

    // 4. Mostrar día con menor y mayor venta
    // Al estar ordenado, el menor es el primero y el mayor el último
    printf("\n\nVenta más baja: %d", ventas[0]);
    printf("\nVenta más alta: %d", ventas[6]);

    // 5. Mostrar ventas en orden descendente
    printf("\n\n--- Ventas en orden descendente ---\n");
    for (int i = 6; i >= 0; i--) {
        printf("%d ", ventas[i]);
    }
    printf("\n");

    return 0;
}

#include <stdio.h>

// Definición de variables y matriz
int i, j, min;
int matriz[3][4] = { {10, 20, 30, 40}, {50, 60, 70, 80}, {90, 100, 110, 120} };

// Creación de función de mínimo
int minimo() {
    // El valor inicial es el primer elemento de la matriz (0,0)
    min = matriz[0][0];

    // Itera por las 3 filas
    for (i = 0; i < 3; i++) {
        // Itera por las 4 columnas
        for (j = 0; j < 4; j++) {
            // Si el valor actual es menor al mínimo guardado, se actualiza
            if (matriz[i][j] < min) {
                min = matriz[i][j];
            }
        }
    }
    return min;
}

int main() {
    // Muestra el valor mínimo de la matriz
    printf("El valor es: %d\n", minimo());
    return 0;
}

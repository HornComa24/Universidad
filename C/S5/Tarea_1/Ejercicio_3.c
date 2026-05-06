#include <stdio.h>

// Matriz original y matriz de destino
int matriz[3][4] = { {10, 20, 30, 40}, {50, 60, 70, 80}, {90, 100, 110, 120} };
int matriznew[3][4]; 

int f = 0; // Índice para la fila de la matriz nueva
int c = 0; // Índice para la columna de la matriz nueva

void nmatriz() {
    // Iteración inversa: empezamos desde la última posición [2][3] hacia [0][0]
    for (int i = 2; i >= 0; --i) { 
        for (int j = 3; j >= 0; --j) { 
            // Se asigna el valor actual a la posición (f, c) de la nueva matriz
            matriznew[f][c] = matriz[i][j];
            
            c++; // Avanzamos de columna en la nueva matriz
            
            // Si llegamos al límite de columnas (4), reiniciamos columna y bajamos de fila
            if (c == 4) { 
                c = 0; 
                f++;
            }
        }
    }
}

int main() {
    // Ejecutamos la lógica de inversión
    nmatriz(); 
   
    printf("Matriz Invertida:\n");
    // Ciclo para imprimir la nueva matriz resultante
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%d\t", matriznew[i][j]);
        }
        printf("\n"); // Salto de línea al terminar cada fila
    }

    return 0;
}

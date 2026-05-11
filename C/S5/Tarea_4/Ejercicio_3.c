// Ejercicio 3: Difícil — Notas de estudiantes (matriz)
// Contexto
// Un profesor tiene las notas de estudiantes en distintas evaluaciones.
// Enunciado
// • Ingrese:
// • Número de estudiantes (máx 20)
// • Número de evaluaciones (máx 5)
// • Use una matriz:
// int notas[20][5];
// • Calcule el promedio de cada estudiante
// • Guarde los promedios en un arreglo separado
// • Ordene los promedios usando QuickSort
// • Muestre:
// • Promedios originales
// • Promedios ordenados

#include <stdio.h>

// Función para intercambiar promedios (QuickSort)
void intercambiar(float *a, float *b) {
    float temp = *a;
    *a = *b;
    *b = temp;
}

// Función de partición para QuickSort
int particion(float promedios[], int bajo, int alto) {
    float pivote = promedios[alto];
    int i = (bajo - 1);

    for (int j = bajo; j <= alto - 1; j++) {
        if (promedios[j] < pivote) {
            i++;
            intercambiar(&promedios[i], &promedios[j]);
        }
    }
    intercambiar(&promedios[i + 1], &promedios[alto]);
    return (i + 1);
}

void quickSort(float promedios[], int bajo, int alto) {
    if (bajo < alto) {
        int pi = particion(promedios, bajo, alto);
        quickSort(promedios, bajo, pi - 1);
        quickSort(promedios, pi + 1, alto);
    }
}

int main() {
    int numEstudiantes, numEval;
    int notas[20][5];
    float promediosOriginales[20];
    float promediosOrdenados[20];

    // 1. Entrada de dimensiones
    printf("Ingrese número de estudiantes (máx 20): ");
    scanf("%d", &numEstudiantes);
    printf("Ingrese número de evaluaciones (máx 5): ");
    scanf("%d", &numEval);

    if (numEstudiantes > 20 || numEval > 5) {
        printf("Dimensiones fuera de rango.\n");
        return 1;
    }

    // 2. Carga de matriz y cálculo de promedios
    for (int i = 0; i < numEstudiantes; i++) {
        int sumaEstudiante = 0;
        printf("\nNotas del estudiante %d:\n", i + 1);
        for (int j = 0; j < numEval; j++) {
            printf("  Evaluación %d: ", j + 1);
            scanf("%d", &notas[i][j]);
            sumaEstudiante += notas[i][j];
        }
        // Calculamos el promedio y lo guardamos en ambos arreglos
        float promedio = (float)sumaEstudiante / numEval;
        promediosOriginales[i] = promedio;
        promediosOrdenados[i] = promedio; 
    }

    // 3. Mostrar promedios originales
    printf("\nPromedios Originales\n");
    for (int i = 0; i < numEstudiantes; i++) {
        printf("Estudiante %d: %.2f\n", i + 1, promediosOriginales[i]);
    }

    // 4. Ordenar la copia de promedios
    quickSort(promediosOrdenados, 0, numEstudiantes - 1);

    // 5. Mostrar promedios ordenados
    printf("\n--- Promedios Ordenados (Menor a Mayor) ---\n");
    for (int i = 0; i < numEstudiantes; i++) {
        printf("%.2f  ", promediosOrdenados[i]);
    }
    printf("\n");

    return 0;
}

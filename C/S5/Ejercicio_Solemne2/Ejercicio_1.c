// Una universidad desea implementar un sistema para gestionar una fila de
// estudiantes esperando atención académica.

// Cada estudiante debe almacenarse en una lista enlazada simple con la
// siguiente

// Información:
//    • número de matrícula (int)
//    • nombre del estudiante (char[])
//    • puntero al siguiente nodo

// Parte A — Estructura y creación de nodos (10 puntos)
//    1. Defina la estructura Nodo.
//    2. Implemente una función que cree dinámicamente un nuevo nodo estudiante.

// Parte B — Inserción especial (20 puntos)
// Implemente una función que inserte estudiantes manteniendo la lista ORDENADA
// de menor a mayor según la matrícula.

// Restricciones:
//    • NO se permiten matrículas repetidas.
//    • NO puede usar arreglos auxiliares.
//    • La lista debe recorrerse solo una vez por inserción.
//    • Debe indicar por pantalla si la matrícula ya existe.

// Parte C — Eliminación condicional (20 puntos)
// Implemente una función que elimine todos los estudiantes cuya matrícula sea
// un número PAR.

// Restricciones:
//    • Debe liberar correctamente la memoria.
//    • La función debe funcionar correctamente si:
//        • la lista está vacía
//        • el primer nodo debe eliminarse
//        • todos los nodos son eliminados

// Parte D — Análisis y comprensión (25 puntos)

// Considere la siguiente lista:

// 10 -> 15 -> 20 -> 25 -> NULL

// Después de ejecutar la función de la Parte C:
//    1. Dibuje cómo queda la lista final.
//    2. Indique qué nodos fueron liberados.
//    3. Explique paso a paso qué ocurre cuando se elimina el primer nodo.
//    4. Explique por qué podría producirse una fuga de memoria si free() no se
//    usa correctamente.

#include <stdbool.h> // Para usar la logica booleana
#include <stdio.h>   // Para entrada y salida basica
#include <stdlib.h> // Para operaciones generales como convertir datos, gestionar memoria dinamica y generar numeros aleatorios
#include <string.h> // Para manipular texto

// Estructura base para gestionar una lista de estudiantes
typedef struct Nodo {
  int matricula;
  char nombre[50];
  struct Nodo *siguiente;
} Nodo;

// fabrica un nuevo Nodo para guardar los datos de un estudiante.
Nodo *crearEstudiante(int matrícula, const char *nombre) {
  // Reservamos memoria para el nuevo nodo
  Nodo *nuevoEstudiante = (Nodo *)malloc(sizeof(Nodo));
  if (nuevoEstudiante == NULL) {
    printf("Error: No se pudo asignar memoria.\n");
    return NULL;
  }
  nuevoEstudiante->matricula = matrícula;
  strncpy(nuevoEstudiante->nombre, nombre, 50);
  nuevoEstudiante->siguiente = NULL;
  return nuevoEstudiante;
}

// esto ordena de manera ascendente, validando duplicados e inerta o al medio o
// al final
void masamenos(Nodo **cabeza, Nodo *nuevo) {

  // La lista esta vacia o el nuevo nodo va antes del primero
  if (*cabeza == NULL || nuevo->matricula < (*cabeza)->matricula) {
    nuevo->siguiente = *cabeza;
    *cabeza = nuevo;
    return;
  }

  // Recorrer para buscar la posicion correcta
  Nodo *actual = *cabeza;
  while (actual->siguiente != NULL &&
         actual->siguiente->matricula < nuevo->matricula) {
    actual = actual->siguiente;
  }

  // Verifica si la matricula ya existe
  if (actual->matricula == nuevo->matricula) {
    printf("Error: La matrícula %d ya existe en la lista.\n", nuevo->matricula);
    free(nuevo); // Liberar nodo si no se inserta
    return;
  }

  if (actual->siguiente != NULL &&
      actual->siguiente->matricula == nuevo->matricula) {
    printf("Error: La matrícula %d ya existe en la lista.\n", nuevo->matricula);
    free(nuevo);
    return;
  }

  // Inserta en medio o al final
  nuevo->siguiente = actual->siguiente;
  actual->siguiente = nuevo;
}

// limpiar la lista eliminando a todos los estudiantes cuya matrícula sea un
// número par.
void eliminarPares(Nodo **cabeza) {
  Nodo *actual = *cabeza;
  Nodo *anterior = NULL;

  while (actual != NULL) {

    // Verificar si la matrícula es par
    if (actual->matricula % 2 == 0) {

      // eliminar el primer nodo (la cabeza)
      if (anterior == NULL) {
        *cabeza = actual->siguiente;
        free(actual);
        actual = *cabeza; // Reiniciamos desde la nueva cabeza
      }

      // eliminar un nodo en medio o al final
      else {
        anterior->siguiente = actual->siguiente;
        free(actual);
        actual = anterior->siguiente; // Saltamos al siguiente nodo
      }
    }

    // la matrícula es impar, avanzamos normalmente
    else {
      anterior = actual;
      actual = actual->siguiente;
    }
  }
}

// limpia consola
void limpiarPantalla() {
#ifdef _WIN32
  system("cls"); // Para Windows
#else
  system("clear"); // Para Linux o macOS
#endif
}

// corrobora si lo escrito sea solo letras
bool esSoloLetras(char *str) {
  for (int i = 0; str[i] != '\0'; i++) {
    // Verificamos si NO está en el rango de minúsculas Y NO está en el rango de
    // mayúsculas
    if (!((str[i] >= 'a' && str[i] <= 'z') ||
          (str[i] >= 'A' && str[i] <= 'Z'))) {
      return false; // Encontró algo que no es letra
    }
  }
  return true;
}

// Muestra todos los Nodos (estudiantes)
void mostrarLista(Nodo *cabeza) {
  if (cabeza == NULL) {
    printf("La lista está vacía.\n");
    return;
  }
  Nodo *temp = cabeza;
  printf("\n--- Fila de Estudiantes ---\n");
  while (temp != NULL) {
    printf("Matrícula: %d | Nombre: %s\n", temp->matricula, temp->nombre);
    temp = temp->siguiente;
  }
  printf("---------------------------\n");
}

int main() {
  Nodo *lista = NULL;
  int opcion, mat;
  char nom[50];

  do {
    printf("\n1. Agregar estudiante\n");
    printf("2. Eliminar estudiantes con matrícula par\n");
    printf("3. Ver fila de espera\n");
    printf("4. Salir\n");
    printf("\nSeleccione una opción: ");
    if (scanf("%d", &opcion) != 1) {
      while (getchar() != '\n')
        ;
      opcion = 0;
    }
    limpiarPantalla();

    switch (opcion) {
    case 1:
      printf("\nIngrese matrícula: ");

      if (scanf("%d", &mat) != 1) {
        limpiarPantalla();
        printf("Error: La matrícula debe ser un número entero.\n");
        while (getchar() != '\n')
          ;
        break;
      }

      printf("Ingrese nombre: ");
      scanf("%s", nom);

      if (!esSoloLetras(nom)) {
        limpiarPantalla();
        printf("Error: El nombre debe contener solo letras (sin números ni "
               "decimales).\n");
        break;
      }

      Nodo *nuevo = crearEstudiante(mat, nom);

      if (nuevo != NULL) {
        masamenos(&lista, nuevo);
      }

      limpiarPantalla();
      printf(
          "Estudiante ingresado correctamente\n Nombre: %s\n Matricula: %d\n",
          nom, mat);
      break;
    case 2:
      eliminarPares(&lista);
      printf("Se han eliminado los estudiantes con matrícula PAR.\n");
      break;
    case 3:
      mostrarLista(lista);
      break;
    case 4:
      printf("Saliendo del sistema...\n\n");
      break;
    default:
      printf("Opción no válida.\n");
    }
  } while (opcion != 4);

  return 0;
}

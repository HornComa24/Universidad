
// Parte E — Modificación inesperada (25 puntos)

// Modifique su solución anterior para que:
//    • la lista se mantenga ordenada DESCENDENTEMENTE
//    • pero los números PARES deben almacenarse SIEMPRE al inicio de la lista,
//    sin importar el orden

// Ejemplo válido:

// 8 -> 6 -> 30 -> 25 -> 20 -> 15

// Explique:
//    1. Qué cambios realizó en la lógica de inserción.
//    2. Qué casos especiales tuvo que considerar.
//    3. Por qué una inserción simple al inicio no resuelve completamente el
//    problema.

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

// inserta estudiantes manteniendo un orden descendente según su matrícula
// verificando que no hayan duplicados verifica si es par e impar
void masamenos(Nodo **cabeza, Nodo *nuevo) {

  // Verificación de duplicados en toda la lista
  Nodo *temp = *cabeza;
  while (temp != NULL) {
    if (temp->matricula == nuevo->matricula) {
      printf("Error: La matrícula %d ya existe.\n", nuevo->matricula);
      free(nuevo);
      return;
    }
    temp = temp->siguiente;
  }

  // Si es PAR insertar al inicio de la lista
  if (nuevo->matricula % 2 == 0) {
    nuevo->siguiente = *cabeza;
    *cabeza = nuevo;
    return;
  }

  // Si es IMPAR insertar en orden descendente (después de los pares)
  Nodo *actual = *cabeza;
  Nodo *anterior = NULL;

  // Avanzamos mientras sean pares o impares mayores al nuevo
  while (actual != NULL &&
         (actual->matricula % 2 == 0 || actual->matricula > nuevo->matricula)) {
    anterior = actual;
    actual = actual->siguiente;
  }

  // Insercion en la posición encontrada
  if (anterior == NULL) {
    nuevo->siguiente = *cabeza;
    *cabeza = nuevo;
  } else {
    nuevo->siguiente = actual;
    anterior->siguiente = nuevo;
  }
}

// limpiar la lista eliminando a todos los estudiantes cuya matrícula sea un
// número par.
void eliminarPares(Nodo **cabeza) {
  Nodo *actual = *cabeza;
  Nodo *anterior = NULL;
  while (actual != NULL) {
    if (actual->matricula % 2 == 0) {
      if (anterior == NULL) {
        *cabeza = actual->siguiente;
        free(actual);
        actual = *cabeza;
      } else {
        anterior->siguiente = actual->siguiente;
        free(actual);
        actual = anterior->siguiente;
      }
    } else {
      anterior = actual;
      actual = actual->siguiente;
    }
  }
}

// limpia consola
void limpiarPantalla() {
#ifdef _WIN32
  system("cls");
#else
  system("clear");
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
    scanf("%d", &opcion);
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

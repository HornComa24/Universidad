
// Desarrollar en lenguaje C un programa completo que gestione una pila de
// números enteros utilizando memoria dinámica (punteros y malloc).

// Definición de Estructuras:
//   - Define una estructura llamada Nodo que contenga un campo para el dato
//   (int) y un puntero al siguiente nodo.
//   - Define una estructura llamada Pila que contenga un puntero al tope de la
//   misma.

// Implementación de Funciones:
// Deberás programar las siguientes funciones básicas de gestión:
//   - void initPila(Pila *p): Inicializa la pila dejándola en un estado vacío.
//   - int isEmpty(Pila *p): Retorna verdadero (1) si la pila no tiene
//   elementos, o falso (0) en caso contrario.
//   - void push(Pila *p, int valor): Crea un nuevo nodo, le asigna el valor y
//   lo coloca en el tope de la pila.
//   - int pop(Pila *p): Elimina el nodo que está en el tope, libera su memoria
//   y retorna el valor que contenía. (Debe manejar el error si la pila está
//   vacía).
//   - int top(Pila *p): Retorna el valor del elemento en el tope sin eliminar
//   el nodo.

// Tarea Formativa: Interfaz y Control
// Para que el sistema sea funcional, deberás implementar en el archivo
// principal:
//   - Función main: Donde se declare la pila y se coordine la ejecución.
//   - Menú Interactivo: Crea un menú que se repita constantemente y permita al
//   usuario:
//   - Insertar un elemento (Push).
//   - Extraer un elemento (Pop) y mostrarlo.
//   - Consultar el tope actual (Top).
//   - Saber si la pila está llena o vacía.
//   - Salir del programa.

#include <stdio.h>
#include <stdlib.h>

// Creas un Nodo que contenga un dato entero y que apunte al siguiente nodo
typedef struct Nodo {
  int dato;
  struct Nodo *sig;
} Nodo;

// Creas el tope de la Pila
typedef struct Pila {
  Nodo *tope;
} Pila;

// Inicializas la pila dejandola vacia
void initPila(Pila *p) { p->tope = NULL; }

// Retorna verdadero si la pila no tiene nada sino retorna falso
int isEmpty(Pila *p) { return (p->tope == NULL); }

// Crea un nuevo nodo le asigna un valor y lo mueve al tope de la pila
void push(Pila *p, int valor) {
  Nodo *nuevo = (Nodo *)malloc(sizeof(Nodo));

  // Si el nodo (nuevo) va hacia null no hay memoria suficiente
  if (nuevo == NULL) {
    printf("Error no hay memoria suficiente");
    return;
  }

  // Crea el nuevo nodo dandole el valor
  nuevo->dato = valor;
  // Conecta en nuevo nodo al tope actual
  nuevo->sig = p->tope;
  // Lo mueve al tope de la pila
  p->tope = nuevo;
}

// Elimina el ultimo valor de la pila
int pop(Pila *p) {
  // Si la pila esta vacia se termina aqui
  if (isEmpty(p)) {
    printf("Error: La pila esta vacia");
    return -1;
  }

  // Crea un nodo aux que asigna al tope de la fila
  Nodo *aux = p->tope;
  // Asigna el valor a el nuevo nodo aux
  int valor = aux->dato;
  // Mueve al tope al siguiente elemento
  p->tope = p->tope->sig;

  // Libera el nodo aux
  free(aux);
  // Retorna el valor
  return valor;
}

int top(Pila *p) {
  if (isEmpty(p)) {
    printf("Pila vacia");
    return -1;
  }
  return p->tope->dato;
}

int main() {
  Pila miPila;
  initPila(&miPila); // Inicializamos la pila correctamente

  int opcion = 0;
  int valor;

  do {
    printf("\nMENU PILA DINAMICA");
    printf("\n1. Push (Insertar)");
    printf("\n2. Pop (Extraer)");
    printf("\n3. Top (Consultar tope)");
    printf("\n4. Verificar si esta vacia");
    printf("\n5. Salir");
    printf("\nSeleccione una opcion: ");
    scanf("%d", &opcion);

    switch (opcion) {
    case 1:
      printf("\nIngrese el valor a insertar: ");
      scanf("%d", &valor);
      push(&miPila, valor);
      printf("\nElemento %d insertado correctamente.\n", valor);
      break;

    case 2:
      if (!isEmpty(&miPila)) {
        valor = pop(&miPila);
        printf("\nElemento extraido: %d\n", valor);
      } else {
        printf("\nError: La pila esta vacia, no se puede hacer Pop.\n");
      }
      break;

    case 3:
      if (!isEmpty(&miPila)) {
        printf("\nEl tope actual es: %d\n", top(&miPila));
      } else {
        printf("\nLa pila esta vacia.\n");
      }
      break;

    case 4:
      if (isEmpty(&miPila)) {
        printf("\nLa pila esta actualmente VACIA.\n");
      } else {
        printf("\nLa pila CONTIENE elementos.\n");
      }
      break;

    case 5:
      printf("\nSaliendo del programa...\n");
      break;

    default:
      printf("\nOpcion no valida, intente de nuevo.\n");
    }
  } while (opcion != 5);

  // Opcional: Liberar memoria restante antes de salir
  while (!isEmpty(&miPila)) {
    pop(&miPila);
  }

  return 0;
}

// TDA lineales: listas enlazadas, pilas y colas con punteros.

// ● Lee detenidamente las situaciones problemáticas planteadas y analiza su
// resoluciión.
// ● Selecciona la estructura de datos adecuada para optimizar la
// eficiencia y el rendimiento de la solución.
// ● Implementa el código paso a paso y verifica su funcionamiento con casos de
// prueba simples antes de avanzar a escenarios más complejos.
// ● Documenta adecuadamente la solución con comentarios claros que expliquen la
// lógica utilizada.

// Una aerolínea desea mejorar su sistema de reservas en línea para manejar, de
// manera más eficiente, las solicitudes de boletos en vuelos que a menudo se
// sobre reservan. Se desea implementar una funcionalidad que permita a las y
// los pasajeros ponerse en una lista de espera cuando un vuelo está lleno y ser
// notificados automáticamente cuando se liberan asientos debido a
// cancelaciones. El sistema debe ser capaz de gestionar múltiples listas de
// espera activas para diversos vuelos al mismo tiempo y procesar estas listas
// en un orden justo y eficiente.

// Deberás desarrollar un sistema que pueda manejar de manera eficiente las
// operaciones de agregar pasajeros a la lista de espera y removerlos de esta
// cuando se liberan asientos. Además, el sistema debe mantener el orden de
// llegada de las solicitudes para garantizar que las y los pasajeros sean
// atendidos en el orden correcto, conforme a su momento de inscripción en la
// lista.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Estructura para representar a un pasajero
typedef struct Pasajero {
  char nombre[50];
  struct Pasajero *siguiente;
} Pasajero;

// Estructura para gestionar la lista de espera de un vuelo específico
typedef struct ListaEspera {
  Pasajero *frente; // Salida de la cola
  Pasajero *final;  // Entrada de la cola
} ListaEspera;

// Función para inicializar una lista de espera vacía
void inicializarLista(ListaEspera *q) {
  q->frente = NULL;
  q->final = NULL;
}

// Operación: Agregar pasajero a la lista (Enqueue)
void anotarEnLista(ListaEspera *q, char *nombrePasajero) {
  Pasajero *nuevo = (Pasajero *)malloc(sizeof(Pasajero));
  if (nuevo == NULL) {
    printf("Error: No hay memoria disponible.\n");
    return;
  }
  strcpy(nuevo->nombre, nombrePasajero);
  nuevo->siguiente = NULL;

  if (q->final == NULL) {
    // Si la cola está vacía, el nuevo es tanto el frente como el final
    q->frente = nuevo;
    q->final = nuevo;
  } else {
    // Se agrega al final de la fila
    q->final->siguiente = nuevo;
    q->final = nuevo;
  }
  printf("Pasajero '%s' agregado a la lista de espera.\n", nombrePasajero);
}

// Operación: Asignar asiento al primero de la lista (Dequeue)
void asignarAsiento(ListaEspera *q) {
  if (q->frente == NULL) {
    printf("La lista de espera está vacía. No hay pasajeros pendientes.\n");
    return;
  }

  Pasajero *temporal = q->frente;
  printf("Notificando a: %s. Asiento asignado exitosamente.\n",
         temporal->nombre);

  q->frente = q->frente->siguiente;

  // Si el frente queda NULL, el final también debe serlo
  if (q->frente == NULL) {
    q->final = NULL;
  }

  free(temporal); // Liberar memoria del nodo procesado
}

int main() {
  // Ejemplo: Gestión de lista para el Vuelo AR1234
  ListaEspera vuelo1;
  inicializarLista(&vuelo1);

  printf(" Sistema de Reservas: Vuelo 1 \n");

  // Simulación de llegada de pasajeros
  anotarEnLista(&vuelo1, "Sebastian Flores");
  anotarEnLista(&vuelo1, "Luis Vergara");
  anotarEnLista(&vuelo1, "Vicente Perez");

  printf("\n Se libera un asiento por cancelacion \n");
  asignarAsiento(&vuelo1);

  printf("\n Se libera otro asiento \n");
  asignarAsiento(&vuelo1);

  return 0;
}

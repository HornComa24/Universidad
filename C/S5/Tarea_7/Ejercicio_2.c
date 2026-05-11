
// TDA lineales: listas enlazadas, pilas y colas con punteros.
//
// ● Lee detenidamente las situaciones problemáticas planteadas y analiza su
// resoluciión.
// ● Selecciona la estructura de datos adecuada para optimizar la
// eficiencia y el rendimiento de la solución.
// ● Implementa el código paso a paso y verifica su funcionamiento con casos de
// prueba simples antes de avanzar a escenarios más complejos. ● Documenta
// adecuadamente la solución con comentarios claros que expliquen la lógica
// utilizada.

// Una empresa de software que ofrece soluciones en la nube para empresas
// necesita mejorar su sistema de soporte técnico para manejar de manera
// eficiente una gran cantidad de solicitudes de ayuda de los clientes. Estas
// solicitudes varían desde problemas técnicos menores hasta incidentes críticos
// que requieren atención inmediata. El sistema actual no distingue
// adecuadamente entre diferentes niveles de urgencia ni gestiona de manera
// efectiva el orden de atención, resultando en tiempos de espera prolongados y
// una gestión ineficiente de los recursos técnicos.

// Deberás desarrollar un sistema de gestión de tickets que pueda categorizar y
// atender las solicitudes de soporte según su urgencia y el orden de llegada.
// Además, debe permitir a los técnicos revertir rápidamente cualquier acción o
// revisar los pasos anteriores realizados en la resolución de un ticket cuando
// sea necesario.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Estructura para el Historial (Pila)
typedef struct NodoAccion {
  char descripcion[100];
  struct NodoAccion *siguiente;
} NodoAccion;

// Estructura del Ticket
typedef struct Ticket {
  int id;
  int prioridad;         // 1: Crítico, 2: Medio, 3: Menor
  NodoAccion *historial; // Tope de la pila de acciones
  struct Ticket *siguiente;
} Ticket;

// Estructura de la Cola
typedef struct Cola {
  Ticket *frente;
  Ticket *final;
} Cola;

// Agregar acción al historial (Push)
void agregarAccion(Ticket *t, char *desc) {
  NodoAccion *nueva = (NodoAccion *)malloc(sizeof(NodoAccion));
  strcpy(nueva->descripcion, desc);
  nueva->siguiente = t->historial;
  t->historial = nueva;
  printf("Accion registrada en Ticket %d: %s\n", t->id, desc);
}

// Revertir última acción (Pop)
void deshacerAccion(Ticket *t) {
  if (t->historial == NULL) {
    printf("No hay acciones para revertir en el ticket %d.\n", t->id);
    return;
  }
  NodoAccion *temp = t->historial;
  printf("Revirtiendo: %s\n", temp->descripcion);
  t->historial = temp->siguiente;
  free(temp);
}

void encolarTicket(Cola *q, int id, int p) {
  Ticket *nuevo = (Ticket *)malloc(sizeof(Ticket));
  nuevo->id = id;
  nuevo->prioridad = p;
  nuevo->historial = NULL;
  nuevo->siguiente = NULL;

  if (q->final == NULL) {
    q->frente = q->final = nuevo;
  } else {
    q->final->siguiente = nuevo;
    q->final = nuevo;
  }
}

Ticket *desencolarTicket(Cola *q) {
  if (q->frente == NULL)
    return NULL;
  Ticket *temp = q->frente;
  q->frente = q->frente->siguiente;
  if (q->frente == NULL)
    q->final = NULL;
  return temp;
}

int main() {
  Cola criticos = {NULL, NULL}, normales = {NULL, NULL};

  // Simulación de llegada de tickets
  encolarTicket(&normales, 101, 2); // Ticket medio
  encolarTicket(&criticos, 501, 1); // Ticket crítico

  printf("Iniciando Atencion\n");

  // Lógica de atención por prioridad
  Ticket *actual = desencolarTicket(&criticos);
  if (actual != NULL) {
    printf("Atendiendo Ticket Critico ID: %d\n", actual->id);

    // El técnico realiza acciones
    agregarAccion(actual, "Reinicio de servidor");
    agregarAccion(actual, "Cambio de IP");

    // El técnico decide revertir la última acción
    deshacerAccion(actual);

    free(actual);
  }

  return 0;
}

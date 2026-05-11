def modificar_entero(n):
    n = n + 10
    print(f"  Dentro de la funcion (entero): {n}")


def modificar_lista(L):
    L[0] = "MODIFICADO"
    print(f"  Dentro de la funcion (lista): {L}")


# --- Programa Principal ---
x = 5
mi_lista = [1, 2, 3]

print(f"Antes - Entero: {x}")
modificar_entero(x)
print(f"Despues - Entero: {x} (No cambio)")

print("-" * 30)

print(f"Antes - Lista: {mi_lista}")
modificar_lista(mi_lista)
print(f"Despues - Lista: {mi_lista} (¡Si cambio!)")

# Esto ocurre porque el modificar_entero simplemente esta calculando
# si tu hicieras un return al final el valor cambiaria en cuanto a la
# lista se esta modificando diciendo que el elemento 0 de la lista
# se vuelva "MODIFICADO"

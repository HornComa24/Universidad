# 1. ¿Qué se imprime en cada print?
# 2. Explica el comportamiento usando el modelo de referencias.
# 3. Relaciónalo con lo que ocurriría en C con punteros.


def modificar(lista):
    lista.append(100)


def reasignar(lista):
    lista = [0, 0, 0]


a = [1, 2, 3]

modificar(a)

print(a)

reasignar(a)

print(a)

# 1.- El primer print agrega a la lista a el 100
# el segundo printea la lista a = [1, 2, 3, 100]
# el tercero se supone que reiniciaria la lista
# cosa que no hace porque se esta creando una nueva
# lista llamada en este caso lista y el cuatro print
# muestra la lista a = [1,2,3,100]

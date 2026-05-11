# 4. Listas y listillos

# Haz un programa en Python que pida 10 números al usuario y los almacene en una lista.

# Muestra todos los números por pantalla indicando junto a cada número un mensaje que diga “NEGATIVO” si dicho número es negativo.

# ¿Lo tienes? Modifícalo para que muestre “REPETIDO” al lado de cada número que se encuentre más de una vez en la lista.

lista_numeros = []
lista_contador = []

n = 0

###lista
for i in range(0,10):
    print("")
    numero = int(input("Introduce un numero: "))
    lista_numeros.append(numero)

for h in range(len(lista_numeros)):
    cont = 0
    for j in lista_numeros:
        if lista_numeros[h] == j:
            cont +=1
    lista_contador.append(cont)
###lista
        

for k in range(len(lista_numeros)):
    if lista_numeros[k] >= 0:
        print("")
        x =''
        if lista_contador[k] > 1:
            x='REPETIDO'
        print(lista_numeros[k], lista_numeros[k], x)
    else:
        print("")
        x =''
        if lista_contador[k] > 1:
            x='REPETIDO'
        print(lista_numeros[k], "NEGATIVO", lista_numeros[k], x)
print("")   
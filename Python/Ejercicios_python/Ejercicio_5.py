# 5. Porciones

# Haz un programa en Python que pida números al usuario que se vayan almacenando en una lista. []

# El programa deja de pedir números cuando el usuario introduce un cero. []

# Muestra por pantalla los números en posición par de la lista. []

# Muestra por pantalla los números en orden inverso. []

# Parte la lista en dos mitades. Si el número de elementos es impar, no importa qué mitad tiene un elemento más. []

# Muestra las dos mitades por pantalla. []

# Muestra por pantalla todos los elementos de la primera mitad, exceptuando el primero y el último. []

#Muestra por pantalla el máximo y el mínimo de la segunda mitad. []

lista = []
lista1 = []
lista2 = []

flag = True

print("")
print("Haz un programa en Python que pida números al usuario que se vayan almacenando en una lista. \nPara poder para escriba 0")
while flag == True:
    print("")
    numero = int(input("Introduce un número: "))
    lista.append(numero)
    if numero == 0:
        flag = False

print("")
print("--------------")
print("")
print("Muestra por pantalla los números en posición par de la lista.")

for i in range(0,len(lista),2):
    print("")
    print(lista[i])

print("")    
print("--------------")
print("")
print("Muestra por pantalla los números en orden inverso.")

for a in range(len(lista),0,-1):
    print("")
    print(lista[a-1])

print("")
print("--------------")
print("")
print("Muestra las dos mitades por pantalla.")

mitad = len(lista)//2

for j in range(0,mitad):
    lista1.append(lista[j])
for k in range(mitad,len(lista)): 
    lista2.append(lista[k])

print("")
print(lista)
print(lista1)
print(lista2)
print("")
print("--------------")
print("")
print("Muestra por pantalla todos los elementos de la primera mitad, exceptuando el primero y el último.")

for h in range(1,len(lista1)-1):
    print("")
    print("[",lista1[h], "]")

print("")
print("--------------")
print("")
print("Muestra por pantalla el máximo y el mínimo de la segunda mitad.")

minimo = 0
maximo = 0


for l in range(0,len(lista2)):
    if lista2[l] > maximo:
        maximo = lista2[l]
    if lista2[l] < minimo:
        minimo = lista2[l]

print("")
print("El número minimo de la lista es: ", minimo)
print("El número maximo de la lista es: ", maximo)
print("")
print("--------------")
print("")














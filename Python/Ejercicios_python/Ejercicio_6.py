# 6. Un poco de geometría

# Pide al usuario las coordenadas X e Y de dos puntos en el espacio.

# Muestra por pantalla la distancia en línea recta entre esos dos puntos. (Formula(sqrt((x2-x1)**2+(y2-y1)**2)))

# Muestra por pantalla las coordenadas del punto medio exacto de ambos. (Formula(sqrt((x2-x1)**2+(y2-y1)**2))/2

import math #or import numpy as np

listax = []
listay = []

for i in range(0,2):
    print("")
    x = float(input("Escriba cuanto equivalen las coordenadas de x: "))
    listax.append(x)
    print("")
    y = float(input("Escriba cuanto equivalen las coordenadas de y: "))
    listay.append(y)

distancia = math.sqrt(((listax[1]-listax[0])**2)+(listay[1]-listay[0])**2)

print("")
print("La distancia es: ", distancia)

punto_medio = distancia/2

print("")
print("El punto medio es: ", punto_medio)
print("")





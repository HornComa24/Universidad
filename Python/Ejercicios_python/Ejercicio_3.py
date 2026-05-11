# 3. Máximos y mínimos, pares e impares

# Haz un programa que pida tres números al usuario y muestre por pantalla cuál es el mínimo y cuál es el máximo y que indique si son pares o impares. No uses listas.

minimo = float('inf')
maximo = float('-inf')

for i in range(0, 3):
    print("")
    numero = int(input("Introduce un número: "))
    if numero < minimo:
        minimo = numero
    if numero > maximo:
        maximo = numero

if minimo%2 == 0:
    print("")
    print("El minimo es par", minimo)
else:
    print("")
    print("El minimo es impar", minimo)

if maximo%2 == 0:
    print("")
    print("El máximo es par", maximo, "\n")
else:
    print("")
    print("El máximo es impar", maximo, "\n")

        
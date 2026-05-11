# 9. Matematicando

# Haz un programa en Python que pida dos números enteros N y M al usuario.

# Calcula y muestra por pantalla el máximo común divisor (MCD) de N y M.

# Calcula y muestra por pantalla el mínimo común múltiplo (MCM) de N y M.

# ¿Lo tienes? Ahora haz lo mismo pero pidiendo varios números al usuario. Almacénalos

# en una lista y calcula el MCM y el MCD de todos ellos.x


#Listas

#Valores

n1 = int(input("Escriba un número a: "))

n2 = int(input("Escriba un número b: "))

#Funciones MCM/MCD

def MaximoComunDivisor(a,b):
    while b != 0:
        a, b = b, a % b
    return a

def MinimoComunMultiplo(a,b):
    (a*b)//MaximoComunDivisor
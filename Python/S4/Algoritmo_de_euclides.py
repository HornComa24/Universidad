#Realice un programa en python que implemente el algoritmo de euclides para obtener el mcd

def algoritmo_de_euclides(a,b):

    while b != 0:
        r = a % b
        a = b
        b = r

    return a

x = int(input("Escriba el dividendo: "))
y = int(input("Escriba el divisor: "))
mcd = algoritmo_de_euclides(x,y)
print(f"El mcd de {x} y de {y} es {mcd}")

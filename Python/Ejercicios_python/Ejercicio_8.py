# 8. Devolviendo el cambio

# Haz un programa que reciba un número que represente una cantidad de dinero D, incluyendo céntimos.

# Calcula la mínima cantidad de monedas necesarias para sumar D, suponiendo que tenemos monedas de 2, 1, 0.5, 0.2, 0.1, 0.05, 0.02, y 0.01.

# Muestra por pantalla la cantidad de cada una de las monedas.

#Monedas que podemos utilizar  2, 1, 0.5, 0.2, 0.1, 0.05, 0.02, y 0.01

def calcular_monedas(dinero):
    monedas_a_utilizar = [2, 1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01]
    listapesos = []

    for i in range(8):
        moneda = int(dinero//monedas_a_utilizar[i])
        listapesos.append(moneda)

    print(" \n Cantidad de monedas de 2€:", listapesos[0])
    print(" \n Cantidad de monedas de 1€:", listapesos[1])
    print(" \n Cantidad de monedas de 0.5€:", listapesos[2])
    print(" \n Cantidad de monedas de 0.2€:", listapesos[3])
    print(" \n Cantidad de monedas de 0.1€:", listapesos[4])
    print(" \n Cantidad de monedas de 0.05€:", listapesos[5])
    print(" \n Cantidad de monedas de 0.02€:", listapesos[6])
    print(" \n Cantidad de monedas de 0.01€:", listapesos[7], "\n")
    
print("")
dinero = float(input("Escriba el dinero tope: "))
calcular_monedas(dinero)

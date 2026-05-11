#Escriba en python un algoritmo para determinar los números primos de un número n, mediante divisiones sucesivas.
#Me costo entender el enunciado asi q lo pondre con mi palabras// Encontrar que numero primos multiplicado te dan el numero klio

def np(x):
    factores = []

    d = 2
    while x % d == 0:
        factores.append(d)
        x //= d # x pasa a ser la division exacta de x (numero) / en d (2) para q este siga diviendo

    d = 3
    while d * d <= x: #Se hace para q se usen los numero impares/primos q son el 5 y 7 y tambien en caso de q sea mayor q eso significa q todavia tiene posibles divisores
        while x % d == 0:
            factores.append(d)
            x //= d
        d += 2
    if x > 2:
        factores.append(x)

    return factores

a = int(input("Cual número quieres buscar sus factores: "))
valores = np(a)
print(f"Los factores de {a} son: {valores}")

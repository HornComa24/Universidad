# 1.Nada de “Hola, Mundo”

# Le tengo un poco de manía al típico ejercicio de “Hola, Mundo”. Esta es una alternativa un pelín más compleja.

# Haz un programa en Python que pida por teclado al usuario su nombre, su edad y su altura en metros.

# Después muestra por pantalla un mensaje del tipo:

# “El usuario NOMBRE, de EDAD años de edad y mide ALTURA metros”.

# ¿Eres capaz de modificarlo para que el mensaje sea de la siguiente manera? Solo pidiendo los tres valores indicados.

# “El usuario NOMBRE, de EDAD años de edad y mide METROS metros y CENTÍMETROS centímetros.”.

# Ejemplos:
# “El usuario Juan tiene 44 años de edad y mide 1.85 metros”.
# “El usuario Juan tiene 44 años de edad y mide 1 metro y 85 centímetros”.

print("")
n = input("Escriba su nombre: ")

print("")
e = int(input("Escriba su edad: "))

print("")
a = float(input("Escriba su altura (en metros): "))

m1 = int((a*100)%100)

c = int(((a*100)-m1)/100)

print("")
print("El usuario", n, "tiene", e, "años de edad y mide", a, "metros")
print("El usuario", n, "tiene", e, "años de edad y mide", c, "metros", m1, "centimetros")
print("")






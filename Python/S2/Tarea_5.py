# EJERCICIOS CON UN NUMERO VARIABLE DE PARAMETROS

import os

os.system('cls')

# POR POSICIÓN
# 1. Escribe una función llamada encontrar_maximo que reciba una cantidad variable de argumentos numéricos por posición y retorne el valor máximo entre ellos.

def encontrar_maximo(*args):
    print(f'{max(args)}')

print('\n-------------------------------------------------------------------\n')
encontrar_maximo(1,2,10,3,4,5)
print('\n-------------------------------------------------------------------')

# 2. Crea una función llamada calcular_promedio que reciba una cantidad variable de argumentos numéricos posicionales y retorne el promedio de todos ellos.

def calcular_promedio(*args):
    return print(sum(args) / len(args))
print('\n-------------------------------------------------------------------\n')
calcular_promedio(1,2,3)
print('\n-------------------------------------------------------------------')

# 3. Escribe una función llamada repetir_palabras que reciba una cantidad variable de argumentos posicionales de tipo cadena (str) y retorne una lista donde cada palabra esté repetida dos veces.

def repetir_palabras(*args):
    return print([palabra for palabra in args for _ in range(2)])
print('\n-------------------------------------------------------------------\n')
repetir_palabras('hola', 'mundo')
print('\n-------------------------------------------------------------------')

# 4. Crea una función llamada producto_numeros que reciba una cantidad variable de argumentos numéricos posicionales y retorne el producto de todos ellos.

def producto_numeros(*args):
    suma = 1
    for i in range(len(args)):
        suma *= args[i]
    return print(suma)
print('\n-------------------------------------------------------------------\n')
producto_numeros(1,2,3,4,5)
print('\n-------------------------------------------------------------------')

# POR NOMBRE
# 5. Escribe una función llamada saludo_personalizado que acepte un argumento obligatorio nombre y una cantidad variable de argumentos con nombre (usando **kwargs). La función debe construir y retornar un mensaje de saludo que incluya el nombre y cualquier otra información proporcionada como palabra clave.
#   Ej: print(saludo_personalizado("Juan", edad=30, ciudad="Madrid"))  
#   Imprimirá en pantalla: "Hola Juan, edad: 30, ciudad: Madrid"

def saludo_personalizado(nombre, **kwargs):
    mensaje = "Hola " + nombre
    for clave, valor in kwargs.items():
        mensaje += ", " + clave + ": " + str(valor)
    return print(mensaje)
print('\n-------------------------------------------------------------------\n')
saludo_personalizado("Juan", edad=30, ciudad="Madrid")
print('\n-------------------------------------------------------------------')

# 6. Crea una función llamada crear_perfil_usuario que acepte una cantidad variable de argumentos con nombre y retorne un diccionario que contenga toda la información del perfil del usuario.
#   Prueba la función con diferentes perfiles de usuario
#  Ej:
#   print(crear_perfil_usuario(nombre="Carlos", edad=25, ciudad="Sevilla"))  
#   {"nombre": "Carlos", "edad": 25, "ciudad": "Sevilla"}
#   print(crear_perfil_usuario(nombre="María", profesion="Doctora", pais="México"))  
#   {"nombre": "María", "profesion": "Doctora", "pais": "México"}

def crear_perfil_usuario(**kwargs):
    return print(kwargs)
print('\n-------------------------------------------------------------------\n')
crear_perfil_usuario(nombre="Carlos", edad=25, ciudad="Sevilla")
print('\n-------------------------------------------------------------------')

# 7. Escribe una función llamada actualizar_informacion que acepte un diccionario llamado info y una cantidad variable de argumentos con nombre (usando **kwargs). La función debe actualizar el diccionario info con la información proporcionada en kwargs y retornar el diccionario actualizado.
# Pista: Usa el método update() para actualizar el diccionario.

def actualizar_informacion(**kwargs):
    info = {"nombre": "Juan", "edad": 30, "ciudad": "Chile"}
    info.update(kwargs)
    return print(info)
print('\n-------------------------------------------------------------------\n')
actualizar_informacion(ciudad="Madrid", edad=31)
print('\n-------------------------------------------------------------------\n')

# 8. Crea una función llamada contar_argumentos que acepte una cantidad variable de argumentos con nombre (usando **kwargs) y retorne el número total de argumentos recibidos.
# Pista: Usa la función len() para obtener el número de elementos en kwargs.

def cortar_argumentos(**kwargs):
    return print(len(kwargs))
print('\n-------------------------------------------------------------------\n')
cortar_argumentos(nombre="Juan", edad=30, ciudad="Madrid")
print('\n-------------------------------------------------------------------\n')

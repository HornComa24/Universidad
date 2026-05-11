# Tarea 2

# Crea un programa que permita a un usuario registrar sus datos personales en un archivo de texto. El programa debe permitir al usuario ingresar su nombre, edad y correo electrónico. Luego, el programa debe guardar esta información en un archivo llamado "registros. txt" en el siguiente formato:
#  Nombre: [nombre] 
#  Edad: [edad] 
#  Correo: [correo]
#  Cada nuevo registro debe ser añadido al final del archivo.

# Requisitos 1. El programa debe permitir al usuario ingresar múltiples registros.
#            2. Después de cada registro, el programa debe preguntar si el usuario desea agregar otro registro.
#            Cuando el usuario decida no agregar más registros, el programa debe finalizar.

# Ingrese su nombre: Ana 
# Ingrese su edad: 28 
# Ingrese su correo electrónico: ana@example.com 
# <Desea agregar otro registro? (si/no): si

# Ingrese su nombre: Luis 
# Ingrese su edad: 35 
# Ingrese su correo electrónico: luis@example.com 
# <Desea agregar otro registro? (si/no): no

# EJEMPLO DE EJECUCIÓN
#   Nombre: Ana
#   Edad: 28
#   Correo: ana@example.com

# EJEMPLO DE ARCHIVO FINAL
#   Nombre: Luis
#   Edad: 35
#   Correo: luis@example.com

def registrar_datos():
    while True:
        q = input('\nQuiere ingresar datos (si/no): ')
        if q == 'si':
            nombre = input("\nIngrese su nombre: ")
            edad = input("\nIngrese su edad: ")
            correo = input('\nIngrese su correo: ')
            with open("Archivos_S2/registros.txt", "a") as archivo:
                archivo.write(f"\nNombre: {nombre}\nEdad: {edad}\nCorreo: {correo}\n")
        elif q == 'no':
            print('')
            break
        else:
            print('\nPor favor, ingrese si o no')
registrar_datos()

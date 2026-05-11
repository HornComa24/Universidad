# Tarea 1

# Infiltrado
# La empresa de realidad virtual "Abstergo Industries" sospecha que dentro de sus trabajadores se encuentra un infiltrado. Cada trabajador cuenta con un nombre asignado por la empresa y un ID que permite identificar a los trabajadores tal y como se muestra a continuación:
#   nombres = ["Altair","Ezio","Desmond","Ana","Carla", "Anais", "Edward", "Juno"].
#   id - [782,555,749,899,875,654,760,450]
# Se sabe que el nombre del sospechoso tiene menos de 7 letras y que su id es un número que está entre el 750 y el 780. Elabore una función Ilamada sospechoso(a,b) que recibe estas dos listas y retorne el nombre de las personas de la cuales se sospecha en formato de lista. Si no existe un sospechoso, la función deberá retornar un 0. El nombre de los no sospechosos deberá quedar almacenados en un archivo Ilamado noSospechosos.txt

nombres = ["Altair","Ezio","Desmond","Ana","Carla", "Anais", "Edward", "Juno"]
ids = [782,555,749,899,875,654,760,450]

def sospecho(a,b): 
    sospechoso = []
    try:
        with open('Archivos_S2/NoSospechoso.txt','x') as created:
            pass
        with open('Archivos_S2/NoSospechoso.txt','r+') as ns:
            no_sospechosos = ns.read().splitlines()
            for i in range(len(a)):
                if len(a[i]) < 7 and 750 <= b[i] <= 780:
                    sospechoso.append(a[i])
                else:
                    if a[i] not in no_sospechosos:
                        ns.write(f'{a[i]}\n')
        if len(sospechoso) == 0:
            return print('0')
        else:
            return print(f'\n{sospechoso}\n')
    except FileExistsError:
        with open('Archivos_S2/NoSospechoso.txt','r+') as ns:
            no_sospechosos = ns.read().splitlines()
            for i in range(len(a)):
                if len(a[i]) < 7 and 750 <= b[i] <= 780:
                    sospechoso.append(a[i])
                else:
                    if a[i] not in no_sospechosos:
                        ns.write(f'{a[i]}\n')
        if len(sospechoso) == 0:
            return 0
        else:
            print(f'\n{sospechoso}\n')
        
sospecho(nombres,ids)

# Tarea 2

# Exploración de un directorio recursivamente
# Objetivo: Recorrer un directorio y todos sus subdirectorios, listando todos los archivos y carpetas.
#   Instrucciones:
#     Escribe un programa que recorra un directorio especificado por el usuario y todos sus subdirectorios.
#     Lista todos los archivos y carpetas encontrados en el proceso.

import os 

directory = os.getcwd()

for Carpeta, Subcarpetas, Archivos in os.walk(directory):
    print(f'Carpeta: {Carpeta}')
    for subcarpeta in Subcarpetas:
        print(f'Subcarpeta: {subcarpeta}')
    for archivo in Archivos:
        print(f'Archivo: {archivo}')
            

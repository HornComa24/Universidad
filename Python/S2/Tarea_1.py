# Tarea 1: Escribir hacia un archivo de texto:

# Supongamos que tenemos un archivo de texto llamado "ejemplo.txt" con el siguiente

# contenido:
# Hola, este es un ejemplo de archivo de texto.
# Estamos aprendiendo a trabajar con archivos en Python.
# Espero que encuentres esto útil.

# Lea el contenido del archivo y copie las últimas dos líneas en otro archivo llamado
# doslineas_ejemplo.txt e imprima en pantalla las líneas copiadas

def escribir_contenido():
    contenido = ['Hola, este es un ejemplo de archivo de texto.','Estamos aprendiendo a trabajar con archivos en Python.','Espero que encuentres esto util.']
    with open('Archivos/ejemplo.txt','w') as e:
        for i in range(3):
            e.write(f"{contenido[i]}\n")
    with open('Archivos_S2/ejemplo.txt','r') as r:
        c = r.readlines()
    with open('Archivos_S2/nuevo_ejemplo.txt','w') as w:
        for i in range(-2,0):
            w.write(f"{c[i]}")
escribir_contenido()

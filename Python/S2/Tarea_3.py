# Desarrolle una función GeneradorDeArchivo que dada una ruta a un archivo ruta y un número entero n, genere un archivo que contenga n líneas con el siguiente formato:
# Linea 1
# Linea 2
# Linea 3
# ….
# Linea n

# Usando el archivo de texto generado con la función anterior y con al menos 10 líneas:
# ruta_archivo = '/content/archivo_generado.txt'
# numero_de_lineas = 10
# GeneradorDeArchivo(ruta_archivo, numero_de_lineas)

# Ahora :
# • Lea del archivo las primeras 5 líneas e imprímalas
# • Lea del archivo de la 3era a la 7ma líneas e imprímalas

def GeneradorDeArchivo(ruta_archivo,numero_de_lineas):
    with open(ruta_archivo,'w') as w:
        for i in range(numero_de_lineas):
            w.write(f'Linea {i+1}\n')
    with open(ruta_archivo,'r') as r:
        c = r.readlines()
        print(f'Primeras 5 lineas {c[:5]}')
        print(f'Lineas desde la 3 a la 7 {c[2:7]}')

GeneradorDeArchivo('Archivos_S2/archivo.txt',10)
    

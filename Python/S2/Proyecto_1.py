import os

def mostrar_menu():
    print("\n--- Editor de Textos en Python ---")
    print("\n1. Abrir archivo para escribir")
    print("2. Concatenar archivos")
    print("3. Borrar líneas que contengan una palabra")
    print("4. Mostrar contenido de un archivo")
    print("5. Buscar palabra en archivo")
    print("6. Eliminar un archivo")
    print("7. Muestas los archivos en el directorio actual")
    print("8. Mover archivo de una ruta a otra")
    print("9. Seleccionar ruta para buscar archivo o adjuntar ruta")
    print("10. Volver a la ruta anterior")
    print("11. Volver directorio principal")
    print("12. Salir")

def abrir_archivo_para_escribir(nombre_archivo): #esta función debe escribir en el archivo las lineas que escriba el usuario por el teclado excepto si la palabra q escribe es salir
    try:
        arop = open(nombre_archivo, 'a')
        while True:
            t = input("\nIngrese el texto a escribir (SALIR para finalizar): ")
            if t.upper() == "SALIR":
                arop.close()
                break
            arop.write(f'{t} \n')
    except FileNotFoundError:
        print("\nEl archivo no existe")
    except Exception as exist:
        print(f"\nError al abrir el archivo: {exist}")

def concatenar_archivos(archivo_salida, archivos_entrada): #toma una lista de archivos de entrada que pasa el usuario y los copia en el archivo salida
    try:
        contenido1 = []
        for i in range(len(archivos_entrada)):
            with open(f'{archivos_entrada[i]}','r') as arop:
               contenido = arop.read()
               contenido1.append(contenido)
        with open(archivo_salida,'w') as arop_new:
            for j in range(len(contenido1)):
                arop_new.write(f'{contenido1[j]}\n\n')
        print('\nCompletado')
    except FileNotFoundError:
        print("\nEl archivo no existe")
    except Exception as exist:
        print(f"\nError al abrir el archivo: {exist}")

def borrar_lineas_con_palabra(nombre_archivo, palabra): #busca una palabra en archivo y borra la linea que la contenga
    try:
        with open(nombre_archivo, 'r') as r:
            cont = r.readlines()
        with open(nombre_archivo, 'w') as w:
            for word in cont:
                if palabra not in word:
                    w.write(word)
        print('Completado')
    except FileNotFoundError:
        print("\nEl archivo no existe")
    except Exception as exist:
        print(f"\nError al abrir el archivo {exist}")


def mostrar_contenido_archivo(nombre_archivo): # muestra en consola el contenido del archivo
    try:
        with open(nombre_archivo,'r') as r:
            print(f'\n{r.read()}')
    except FileNotFoundError:
        print('\nEl archivo no existe')
    except Exception as exist:
        print(f'\nError al leer el archivo: {exist}')


def buscar_palabra_en_archivo(nombre_archivo, palabra): # busca palabra en archivo y cuenta en número de veces que aparece
    try:
        with open(nombre_archivo,'r') as r:
            contenido = r.read().split()
            cont = 0
            for i in range(len(contenido)):
                if palabra == contenido[i]:
                    cont += 1
            print(f'\nLa palabra {palabra} aparece {cont} veces')
    except FileNotFoundError:
        print('\nArchivo no encontrado ')
    except Exception as exist:
        print(f'\nError al leer el archivo: {exist}')

def seleccionar_ruta_del_archivo(nombre_archivo): #Ingresar ruta del archivo o directorio al cual quieres entrar
    try:
        archivos = os.listdir()
        directorio = os.getcwd()
        for i in range(len(archivos)):
            if archivos[i].upper() == nombre_archivo.upper():
                nueva_ruta = os.path.join(directorio, archivos[i])
                os.chdir(nueva_ruta)
                return nueva_ruta
        else:
            print('\nNo se encontró el archivo')
    except Exception as exist:
        print(f"\nError al seleccionar la ruta del archivo: {exist}")

def volver_ruta_del_archivo():
    try:
        os.chdir('..')
        return os.getcwd()
    except Exception as exist:
        print(f"\nError al volver a la ruta del archivo: {exist}")
        return os.getcwd()

def volver_al_directorio_principal():
    try:
        os.chdir('C://')
        print(f'\n{os.getcwd()}')
        print("\nVolvio al directorio principal")
    except Exception as exist:
        print(f"\nError al volver al directorio principal: {exist}")

def mostrar_archivos_directorio_actual():
    try:
        archivos = os.listdir()
        print(f'\n{archivos}')
    except Exception as exist:
        print(f"\nError al mostrar archivos del directorio actual: {exist}")

def mover_archivos_de_una_carpeta_a_otra(d1,d2,ruta1):
    try:
        ruta2 = ruta1
        ruta_archivo = os.path.join(d1,ruta1)
        ruta_archivo2 = os.path.join(d2,ruta2)
        os.replace(ruta_archivo, ruta_archivo2)
        os.remove(ruta_archivo) 
        print(f'\nEl archivo se ha movido con exito')
    except Exception as exist:
        print(f"\nError al mover el archivo: {exist}")   

def eliminar_archivo(archivo):
    try:
        os.remove(archivo)
        print(f'\nSe eliminó el archivo {archivo}')
    except Exception as exist:
        print(f"\nError al eliminar el archivo: {exist}")

def main():
    while True:
        mostrar_menu()
        opcion = input("\nSelecciona una opción: ")

        if opcion == '1':
            nombre_archivo = input("\nIngresa el nombre del archivo (incluye la extensión): ")
            abrir_archivo_para_escribir(nombre_archivo)
        elif opcion == '2':
            archivo_salida = input("\nIngresa el nombre del archivo de salida (incluye la extensión): ")
            archivos_entrada = input("\nIngresa los nombres de los archivos a concatenar, separados por comas: ").split(',')
            concatenar_archivos(archivo_salida, [archivo.strip() for archivo in archivos_entrada])
        elif opcion == '3':
            nombre_archivo = input("\nIngresa el nombre del archivo (incluye la extensión): ")
            palabra = input("\nIngresa la palabra a buscar para borrar líneas: ")
            borrar_lineas_con_palabra(nombre_archivo, palabra)
        elif opcion == '4':
            nombre_archivo = input("\nIngresa el nombre del archivo (incluye la extensión): ")
            mostrar_contenido_archivo(nombre_archivo)
        elif opcion == '5':
            nombre_archivo = input("\nIngresa el nombre del archivo (incluye la extensión): ")
            palabra = input("\nIngresa la palabra a buscar: ")
            buscar_palabra_en_archivo(nombre_archivo, palabra)
        elif opcion == '6':
            archivo = input('\nEscribir el nombre del archivo que desea eliminar (incluya la extencion): ')
            eliminar_archivo(archivo)
        elif opcion == '7':
            mostrar_archivos_directorio_actual()
        elif opcion == '8':
            d1 = input('\nEscribir directorio donde esta el archivo: ')
            ruta1 = input('\nEscribir el nombre del archivo que desea mover (incluyendo la extencion): ')
            d2 = input('\nEscribir directorio donde quiere moverse el archivo: ')
            mover_archivos_de_una_carpeta_a_otra(d1,d2,ruta1)
        elif opcion == '9':
            nombre_archivo = input("\nIngrese nombre del archivo/ruta: ")
            seleccionar_ruta_del_archivo(nombre_archivo)
            mostrar_archivos_directorio_actual()
        elif opcion == '10':
            volver_ruta_del_archivo()
            mostrar_archivos_directorio_actual()
        elif opcion == '11':
            volver_al_directorio_principal()
        elif opcion == '12':
            print("\nSaliendo del editor...")
            break
        else:
            print("\nOpción no válida. Intenta de nuevo.")

if __name__ == "__main__":
    main()

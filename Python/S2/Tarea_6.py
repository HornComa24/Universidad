# EJERCICIOS NUMPY, MATPLOTLIB y FICHEROS

    # Ejercicio 1. Crear una función que genere un gráfico de líneas a partir de datos leídos de un archivo de texto.

    # Tenemos el archivo de texto llamado líneas.txt que contiene dos columnas de números separados por espacios que corresponden a la evolución del precio del pan en 5 meses. Cada línea de este archivo es un par x, y que debemos usar en nuestro gráfico.
    # Define una función graficar_datos(archivo) que reciba el nombre del archivo de texto como parámetro.
    # La función debe leer los datos, generar un gráfico de líneas y mostrarlo utilizando matplotlib. Debe personalizar el gráfico según los datos del problema.

import os
import numpy as np
import matplotlib.pyplot as plt

def graficar_datos(archivo):
    meses = []
    precios = []
    with open(archivo,'r') as r:
        datos = r.read().split()
        for i in range(0,len(datos),2):
            meses.append(datos[i])
            precios.append(float(datos[i+1]))
    plt.plot(meses,precios, label='Precio del pan')
    plt.xlabel('Meses')
    plt.ylabel('Precio del pan')
    plt.title('Evolución del precio del pan')
    plt.legend()
    plt.show()

# graficar_datos('Archivos_S2/lineas.txt')

    # Ejercicio 2: Análisis de temperaturas diarias

    # Objetivo: Analizar las temperaturas diarias de una ciudad durante un mes.
    # 1. Dado el archivo de texto (temperaturas.txt) donde cada línea contiene el día del mes y la temperatura media de ese día.
    # 2. Define una función analizar_temperaturas(archivo) que:
    #   - Lea los datos del archivo utilizando ficheros.
    #   - Use numpy para calcular la temperatura promedio, la mínima y la máxima del mes.
    #   - Genere un gráfico con matplotlib que muestre las temperaturas diarias y además muestre la temperatura promedio, la mínima y la máxima del mes.
 
# import numpy as np

def analizar_tempraturas(archivo):
    with open(archivo,'r') as r:
        dias = []
        temperaturas = []
        datos = r.read().split()
        for i in range(0,len(datos),2):
            dias.append(int(datos[i]))
            temperaturas.append(float(datos[i+1]))
        promedio = np.mean(temperaturas)
        minima = np.min(temperaturas)
        maxima = np.max(temperaturas)
        plt.plot(dias, temperaturas, label='Temperaturas diarias')
        plt.axhline(y=promedio, color='r', label='Temperatura promedio', linestyle='--')
        plt.axhline(y=minima, color='g', label='Temperatura mínima', linestyle='--')
        plt.axhline(y=maxima, color='b', label='Temperatura máxima', linestyle='--')
        plt.xlabel('Días')
        plt.ylabel('Temperaturas (°C)')
        plt.ylabel('Temperaturas (°C)')
        plt.legend()
        plt.title('Análisis de temperaturas diarias')
        plt.show()

# analizar_tempraturas('Archivos/temperaturas.txt')


    # Ejercicio 3: Control de gastos personales

    # Objetivo: Llevar el control de los gastos personales durante un mes y analizar su evolución.
    #   1. Dado un archivo de texto (gastos.txt) en el cual se registraron los gastos diarios en distintas categorías (por ejemplo: comida, transporte, entretenimiento) separados por espacios.
    #   2. Define una función analizar_gastos(archivo) que:
    #       - Lea los datos del archivo y use numpy para sumar los gastos totales por categoría.
    #       - Genere gráficos de barras con matplotlib para visualizar el gasto en cada categoría y su evolución a lo largo del mes.

# import numpy as np
# import matplotlib.pyplot as plt

def analizar_gastos(archivo):
    dias = []
    categorias = {'Comida':[],'Transporte':[],'Entretenimiento':[]}
    with open(archivo,'r') as r:
        for l in r:
            datos = l.split()
            dias.append(int(datos[0]))
            categorias['Comida'].append(float(datos[1]))
            categorias['Transporte'].append(float(datos[2]))
            categorias['Entretenimiento'].append(float(datos[3]))
    total_comida = np.sum(categorias['Comida'])
    total_transporte = np.sum(categorias['Transporte'])
    total_entretenimiento = np.sum(categorias['Entretenimiento'])
    print(f'El Gasto total en comida es de: {total_comida}, Transporte: {total_transporte}, Entretenimiento: {total_entretenimiento}')
    categorias_totales = [total_comida, total_transporte, total_entretenimiento]
    nombres_categorias = ['Comida','Transporte','Entretenimiento']
    plt.bar(nombres_categorias, categorias_totales, color=['blue','green','red']) 
    plt.title('Gastos Totales por Categoría')
    plt.xlabel('Categoría')
    plt.ylabel('Gasto Total')
    plt.show()

# analizar_gastos('Archivos_S2/gastos.txt')


    # Ejercicio 4: Seguimiento del ejercicio físico

    # Objetivo: Monitorear el tiempo dedicado al ejercicio físico durante la semana.
    #   1. Dado un archivo de texto (ejercicio.txt) donde cada línea registre el día de la semana y los minutos de ejercicio físico realizados.
    #   2. Define una función analizar_ejercicio(archivo) que:
    #       - Lea los datos del archivo y los procese con numpy.
    #       - Calcule el tiempo promedio de ejercicio diario y visualice los datos diarios con un gráfico de barras usando matplotlib. Además, muestre en el gráfico el tiempo promedio de ejercicio diario.


#import matplotlib.pyplot as plt
#import numpy as np

def analizar_ejercicio(archivo):
    dias = [] 
    tiempos = []
    with open(archivo,'r') as r:
        for l in r:
            dia,tiempo = l.split( )   
            dias.append(dia)              
            tiempos.append(float(tiempo)) 
    tiempos = np.array(tiempos)
    tiempo_promedio = np.mean(tiempos)
    print(f'Tiempo promedio de ejercicio diario: {tiempo_promedio: .2f} horas')
    plt.bar(dias,tiempos,color='orange')
    plt.axhline(y=tiempo_promedio, color = 'r', linestyle = '-')
    plt.title('Horas de ejercicio por dia')
    plt.xlabel('Dia de la semana')
    plt.ylabel('Horas de ejercicio')
    plt.grid(True)
    plt.show()

# analizar_ejercicio('Archivos_S2/ejercicio.txt')

    # Ejercicio 5: Análisis del consumo eléctrico

    # Objetivo: Monitorear el consumo eléctrico en kilovatios-hora (kWh) de una casa durante un mes.
    #   1. Dado un archivo de texto (consumo.txt) donde cada línea contenga el día del mes y el consumo diario en kWh.
    #   2. Define una función analizar_consumo(archivo) que:
    #       - Lea el archivo y procese los datos usando numpy.
    #       - Calcule el consumo total, el promedio diario y visualice la evolución del consumo con un gráfico de líneas utilizando matplotlib.


#import matplotlib as plt
#import numpy as np

def analizar_consumo(archivo):
    dias = []
    consumo = []
    with open(archivo, 'r') as r:
        for d in r:
            dia, csm = d.split( )
            dias.append(dia)
            consumo.append(float(csm))
    consumo = np.array(consumo)
    consumo_total = np.sum(consumo)
    consumo_promedio = np.mean(consumo)
    print(f'Consumo total del mes: {consumo_total} kWh')
    print(f'Consumo promedio del mes: {consumo_promedio} kWh')
    plt.plot(dias,consumo, color='purple',marker='o')
    plt.axhline(y = consumo_promedio, color='r',linestyle='-')
    plt.title('Consumo electrico diario')
    plt.xlabel('Dia del mes')
    plt.ylabel('Consumo')
    plt.grid(True)
    plt.show()

# analizar_consumo('Archivos_S2/consumo.txt')

    # Ejercicio 6: Análisis de horas dedicadas a actividades diarias

    # Objetivo: Analizar el tiempo dedicado a distintas actividades diarias (trabajo, estudios, ejercicio, ocio) durante una semana.
    #   1. Dado el archivo de texto (actividades.txt) donde cada línea registre las horas dedicadas en un día a diferentes actividades: trabajo, estudios, ejercicio y ocio, separadas por espacios.
    #   2. Define una función analizar_actividades(archivo) que:
    #       - Lea los datos del archivo y calcule con numpy el tiempo total dedicado a cada actividad durante la semana.
    #       - Genere un gráfico de pastel (pie chart) que visualice la proporción de tiempo dedicado a cada actividad.

#import numpy as np
#import matplotlib.pyplot as plt

def analizar_actividades(archivo):
    categorias = ['Trabajo','Estudios','Ejercicio','Ocio']
    horas_totales = np.zeros(len(categorias))
    with open(archivo,'r') as r:
        for d in r:
            horas = d.split( )
            for i in range(len(horas)):
                horas_totales[i] += float(horas[i])
    for i, categoria in enumerate(categorias):
        print(f'Horas totales dedicadas a {categoria}: {horas_totales[i]}')
    plt.pie(horas_totales, labels=categorias, autopct='%1.1f%%', startangle=90, colors=['skyblue', 'lightgreen', 'orange', 'lightcoral'])
    plt.title('Distribucion del tiempo dedicado a actividades durante la semana')
    plt.show()

# analizar_actividades('Archivos_S2/actividades.txt')

    # Ejercicio 7: Análisis del rendimiento académico de estudiantes

    # Objetivo: Analizar el rendimiento académico de estudiantes utilizando varios archivos que contienen calificaciones en diferentes materias.

    #   1. Dados tres archivos de texto:
    #       - matematicas.txt: Contiene las calificaciones de matemáticas.
    #       - ciencias.txt: Contiene las calificaciones de ciencias.
    #       - historia.txt: Contiene las calificaciones de historia.

    # Cada archivo tiene el formato:
    # nombre_estudiante calificacion

    # Ej: matemáticas.txt
    # Juan 7
    # Maria 6
    # Juan 5
    # Pedro 3
    # Maria 5

    #   2. Define una función analizar_rendimiento(ruta) que:
    #       - Lea los archivos de calificaciones que se encuentran en la carpeta ruta.
    #       - Use numpy para calcular el promedio de calificaciones por estudiante en todas las materias.
    #       - Genere un gráfico de barras con matplotlib mostrando las calificaciones promedio por estudiante.

    #   3. Ahora redefina la función para que analice el rendimiento por asignaturas y genere un gráfico con el promedio de cada estudiante por asignatura.
    #       - Esta función se llamará analizar_rendimiento_asignatura(ruta)

#import numpy as np
#import matplotlib.pyplot as plt

def analizar_rendimiento(ruta):
    materias = ['matematicas.txt.txt','ciencias.txt.txt','historia.txt']
    estudiantes = {}
    for materia in materias:
        with open(ruta + materia,'r') as r:
            for a in r:
                nombre, calificacion = a.split( )
                calificacion = float(calificacion)
                if nombre not in estudiantes:
                    estudiantes[nombre] = []
                estudiantes[nombre].append(calificacion)
    nombres = list(estudiantes.keys())
    promedios = [np.mean(estudiantes[nombre]) for nombre in nombres]
    plt.bar(nombres,promedios,color=['blue','red','green','yellow'])
    plt.xlabel('Estudiantes')
    plt.ylabel('Promedio de Calificaciones')
    plt.title('Promedio de Calificaciones por Estudiante')
    plt.show()

# analizar_rendimiento('Archivos_S2/')

    # Usando los mismos archivos del ejercicio anterior, ahora analizaremos los promedios de cada estudiante separados por asignatura. 

#import numpy as np
#import matplotlib.pyplot as plt

def analizar_rendimiento_asignatura(ruta):
    materias = ['matematicas.txt.txt','ciencias.txt.txt','historia.txt']
    estudiantes = {}

    for materia in materias:
        with open(ruta+materia, 'r') as r:
            for d in r:
                nombre,calificacion = d.split( )
                calificacion = float(calificacion)
                if nombre not in estudiantes:
                    estudiantes[nombre] = [[],[],[]]
                indice_materia = materias.index(materia)
                estudiantes[nombre][indice_materia].append(calificacion)
    nombres_estudiantes = list(estudiantes.keys())
    promedio_matematicas = [np.mean(estudiantes[nombre][0]) for nombre in nombres_estudiantes]
    promedio_ciencias = [np.mean(estudiantes[nombre][1]) for nombre in nombres_estudiantes]
    promedio_historia = [np.mean(estudiantes[nombre][2]) for nombre in nombres_estudiantes]
    fig,axs = plt.subplots(1,3)
    axs[0].bar(nombres_estudiantes, promedio_matematicas, color='blue')
    axs[0].set_title('Promedio Matematicas')
    axs[0].set_xlabel('Estudiantes')
    axs[0].set_ylabel('Promedios')
    axs[1].bar(nombres_estudiantes, promedio_ciencias, color='green')
    axs[1].set_title('Promedio Ciencias')
    axs[1].set_xlabel('Estudiantes')
    axs[1].set_ylabel('Promedios')
    axs[2].bar(nombres_estudiantes, promedio_historia, color='brown')    
    axs[2].set_title('Promedio Historia')
    axs[2].set_xlabel('Estudiantes')
    axs[2].set_ylabel('Promedios')
    plt.show()

# analizar_rendimiento_asignatura('Archivos_S2/')

                                   

    # Ejercicio 8: Análisis de vent1as en diferentes tiendas

    # Objetivo: Analizar las ventas de diferentes tiendas en un mes utilizando archivos que contienen datos de ventas por día.

    #   1. Crea tres archivos de texto:
    #       o tienda1.txt: Contiene las ventas diarias de la tienda 1.
    #       o tienda2.txt: Contiene las ventas diarias de la tienda 2.
    #       o tienda3.txt: Contiene las ventas diarias de la tienda 3.

    # Cada archivo tiene el formato:
    # dia_venta valor_venta

    #   2. Define una función analizar_ventas(ruta) que:
    #       o Lea los archivos de ventas.
    #       o Use numpy para calcular las ventas totales de cada tienda.
    #       o Genere un gráfico de líneas con matplotlib mostrando la evolución de las ventas diarias para cada tienda.
    #   3. Modifique su código para que su función reciba una carpeta en la que se encuentran los archivos de las tiendas y sea capaz de leer todos los archivos de esa carpeta que empiecen con la palabra tienda y sean .txt y con esos archivos haga todo el procedimiento anterior.

#import numpy as np
#import matplotlib.pyplot as plt


def analizar_ventas(ruta):
    tiendas = ['tienda1.txt','tienda2.txt','tienda3.txt']
    ventas_por_tienda = []
    for tienda in tiendas: 
        dias = []
        ventas = []
        with open(ruta+tienda,'r') as r:
            for d in r:
                dia, venta = d.split( )
                dias.append(int(dia))
                ventas.append(float(venta))
        ventas_por_tienda.append((dias,ventas))
    for i, (dia, ventas) in enumerate(ventas_por_tienda):
        plt.plot(dias, ventas, label=f'Tienda {i+1}')
    plt.xlabel('Dia del mes')
    plt.ylabel('Ventas ($)')
    plt.title('Evolucion de las Ventas Diarias por Tienda')
    plt.legend()
    plt.grid(True)
    plt.show()

# analizar_ventas('Archivos_S2/')

    # Cambiemos el código anterior para que nuestra función sea capaz de leer todos los archivos de una carpeta que empiecen con la palabra tienda y terminen en .txt

#import os 
#import numpy as np
#import matplotlib.pyplot as plt

def analizar_ventas(ruta):
    tiendas = []
    for i in os.listdir(ruta):
        print(i)
        if i.startswith('tienda') and i.endswith('.txt'):
            tiendas.append(i)
    print(tiendas)
    ventas_por_tienda = []
    for tienda in tiendas: 
        dias = []
        ventas = []
        with open(ruta+tienda,'r') as r:
            for d in r:
                dia, venta = d.split( )
                dias.append(int(dia))
                ventas.append(float(venta))
        ventas_por_tienda.append((dias,ventas))
    for i, (dia, ventas) in enumerate(ventas_por_tienda):
        plt.plot(dias, ventas, label=f'Tienda {i+1}')
    plt.xlabel('Dia del mes')
    plt.ylabel('Ventas ($)')
    plt.title('Evolucion de las Ventas Diarias por Tienda')
    plt.legend()
    plt.grid(True)
    plt.show()

# analizar_ventas('Archivos_S2/')

    # Ejercicio 9: Análisis del consumo de agua en hogares

    # Objetivo: Analizar el consumo de agua en diferentes hogares utilizando archivos que registran el consumo mensual.

    #   1. Dada la carpeta ruta que contiene archivos que describen el consumo mensual de agua en diferentes hogares con el formato:
    #       - hogar1.txt: Contiene el consumo de agua mensual del hogar 1.
    #       - hogar2.txt: Contiene el consumo de agua mensual del hogar 2.
    #       - hogar3.txt: Contiene el consumo de agua mensual del hogar 3.

    # Cada archivo tiene el formato:
    # mes consumo_m3

    #   2. Define una función analizar_consumo_agua(ruta) que:
    #       - Lea los archivos de consumo. Para ello, su función leerá todos los archivos que se encuentren dentro de la carpeta ruta y se quedará con los archivos dentro de esa carpeta que empiecen con la palabra hogar y sean archivos de texto .txt.
    #       - Use numpy para calcular el consumo promedio mensual de cada hogar.
    #       - Genere un gráfico de pastel (pie chart) con matplotlib mostrando la proporción del consumo total de cada hogar.

#import os
#import numpy as np
#import matplotlib.pyplot as plt

def analizar_consumo_agua(ruta):
    hogares = {}
    # Buscar archivos de consumo de agua
    for archivo in os.listdir(ruta):
        if archivo.startswith('hogar') and archivo.endswith('.txt'):
            consumos = []
            try:
                with open(os.path.join(ruta, archivo), 'r') as f:
                    for linea in f:
                        if linea.strip():  # Evitar líneas vacías
                            mes, consumo = linea.split()
                            consumos.append(float(consumo))  
                if consumos:
                    hogares[archivo] = np.mean(consumos)  # Guardar el promedio
            except ValueError:
                print(f"Error al leer el archivo {archivo}. Verifica su formato.")
    if hogares:
        # Mostrar promedios individuales
        for hogar, promedio in hogares.items():
            print(f'El promedio mensual de {hogar} es: {promedio:.2f} m³')
        # Gráfico de pastel con todos los hogares
        plt.pie(hogares.values(), labels=hogares.keys(), autopct='%1.1f%%', startangle=140)
        plt.title('Proporción del consumo de agua por hogar')
        plt.show()
    else:
        print("No se encontraron datos de consumo de agua.")

# analizar_consumo_agua('Archivos_S2/')

    # Ejercicio 10: Análisis de Productividad en una Empresa

    # Objetivo: Analizar la productividad de los empleados en una empresa utilizando archivos que registran la cantidad de horas dedicadas a diferentes tipos de tareas diariamente.

    # Descripción del Ejercicio: Cada empleado tiene un archivo de texto asociado que registra las horas dedicadas diariamente a cuatro categorías de tareas:
    #   - Tareas Administrativas
    #   - Tareas Productiva
    #   - Tareas Comunicativas
    #   - Reuniones

    # El formato de cada archivo es el siguiente:
    # Requisitos

    #   1. Archivos de Datos:
    #       - Se proporcionan archivos de texto para cinco empleados. Cada archivo debe tener el nombre empleadoX.txt, donde X es un número del 1 al 5.
    #       - Ejemplos de archivos generados:
    #           - empleado1.txt
    #           - empleado2.txt
    #           - empleado3.txt
    #           - empleado4.txt
    #           - empleado5.txt

    #   2. Función en Python:
    #       - La función debe recibir la ruta a una carpeta que contenga los archivos de todos los empleados.
    #       - La función debe listar todos los archivos en la carpeta y usar aquellos que comienzan con "empleado" y terminan en ".txt".
    #       - La función debe leer los datos de estos archivos, procesar la información y generar gráficos para cada empleado que muestren las horas dedicadas a cada tipo de tarea.

# import os
# import matplotlib.pyplot as plt

def horas_de_trabajo(ruta):
    empleados = []
    datos = []
    tareas = ["Tareas Administrativas", "Tareas Productivas", "Tareas Comunicativas", "Reuniones"]
    
    # Leer los archivos de empleados
    for archivo in os.listdir(ruta):
        if archivo.startswith('empleado') and archivo.endswith('.txt'):
            empleados.append(archivo)
            with open(os.path.join(ruta, archivo), 'r') as es:
                a = es.read().split()
                for dato in a:
                    if dato.isdigit():
                        datos.append(int(dato))  # Convertir directamente a int

    # Mostrar los datos (puedes ajustarlo según lo que quieras ver)
    print(datos)

    # Asumiendo que hay 4 valores por empleado (ajustar según el formato de tus datos)
    horas_por_empleado = [datos[i:i+4] for i in range(0, len(datos), 4)]

    # Para cada tarea (índice de tareas), crear un gráfico con los datos correspondientes de todos los empleados
    for j, tarea in enumerate(tareas):
        horas_tarea = []
        for i in range(len(empleados)):
            horas_tarea.append(horas_por_empleado[i][j])  # Obtener la hora de cada empleado para la tarea j

        # Generar el gráfico de pie 
        plt.pie(horas_tarea, labels=empleados, autopct='%1.1f%%')
        plt.title(f'Distribución de horas en {tarea}')
        plt.show()

# Llamada de ejemplo
horas_de_trabajo('Archivos_S2/')


#   10.1- Modifiquemos el codigo para que genere cuatro subgráficas, cada una representando las horas dedicadas a una actividad específica (Administrativa, Productiva, Comunicativa y Reuniones) en promedio por cada trabajador.












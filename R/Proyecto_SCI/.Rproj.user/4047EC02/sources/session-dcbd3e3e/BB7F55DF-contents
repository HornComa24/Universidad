
# Cargar las librerías ----------------------------------------------------

library(readxl)
library(skimr)

tiempos <- c(
  0.52, 0.51, 0.53, 0.52, 0.51, 0.52, # PID - Ligera
  4.85, 4.86, 4.84, 4.85, 4.87, 4.85, # PID - Pesada
  0.85, 0.84, 0.86, 0.85, 0.84, 0.85, # LQR - Ligera
  4.62, 4.63, 4.61, 4.62, 4.64, 4.62  # LQR - Pesada
)

# Creamos las etiquetas para cada uno de esos 24 datos --------------------
# 'rep' repite elementos. Queremos 12 datos PID, luego 12 LQR. ------------

controlador <- rep(c("PID", "LQR"), each = 12)


# Queremos 6 Ligera, 6 Pesada, y repetir eso 2 veces. ---------------------

carga <- rep(rep(c("Ligera", "Pesada"), each = 6), times = 2)

# Armamos la tabla final asegurándonos de que las categorías sean  --------

datos <- data.frame(
  Controlador = as.factor(controlador),
  Carga = as.factor(carga),
  Tiempo = tiempos
)

# Usamos skim para un resumen estadístico ---------------------------------

skim(datos)

# Existen 0 datos missing, el diseño de la tabla es bastante balanceado ya que son 12 datos de PID
# y LQR el promedio global es de 2.71 segundos, pero la desviacion es de 2.08. Esta desviacion tan 
# alta respecto a la media nos da una pista de que los datos estan partido en dos extremos

# Creamos el boxplox ------------------------------------------------------

boxplot(data=datos, Tiempo~Carga + Controlador, main="Datos",
        xlab="Carga",ylab="Tiempo",col="orange")


# Grafico de Interacción  -------------------------------------------------

interaction.plot(datos$Carga, datos$Controlador, datos$Tiempo, 
                 col=c("blue", "red"), lty=1, lwd=2, trace.label="Controlador")

# Modelo Anova  -----------------------------------------------------------

# Ejecutamos el modelo ANOVA de dos vías con interacción
modelo_anova <- aov(Tiempo ~ Controlador * Carga, data = datos)


# Mostramos la tabla de resultados
summary(modelo_anova)






#Modelos de regresión lineal simple

# Librerías ---------------------------------------------------------------
library(readr)
library(dplyr)
library(lmtest)
library(MASS)

# Importar datos ----------------------------------------------------------

datos <- read.csv("Turbina.csv", sep=";", dec=",")
head(datos)

datos_limpios <- datos %>%
  mutate(across(c(horas,desgaste), as.numeric))

# Análisis Descriptivo e Inicial ----------------------------------------------------

#Scatterplot

plot(datos$horas,datos$desgaste,
     main= "Desgaste vs Horas",
     xlab="Horas",
     ylab= "Desgaste",
     pch = 8,
     col = "pink")

# no parece relación lineal ya que los datos siguen una curva
# a medida que avanzan las horas la nube de puntos se ensancha.
# entre las 0 y 4 horas los puntos estan mas juntos pero luego de las 8 y 10 hs hay mucha mas dispersión lo que indica heterocedasticidad
# se puede usar la transformacion de box-cox ya que la relación no es una linea perfecta y la variabilidad aumenta

# Ajuste del Modelo Lineal Simple -----------------------------------------

modelo_a <- lm(desgaste ~ horas, data=datos_limpios )
summary(modelo_a)
plot(modelo_a, which=1)
plot(modelo_a, which=2)

# el primer grafico de residuals vs fitted tiene una forma de parabola, lo que confirma que la relación no es lineal
# en el grafico de q-q residuals los puntos de la derecha se alejan mucho de la linea punteada hacia arriba, lo que significa que el supuesto de normalidad no se cumple del todo debido a estos

shapiro.test(residuals(modelo_a))
bptest(modelo_a)

# se rechaza la hipotesis nula de que la varianza es constante ya que el p-valor es menor a 0.05

# Transformación de boxcox ------------------------------------------------

bc <- boxcox(desgaste ~ horas, data=datos, lambda = seq(-2,2,0.1))
lambda_optimo <- bc$x[which.max(bc$y)]
lambda_optimo #obtener lambda

#que el lambda sea muy cercano a 0 indica que la transformacion ideal es la logaritmica

modelo_b = lm(log(desgaste) ~ horas, data=datos)
plot(modelo_b, which=1)
plot(modelo_b, which=2)

shapiro.test(residuals(modelo_b))
bptest(modelo_b)

# no se rechaza la hipotesis nula de normalidad ya que el p-value de el modelo_b es de 0.6347
# lo cual confirma que los residuos siguen una distribución normal validando el plot 2 de Q-Q
# residuals tambien el p-value de bptest (0.7649) indica la varianza de los errores es constante

# Graficar recta ----------------------------------------------------------

plot(datos$horas, datos$desgaste, main= "modelo transformado vs original",
     xlab="horas",ylab="desgaste",pch=8,col="pink") 
curve(exp(coef(modelo_b)[1]+coef(modelo_b)[2]*x),
      add=TRUE,col="blue",lwd=2)

abline(modelo_a,col="green",lty=2)

# Se observa claramente que el modela a tiene una linea recta (verde) la cual no logra representar la tendencia de los datos
# en cuanto al modelo b sigue con mucha presición la curvatura de la nube de puntos, el modelo reconoce que el desgaste no es
# constante, si no que se acelera conforme pasan las horas por ende el modelo transformado es mucho mas confiable para realizar
# predicciones de mantenimientos, ya que se ajusta a la realidad física de la degradación de la turbina

summary(modelo_b)

# Como aplicamos un logaritmo a la variable dependiente (ln(desgaste) = B0 + B1 * horas), la interpretación debe ser porcentual:

# Intercepto B0 = -0.12760 es el desgaste esperado cuando las horas de uso son 0. Si calculamos su exponencial e^-0.12760 = 0.88
# lo cual seria su desgaste inicial estimado en la escala original al empezar el uso

# Coeficiente de horas B1 = 0.42353 este valor indica el cambio porcentual por cada unidad de tiempo 
# Calculo = [e^0.42353-1]*100 = 52-73%
# Lo cual significa que por cada hora de funcionamiento, el desgaste de la turbina aumenta, en promedio, un 52.73% respecto al 
# nivel de desgaste alcanzado en la hora anterior

# El modelo explica el 96.22% de la variabilidad del desgaste (R-squared ajustado), demostrando una alta capacidad predictiva.





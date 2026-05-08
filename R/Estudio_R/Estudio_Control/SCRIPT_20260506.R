

# Librerias ---------------------------------------------------------------

library(skimr)
library(lmtest)

# Lectura del csv ---------------------------------------------------------

df <- read.csv("estudio_regresion.csv")
str(df)  
skim(df)
summary(df)

# Comparación T vs C ------------------------------------------------------

plot(df$consumo, df$temperatura,
     main = "Efecto de la temperatura en el consumo",
     xlab = "Temperatura (C°)",
     ylab = "Consumo (MWh) ")

# Correlación Spearman ----------------------------------------------------

cor(df$consumo, df$temperatura, method = "spearman")

# Modelo de regresión lineal ----------------------------------------------

modelo <- lm(temperatura ~ consumo, data = df)

summary(modelo)

# Se rechaza la hipotesis inicial en otras palabras la temperatura si afecta al consumo 

# Tiene una confiabilidad de un 16.5% de variabilidad total de la temperatura respecto al consumo

# Supuestos ---------------------------------------------------------------

plot(modelo, which=1)

# No existe linealidad incluso podriamos decir q es una V invertida ya que va ascendiendo
# en un pr

plot(modelo, which=2)

# Se puede ver que los datos outlier afectan a la recta

shapiro.test(residuals(modelo))
dwtest(modelo)

# Queda demostrado que los datos no esta correlacionados y lo que afectan los datos outlier

modelo_ajustado <- lm(temperatura ~ consumo, data = df[-c(49,50), ])
summary(modelo_ajustado)

shapiro.test(residuals(modelo_ajustado))
dwtest(modelo_ajustado)


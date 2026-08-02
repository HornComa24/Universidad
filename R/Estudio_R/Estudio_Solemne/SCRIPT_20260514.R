

# Librerias ---------------------------------------------------------------

library(skimr)
library(tidyverse)

# Crear lista de datos ----------------------------------------------------

df = data.frame(
  temperatura = c(150,160,170,180,190,200,210,220,230,240,250,260,270,280,290),
  consumo = c(164.40,175.70,201.59,194.71,203.29,227.15,222.61,213.35,227.13,237.54,262.24,261.60,270.01,275.11,276.44)
)

modelo <- lm(consumo ~ temperatura, data = df)

summary(modelo)

# El beta 1 es 0.78 lo que significa que por cada unidad de X o de temperatura aumenta el consumo 

# En cuanto a los p-valor que es < 0.05 lo que significa que la temperatura si afecta o esta relacionado con el consumo

# y en cuando al R^2 la temperatura logra explicar tiene un porcentaje de 94% de variabilidad total

tabla_anova <- anova(modelo)

print(tabla_anova)

# Consumo = 55.253 + 0.783 * Temperatura





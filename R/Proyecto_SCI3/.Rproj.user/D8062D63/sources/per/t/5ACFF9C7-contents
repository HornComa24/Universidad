

# Librerias ---------------------------------------------------------------

library(skimr)
library(GGally)
library(lmtest)
library(car)

# Lectura de datos --------------------------------------------------------

datos <- read.csv("BD_Presion.csv")
datos_limpios <- datos[, -1]
skim(datos_limpios)
summary(datos_limpios)

# Graficos ----------------------------------------------------------------

ggpairs(data = datos_limpios, lower = list(continuous = "smooth")) # General

# Histogramas -------------------------------------------------------------

hist(datos_limpios$PAS,
     freq = FALSE,
     main="Presión arterial",
     xlab="Presión arterial",
     ylab="Densidad")

hist(datos_limpios$Edad,
     freq = FALSE,
     main="Edad",
     xlab="Edad",
     ylab="Densidad")

hist(datos_limpios$Peso,
     freq = FALSE,
     main="Peso",
     xlab="Peso",
     ylab="Densidad")

hist(datos_limpios$Estatura,
     freq = FALSE,
     main="Estatura",
     xlab="Estatura",
     ylab="Densidad")

hist(datos_limpios$IMC,
     freq = FALSE,
     main="IMC",
     xlab="IMC",
     ylab="Densidad")

hist(datos_limpios$Glucosa,
     freq = FALSE,
     main="Glucosa",
     xlab="Glucosa",
     ylab="Densidad")

hist(datos_limpios$Actividad,
     freq = FALSE,
     main="Actividad",
     xlab="Actividad",
     ylab="Densidad")

# Modelos -----------------------------------------------------------------

modelo <- lm(PAS ~ Edad + Peso + Estatura + IMC + Glucosa + Actividad, data = datos_limpios)

summary(modelo)

# Anova -------------------------------------------------------------------

tabla_anova <- anova(modelo)
print(tabla_anova)

# 5. Coeficiente de Determinación ---------------------------

SSReg <- sum(tabla_anova$`Sum Sq`[1:6])
SSE   <- tabla_anova$`Sum Sq`[7]
SST   <- SSReg + SSE
R2    <- SSReg / SST
cat("El R-cuadrado calculado es:", R2, "\n")

# 6. Intervalos de Confianza ----------------------------------------------

intervalos <- confint(modelo, level = 0.95)
print(intervalos)

# 7. Análisis de Supuesto ------------------------------------

par(mfrow = c(1,2))

# Normalidad

plot(modelo, which = 2)
shapiro.test(residuals(modelo))

# Homocedasticidad

plot(modelo, which = 1)
bptest(modelo)

# Independencia

dwtest(modelo)

# Multicolinealidad

vif(modelo)



# Librerias ---------------------------------------------------------------

library(readr) # Leer csv
library(readxl) # Leer excel
library(writexl) 
library(haven) # leer otro formatos
library(dplyr) # Manejo de DataFrame
library(skimr)

# Casos de lectura --------------------------------------------------------

#Existen varias funciones para poder leer distintos tipos de datos y varia
#librerias con funciones interesantes. Aca ocuparemos las funciones de las 
#librerias readr y readrl, aunque R base tambien trae funciones de lectura 
#por defecto

setwd("/home/Seba/Descargas/Proyecto_Sebastian_Flores")

# Lea la base llamada base1

df1 <- read_csv("Bases/base1.csv")
head(df1)

# Lea la base llamada base2

df2 <- read_delim("Bases/base2.txt", delim = "|")
tail(df2)

# Lea la base llamada base3

df3 <- read_csv2("Bases/base3.csv") # Separado por ;
tail(df3)

# Lea la base llamada base4

df4 <- readxl::read_excel("Bases/base4.xlsx")
head(df4)

# Lea la base llamada base5

df5 <- read_excel("Bases/Base 5.xlsx", sheet="Datos", range="D4:H154")
head(df5)

# Lea la base llamada base6

df6 <- haven::read_dta("Bases/base6.dta")
head(df6)

# Leer RDS

df7 <- readRDS("Bases/base3.RDS")
head(df7)

# Casos de escritura ------------------------------------------------------

# Asi como existen funciones de lectura, tambien existen funciones de escritura
# Aca indagaremos en las funciones write

# Lea la base mtcars desde R y guardela en un data frame (df)

df <- mtcars

# Guarde la base con formato csv separado por comas

write_csv(x=df,file="Bases/escritura1.csv")

# Guarde la base con formato csv separado por punto y coma

write_csv2(x=df, file="Bases/escritura2.csv")

# Guarde la base con formato de excel
# - Millas por  galón
# - Potencia
# - Cilindros
# - Tipo de motor
# Cambie los nombres a las variables

df2 <-
  df %>%
  select(mpg,hp,cyl,am)



head(df2)

colnames(df2) <- c("MPG","POT","CIL","IPMOTOR")

head(df2)

writexl::write_xlsx(x = df2, path = "Bases/escritura3.xlsx", 
                    col_names = TRUE)

rm(list=ls())
gc()

# Leer df
df <- mtcars
skim(df) # Descripcion, pero toma continuos los factores

#Crea factor para la cantidad de cilindros
df$cyl <- factor(df$cyl, levels=c(0,1), labels = c("Automatico","Manual"))

skim(df) # Descriptivo con factor

df$cyl <- factor(df$cyl, levels=c(4,6,8), labels=c("4 cil","6 cil","8 cil"))

skim(df)

# Hisotgrama

hist(df$mpg,
     col='blue',
     main="Histograma de MPG \n millas por galon",
     xlab="Valores",
     ylab="Frecuencia")

# Barras

plot(df$cyl, type="h", col="red")

hist(df$mpg,
     col='blue',
     main="Histograma de MPG \n millas por galon",
     xlab="Valores",
     ylab="Frecuencia",
     freq=FALSE)

lines(density(df$mpg, adjust=2), col="red", lty=3, lwd=4)

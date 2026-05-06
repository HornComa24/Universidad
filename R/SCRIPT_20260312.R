
# Librerias ---------------------------------------------------------------

library(dplyr) # manejo de base de datos
library(skimr) # analisis descriptio
library(naniar) # analisis de NA
library(visdat)
library(VIM)

# Base de datos -----------------------------------------------------------

df <- mtcars

# Caracteristicas del rendimiento de 32 modelos de autos 

head(df,n=5)

#Transformar factores

df$vs <- factor(df$vs, levels=c(0,1),labels=c("En V", "Lineal"))
df$am <- factor(df$am, levels=c(0,1),labels=c("Automatica","Manual"))


# Analisis Descriptivo  ---------------------------------------------------

skim(df)

# Crea una variable que permita identificar si la observacion tiene millas por galo sobre o bajo la media de la muestra

df <- 
  df %>%
  mutate(id_med_mgp = ifelse(mpg <= 15.4,1,2))

df_menor_median <-
  df %>%
  filter(id_med_mgp == 1)

#Calcule el promedio de las millas por galon por cylindrada para aquellas observaciones con mpg sobre la median


df_cyl <- 
  df %>%
    filter(id_med_mgp == 2) %>%
    group_by(cyl) %>%
    summarise(media_mpg = mean(mpg))

# Analisis de NA en base de Calidad de aire -------------------------------

## Lectura de base de datos -----

df_ca <- airquality
vis_dat(df)
vis_miss(df_ca)
gg_miss_upset(df_ca)

aggr(df_ca, numbers=TRUE, prop=FALSE)




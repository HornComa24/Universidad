
# Manipulacion de vectores ---------------------------------------------------

# Cree un vector con una secuencia de numeros pares desde el 4 al 40

x_par <- seq(from=4, to=40, by=2); x_par
lv <- length(x_par)
v <- c()

for(i in 1:lv) {
  if (x_par[i] %% 12 == 0) {
    n <- paste(x_par[i], "Número Par")
    v <- append(v,x_par[i])
    print(n)
  } else {
    n <- paste(x_par[i], "Número Impar")
    print(n)
  }
}

# Respuesta como vector 

solucion <- paste("Este es el vector divisible por 12:", paste(v, collapse = ", "))
print(solucion)
  
# Realizar este ciclo con instrucciones while

# aplicacion de algunas funciones

x_par

x_acum <- cumsum(x_par); x_acum # Acumulado}

# Crear matriz a partir de un vector

x_9 <- x_par[1:9]; x_9

mx_col <- matrix(x_9, ncol=3); mx_col

mx_fil <- matrix(x_9, ncol=3, byrow =TRUE); mx_fil


# DATAFRAME ---------------------------------------------------------------

df <- data.frame(Nombre = c("Oscar", "Seba", "Diego"),
                 Edad = c(80,20,26),
                 Peso = c(50,75,80),
                 Comuna = c("Santiago", "Puente Alto", "Puente Alto"))

print(df)

head(df, n=2)
tail(df, n=1)

df$Edad

mean(df$Edad)

df[df$Edad <= 20, "Nombre"]

df1 <- data.frame(Nombre = c("Oscar", "Seba", "Diego"),
                 Edad = c(80,20,26),
                 Peso = c(50,75,80),
                 Comuna = c("Santiago", "Puente Alto", "Puente Alto"),
                 Sexo = c(1,1,0))

summary(df1)

# Crear Factor ------------------------------------------------------------

df1$Sexo <- factor(df1$Sexo, levels=c(0,1), labels=c("Mujer","Hombre"))

summary(df1)

# Analisis exploratorio ---------------------------------------------------

library(skimr)
skim(df1)



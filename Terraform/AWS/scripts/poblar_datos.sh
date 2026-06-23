#!/bin/bash
# =========================================================================
# SCRIPT PARA GENERAR DATOS ALEATORIOS EN MARIADB O POSTGRESQL
# =========================================================================

# Diccionarios para generar datos aleatorios
NOMBRES=("Sebastian" "Alejandra" "Diego" "Camila" "Nicolas" "Valentina" "Martin" "Sofia")
APELLIDOS=("Flores" "Gonzalez" "Perez" "Muñoz" "Rojas" "Soto" "Contreras" "Silva")
DOMINIOS=("gmail.com" "outlook.com" "universidad.edu" "empresa.cl")

GENERAR_REGISTROS=50

# 1. DETECTAR QUÉ MOTOR ESTÁ INSTALADO EN ESTE SERVIDOR Y DETERMINAR LA BD CORRECTA
if systemctl is-active --quiet mariadb; then
  DB_NAME="db_comercial"
  echo "[+] Detectado: MariaDB activo. Generando registros en la base de datos '${DB_NAME}'..."

  # Crear Tabla (la base de datos db_comercial ya fue creada en instalar_mariadb.sh)
  mysql -u root -D "${DB_NAME}" -e "
        CREATE TABLE IF NOT EXISTS usuarios (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nombre VARCHAR(50),
            apellido VARCHAR(50),
            email VARCHAR(100),
            fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );"

  # Insertar datos aleatorios
  for ((i = 1; i <= GENERAR_REGISTROS; i++)); do
    NOM=${NOMBRES[$RANDOM % ${#NOMBRES[@]}]}
    APE=${APELLIDOS[$RANDOM % ${#APELLIDOS[@]}]}
    DOM=${DOMINIOS[$RANDOM % ${#DOMINIOS[@]}]}
    EMAIL="${NOM,,}.${APE,,}$RANDOM@${DOM}" # ,, convierte a minúsculas en Bash 4+

    mysql -u root -D "${DB_NAME}" -e "INSERT INTO usuarios (nombre, apellido, email) VALUES ('$NOM', '$APE', '$EMAIL');"
  done
  echo "[✓] Población exitosa en MariaDB: Se insertaron ${GENERAR_REGISTROS} usuarios en '${DB_NAME}'."

elif systemctl is-active --quiet postgresql; then
  DB_NAME="db_backup"
  echo "[+] Detectado: PostgreSQL activo. Generando registros en la base de datos '${DB_NAME}'..."

  # Crear Tabla (la base de datos db_backup ya fue creada en instalar_postgresql.sh)
  sudo -u postgres psql -d "${DB_NAME}" -c "
        CREATE TABLE IF NOT EXISTS usuarios (
            id SERIAL PRIMARY KEY,
            nombre VARCHAR(50),
            apellido VARCHAR(50),
            email VARCHAR(100),
            fecha_registro TIMESTAMP DEFAULT NOW()
        );"

  # Insertar datos aleatorios
  for ((i = 1; i <= GENERAR_REGISTROS; i++)); do
    NOM=${NOMBRES[$RANDOM % ${#NOMBRES[@]}]}
    APE=${APELLIDOS[$RANDOM % ${#APELLIDOS[@]}]}
    DOM=${DOMINIOS[$RANDOM % ${#DOMINIOS[@]}]}
    EMAIL="${NOM,,}.${APE,,}$RANDOM@${DOM}"

    sudo -u postgres psql -d "${DB_NAME}" -c "INSERT INTO usuarios (nombre, apellido, email) VALUES ('$NOM', '$APE', '$EMAIL');"
  done
  echo "[✓] Población exitosa en PostgreSQL: Se insertaron ${GENERAR_REGISTROS} usuarios en '${DB_NAME}'."

else
  echo "[!] Error: No se detectó MariaDB ni PostgreSQL activo en este servidor."
  exit 1
fi

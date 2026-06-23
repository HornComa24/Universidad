#!/bin/bash
# =========================================================================
# CONFIGURACIÓN DE POSTGRESQL Y CREACIÓN DE BD EN SERVER-2
# =========================================================================

echo "=== 1. Instalando cronie y utilitarios ==="
sudo dnf install -y cronie
sudo systemctl start crond
sudo systemctl enable crond

echo "=== 2. Instalando PostgreSQL 15 Server ==="
sudo dnf install -y postgresql15-server

echo "=== 3. Inicializando la base de datos ==="
sudo postgresql-setup --initdb

echo "=== 4. Iniciando y habilitando el servicio ==="
sudo systemctl start postgresql
sudo systemctl enable postgresql

echo "=== 6. Creando Base de Datos y Usuario de Respaldo ==="
DB_NAME="db_backup"
DB_USER="user_backup"
DB_PASS="PasswordPostgres456!" # Cambia esto por algo más seguro

# PostgreSQL requiere comandos específicos usando el usuario del sistema 'postgres'
sudo -u postgres psql -c "CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASS}';"
sudo -u postgres psql -c "CREATE DATABASE ${DB_NAME} OWNER ${DB_USER};"

echo "=== 7. Verificando las Bases de Datos ==="
sudo -u postgres psql -c "\l"

echo "=== ¡PostgreSQL y Base de Datos '${DB_NAME}' listos en Server-2! ==="

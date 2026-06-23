#!/bin/bash
# =========================================================================
# CONFIGURACIÓN DE MARIADB Y CREACIÓN DE BD EN SERVER-1
# =========================================================================

echo "=== 1. Instalando cronie y utilitarios ==="
sudo dnf install -y cronie
sudo systemctl start crond
sudo systemctl enable crond

echo "=== 2. Instalando MariaDB 10.5 Server ==="
sudo dnf install -y mariadb105-server

echo "=== 3. Iniciando y habilitando el servicio ==="
sudo systemctl start mariadb
sudo systemctl enable mariadb

echo "=== 4. Creando Base de Datos y Usuario Comercial ==="
# Definimos variables para la BD
DB_NAME="db_comercial"
DB_USER="user_web"
DB_PASS="PasswordSeguro123!" # Cambia esto por algo más seguro

# Ejecutamos las consultas SQL de forma segura
sudo mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
sudo mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "=== 5. Verificando la instalación y BD ==="
sudo mysql -e "SHOW DATABASES;"

echo "=== ¡MariaDB y Base de Datos '${DB_NAME}' listos en Server-1! ==="

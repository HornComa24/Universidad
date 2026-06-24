#!/bin/bash
# =========================================================================
# CONFIGURACIÓN DE MARIADB Y CREACIÓN DE BD EN SERVER-1
# =========================================================================

echo "=== 1. Instalando cronie, utilitarios y servidor web Apache ==="
sudo dnf install -y cronie httpd
sudo systemctl start crond
sudo systemctl enable crond
sudo systemctl start httpd
sudo systemctl enable httpd

echo "=== 1.5. Configurando la página web de prueba (Etapa 4) ==="
sudo mkdir -p /var/www/html
sudo tee /var/www/html/index.html << 'EOF'
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Servidor Web - Etapa 4</title><style>
body{font-family:'Segoe UI',sans-serif;background:linear-gradient(135deg,#1e3c72,#2a5298);color:#fff;display:flex;justify-content:center;align-items:center;height:100vh;margin:0}
.card{background:rgba(255,255,255,0.1);backdrop-filter:blur(10px);border-radius:15px;padding:30px;box-shadow:0 8px 32px rgba(0,0,0,0.3);border:1px solid rgba(255,255,255,0.2);text-align:center;max-width:500px;width:90%}
h1{font-size:2.2rem;margin:0 0 10px;text-shadow:2px 2px 4px rgba(0,0,0,0.4)}
p{color:#e0e0e0;font-size:1rem}
.badge{background:#4caf50;padding:6px 12px;border-radius:20px;font-weight:bold;display:inline-block;margin:10px 0;box-shadow:0 4px 15px rgba(76,175,80,0.3)}
.box{margin-top:20px;padding:12px;background:rgba(0,0,0,0.2);border-radius:8px;text-align:left;font-family:monospace;font-size:0.85rem}
</style></head><body><div class="card"><h1>Servidor Web - AWS</h1><p><strong>Server-1 (Web & DB)</strong> en subred pública de la VPC.</p><span class="badge">Etapa 4 &amp; 5 - Completada</span><div class="box">
<div><strong>Servicio:</strong> Apache HTTP (httpd)</div><div><strong>DB Local:</strong> MariaDB 10.5</div><div><strong>OS:</strong> Amazon Linux 2023</div><div><strong>IP Privada:</strong> HOSTNAME_I</div><div><strong>Despliegue:</strong> FECHA_DESPLIEGUE</div>
</div></div><script>document.body.innerHTML=document.body.innerHTML.replace('HOSTNAME_I',window.location.hostname);</script></body></html>
EOF

# Reemplazar la fecha de despliegue estáticamente en el script
sudo sed -i "s/FECHA_DESPLIEGUE/$(date '+%Y-%m-%d %H:%M:%S %Z')/g" /var/www/html/index.html

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

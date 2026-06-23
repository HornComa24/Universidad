#!/bin/bash
# =========================================================================
# SCRIPT DE RESPALDO AUTOMATIZADO MULTI-CLOUD (AWS -> GCP)
# =========================================================================
# Este script se ejecuta en las instancias de AWS y sube los respaldos a GCP.
# =========================================================================

# Asegurar que el PATH incluya las rutas comunes de binarios
export PATH=$PATH:/usr/bin:/usr/local/bin:/usr/sbin:/usr/local/sbin

export GOOGLE_APPLICATION_CREDENTIALS="/opt/scripts/gcp-wif.json"
SQL_FILE="/tmp/backup_db.sql"
ENC_FILE="/tmp/backup_db.sql.enc"

# Autenticar gcloud usando el archivo de credenciales de federación de identidades
if [ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    gcloud auth login --cred-file="$GOOGLE_APPLICATION_CREDENTIALS" --quiet &>/dev/null
fi

echo "[$(date)] Iniciando proceso de backup con Workload Identity Federation..."

# 1. Obtener el nombre del bucket desde AWS SSM Parameter Store
echo "[+] Obteniendo nombre del bucket de GCP desde AWS SSM..."
BUCKET_NAME=$(aws ssm get-parameter --name "/config/gcp/backup-bucket" --query "Parameter.Value" --output text)

if [ -z "$BUCKET_NAME" ] || [ ! -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    echo "[!] Error: No se pudo obtener el bucket desde SSM o falta el archivo WIF."
    exit 1
fi

# 3. Determinar motor de BD instalado, ejecutar dump y realizar cifrado simétrico (AES-256-CBC)
if command -v mysqldump &>/dev/null; then
    echo "[+] Motor detectado: MariaDB. Realizando dump..."
    # Contraseña corregida a 'PasswordSeguro123!' (creada en instalar_mariadb.sh)
    mysqldump -u user_web -p'PasswordSeguro123!' db_comercial > $SQL_FILE
    
    if [ $? -eq 0 ]; then
        echo "[+] Cifrando backup con OpenSSL (AES-256)..."
        openssl enc -aes-256-cbc -salt -pbkdf2 -pass pass:PasswordRespaldo123! -in $SQL_FILE -out $ENC_FILE
        
        echo "[+] Subiendo backup cifrado a GCP Cloud Storage (gs://${BUCKET_NAME})..."
        gcloud storage cp $ENC_FILE gs://${BUCKET_NAME}/backup_mariadb_$(date +%F_%H%M%S).sql.enc
    else
        echo "[!] Error al respaldar MariaDB."
    fi

elif command -v pg_dump &>/dev/null; then
    echo "[+] Motor detectado: PostgreSQL. Realizando dump..."
    # Ejecutar pg_dump como el usuario 'postgres' del sistema para db_backup
    sudo -u postgres pg_dump db_backup > $SQL_FILE
    
    if [ $? -eq 0 ]; then
        echo "[+] Cifrando backup con OpenSSL (AES-256)..."
        openssl enc -aes-256-cbc -salt -pbkdf2 -pass pass:PasswordRespaldo123! -in $SQL_FILE -out $ENC_FILE
        
        echo "[+] Subiendo backup cifrado a GCP Cloud Storage (gs://${BUCKET_NAME})..."
        gcloud storage cp $ENC_FILE gs://${BUCKET_NAME}/backup_postgres_$(date +%F_%H%M%S).sql.enc
    else
        echo "[!] Error al respaldar PostgreSQL."
    fi
else
    echo "[!] No se detectó un motor de base de datos compatible (mysqldump / pg_dump)."
fi

# 4. Limpieza de datos sensibles locales
echo "[+] Limpiando archivos temporales..."
rm -f $SQL_FILE $ENC_FILE
echo "[✓] Proceso de respaldo finalizado con éxito."

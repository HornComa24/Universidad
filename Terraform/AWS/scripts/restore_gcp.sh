#!/bin/bash
# =========================================================================
# SCRIPT DE RESTAURACIÓN AUTOMATIZADA MULTI-CLOUD (GCP -> AWS)
# =========================================================================
# Este script se ejecuta en las instancias de AWS para restaurar la BD desde GCP.
# =========================================================================

# Asegurar que el PATH incluya las rutas comunes de binarios
export PATH=$PATH:/usr/bin:/usr/local/bin:/usr/sbin:/usr/local/sbin

export GOOGLE_APPLICATION_CREDENTIALS="/opt/scripts/gcp-wif.json"
ENC_FILE="/tmp/backup_restore.sql.enc"
SQL_FILE="/tmp/backup_restore.sql"

# Autenticar gcloud usando el archivo de credenciales de federación de identidades
if [ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    gcloud auth login --cred-file="$GOOGLE_APPLICATION_CREDENTIALS" --quiet &>/dev/null
fi

echo "[$(date)] Iniciando proceso de restauración desde GCP..."

# 1. Obtener el nombre del bucket desde AWS SSM Parameter Store
echo "[+] Obteniendo nombre del bucket de GCP desde AWS SSM..."
BUCKET_NAME=$(aws ssm get-parameter --name "/config/gcp/backup-bucket" --query "Parameter.Value" --output text)

if [ -z "$BUCKET_NAME" ] || [ ! -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    echo "[!] Error: No se pudo obtener el bucket desde SSM o falta el archivo WIF."
    exit 1
fi

# 2. Buscar el archivo de respaldo más reciente en el bucket de GCP
echo "[+] Listando respaldos en gs://${BUCKET_NAME}..."
if command -v mysqldump &>/dev/null; then
    PREFIX="backup_mariadb_"
elif [ -n "$(docker ps --filter "name=^data-base$" --filter "status=running" --quiet 2>/dev/null)" ]; then
    PREFIX="backup_postgres_"
elif command -v pg_dump &>/dev/null; then
    PREFIX="backup_postgres_"
else
    echo "[!] Error: No se detectó motor de base de datos compatible ni contenedor 'data-base' en esta instancia."
    exit 1
fi

LATEST_BACKUP=$(gcloud storage ls "gs://${BUCKET_NAME}/${PREFIX}*" 2>/dev/null | sort | tail -n 1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "[!] Error: No se encontró ningún archivo de respaldo con prefijo '${PREFIX}' en el bucket."
    exit 1
fi

echo "[✓] Respaldo más reciente detectado: ${LATEST_BACKUP}"

# 3. Descargar el archivo cifrado desde GCP Cloud Storage
echo "[+] Descargando backup cifrado..."
gcloud storage cp "$LATEST_BACKUP" $ENC_FILE

if [ $? -ne 0 ]; then
    echo "[!] Error al descargar el archivo de respaldo desde GCP."
    exit 1
fi

# 4. Descifrar el backup usando OpenSSL (AES-256-CBC)
echo "[+] Descifrando backup usando OpenSSL (AES-256)..."
openssl enc -d -aes-256-cbc -salt -pbkdf2 -pass pass:PasswordRespaldo123! -in $ENC_FILE -out $SQL_FILE

if [ $? -ne 0 ] || [ ! -f "$SQL_FILE" ]; then
    echo "[!] Error al descifrar el archivo de respaldo. Verifique la contraseña."
    rm -f $ENC_FILE
    exit 1
fi

# 5. Importar los datos según el motor de base de datos instalado
if command -v mysql &>/dev/null; then
    echo "[+] Motor detectado: MariaDB. Importando base de datos 'db_comercial'..."
    mysql -u user_web -p'PasswordSeguro123!' db_comercial < $SQL_FILE
    
    if [ $? -eq 0 ]; then
        echo "[✓] ¡Base de datos MariaDB restaurada con éxito!"
    else
        echo "[!] Error al importar los datos en MariaDB."
    fi

elif [ -n "$(docker ps --filter "name=^data-base$" --filter "status=running" --quiet 2>/dev/null)" ]; then
    echo "[+] Contenedor detectado: PostgreSQL en Docker (data-base). Importando base de datos 'gestion_academica'..."
    docker exec -i data-base psql -U postgres -d gestion_academica < $SQL_FILE
    
    if [ $? -eq 0 ]; then
        echo "[✓] ¡Base de datos PostgreSQL en Docker restaurada con éxito!"
    else
        echo "[!] Error al importar los datos en PostgreSQL de Docker."
    fi

elif command -v psql &>/dev/null; then
    echo "[+] Motor detectado: PostgreSQL nativo. Importando base de datos 'db_backup'..."
    sudo -u postgres psql -d db_backup < $SQL_FILE
    
    if [ $? -eq 0 ]; then
        echo "[✓] ¡Base de datos PostgreSQL nativa restaurada con éxito!"
    else
        echo "[!] Error al importar los datos en PostgreSQL nativa."
    fi
fi

# 6. Limpieza de seguridad
echo "[+] Limpiando archivos temporales decifrados..."
rm -f $ENC_FILE $SQL_FILE
echo "[✓] Proceso de restauración finalizado."

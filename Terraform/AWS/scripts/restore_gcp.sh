#!/bin/bash
# =========================================================================
# SCRIPT DE RESTAURACIÓN MULTI-CLOUD OPTIMIZADO (GCP -> AWS)
# Compatibilidad: MariaDB local, PostgreSQL local, PostgreSQL en Docker (data-base)
# =========================================================================
export PATH=$PATH:/usr/bin:/usr/local/bin:/usr/sbin:/usr/local/sbin
export GOOGLE_APPLICATION_CREDENTIALS="/opt/scripts/gcp-wif.json"
ENC_FILE="/tmp/backup_restore.sql.enc"
SQL_FILE="/tmp/backup_restore.sql"

# Autenticar gcloud
if [ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    gcloud auth login --cred-file="$GOOGLE_APPLICATION_CREDENTIALS" --quiet &>/dev/null
fi

echo "[$(date)] Iniciando restauración desde GCP..."

# 1. Obtener nombre del bucket desde SSM
BUCKET_NAME=$(aws ssm get-parameter --name "/config/gcp/backup-bucket" --query "Parameter.Value" --output text)

if [ -z "$BUCKET_NAME" ] || [ ! -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    echo "[!] Error: Falta bucket SSM o archivo de credenciales WIF."
    exit 1
fi

# 2. Detectar prefijo según motor o contenedor activo
if command -v mysqldump &>/dev/null; then
    PREFIX="backup_mariadb_"
elif [ -n "$(docker ps --filter "name=^data-base$" --filter "status=running" --quiet 2>/dev/null)" ]; then
    PREFIX="backup_postgres_"
elif command -v pg_dump &>/dev/null; then
    PREFIX="backup_postgres_"
else
    echo "[!] Error: No se detectó motor compatible ni contenedor 'data-base'."
    exit 1
fi

# 3. Buscar respaldo más reciente
echo "[+] Buscando respaldos en gs://${BUCKET_NAME}..."
LATEST_BACKUP=$(gcloud storage ls "gs://${BUCKET_NAME}/${PREFIX}*" 2>/dev/null | sort | tail -n 1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "[!] Error: No se encontró ningún respaldo con prefijo '${PREFIX}'."
    exit 1
fi

echo "[✓] Respaldo detectado: ${LATEST_BACKUP}"

# 4. Descargar y descifrar (AES-256-CBC)
gcloud storage cp "$LATEST_BACKUP" $ENC_FILE
if [ $? -ne 0 ]; then
    echo "[!] Error al descargar el archivo."
    exit 1
fi

echo "[+] Descifrando respaldo..."
openssl enc -d -aes-256-cbc -salt -pbkdf2 -pass pass:PasswordRespaldo123! -in $ENC_FILE -out $SQL_FILE

if [ $? -ne 0 ] || [ ! -f "$SQL_FILE" ]; then
    echo "[!] Error al descifrar el archivo. Contraseña incorrecta."
    rm -f $ENC_FILE
    exit 1
fi

# 5. Importar datos según entorno
if command -v mysql &>/dev/null; then
    echo "[+] Importando datos en MariaDB..."
    mysql -u user_web -p'PasswordSeguro123!' db_comercial < $SQL_FILE
    if [ $? -eq 0 ]; then echo "[✓] MariaDB restaurada con éxito!"; else echo "[!] Falló importación en MariaDB."; fi

elif [ -n "$(docker ps --filter "name=^data-base$" --filter "status=running" --quiet 2>/dev/null)" ]; then
    echo "[+] Importando datos en PostgreSQL de Docker (data-base)..."
    docker exec -i -e PGPASSWORD=instituto_secreto_2026 data-base psql -U postgres -d gestion_academica < $SQL_FILE
    if [ $? -eq 0 ]; then echo "[✓] PostgreSQL en Docker restaurada con éxito!"; else echo "[!] Falló importación en Docker."; fi

elif command -v psql &>/dev/null; then
    echo "[+] Importando datos en PostgreSQL nativa..."
    sudo -u postgres psql -d db_backup < $SQL_FILE
    if [ $? -eq 0 ]; then echo "[✓] PostgreSQL nativa restaurada con éxito!"; else echo "[!] Falló importación en Postgres nativa."; fi
fi

# 6. Limpieza final de seguridad
rm -f $ENC_FILE $SQL_FILE
echo "[✓] Proceso finalizado."

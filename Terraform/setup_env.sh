#!/bin/bash
# =========================================================================
# SCRIPT DE CONFIGURACIÓN DE ENTORNO - setup_env.sh
# =========================================================================
# Este script verifica y configura los prerrequisitos locales para
# el despliegue de la infraestructura multi-cloud (AWS + GCP).

# Colores para la terminal
VERDE='\033[0;32m'
ROJO='\033[0;31m'
AZUL='\033[0;34m'
AMARILLO='\033[0;33m'
NC='\033[0m' # Sin color

echo -e "${AZUL}=== Iniciando Configuración de Entorno Local ===${NC}"

# -------------------------------------------------------------------------
# 1. VERIFICACIÓN DE LLAVES SSH
# -------------------------------------------------------------------------
echo -e "\n${AZUL}[+] Verificando llaves SSH en ~/.ssh/...${NC}"
SSH_DIR="$HOME/.ssh"

# Crear directorio .ssh si no existe
if [ ! -d "$SSH_DIR" ]; then
    echo -e "${AMARILLO}[i] Directorio $SSH_DIR no existe. Creándolo...${NC}"
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
fi

# Buscar llaves públicas
PUB_KEYS=$(find "$SSH_DIR" -maxdepth 1 -name "*.pub" 2>/dev/null)

if [ -z "$PUB_KEYS" ]; then
    echo -e "${AMARILLO}[!] No se encontraron llaves públicas (.pub) en $SSH_DIR.${NC}"
    echo -e "${AZUL}[+] Generando un nuevo par de llaves SSH (ED25519)...${NC}"
    
    # Generar llave ed25519 sin contraseña de forma no interactiva
    ssh-keygen -t ed25519 -N "" -f "$SSH_DIR/id_ed25519"
    
    if [ $? -eq 0 ]; then
        echo -e "${VERDE}[✓] Llave SSH creada con éxito en $SSH_DIR/id_ed25519.pub${NC}"
    else
        echo -e "${ROJO}[!] ERROR: No se pudo generar la llave SSH. Por favor, créela manualmente.${NC}"
        exit 1
    fi
else
    echo -e "${VERDE}[✓] Llaves SSH existentes detectadas:${NC}"
    echo "$PUB_KEYS" | while read -r key; do
        echo -e "    - $(basename "$key")"
    done
fi

# -------------------------------------------------------------------------
# 2. VERIFICACIÓN DE BINARIOS REQUERIDOS
# -------------------------------------------------------------------------
echo -e "\n${AZUL}[+] Verificando herramientas CLI requeridas...${NC}"

check_binary() {
    local name=$1
    local install_msg=$2
    if command -v "$name" &>/dev/null; then
        echo -e "${VERDE}[✓] $name está instalado. (${NC}$($name --version | head -n 1)${VERDE})${NC}"
    else
        echo -e "${ROJO}[!] $name NO está instalado.${NC}"
        echo -e "${AMARILLO}    -> Instrucciones: $install_msg${NC}"
    fi
}

check_binary "terraform" "Descargar desde https://www.terraform.io/downloads.html"
check_binary "aws" "Instalar AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)"
check_binary "gcloud" "Instalar Google Cloud SDK (https://cloud.google.com/sdk/docs/install)"

# -------------------------------------------------------------------------
# 3. ASEGURAR PERMISOS DE EJECUCIÓN
# -------------------------------------------------------------------------
echo -e "\n${AZUL}[+] Asegurando permisos de ejecución en los scripts de despliegue...${NC}"
chmod +x AWS/desplegar.sh 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${VERDE}[✓] AWS/desplegar.sh ahora es ejecutable.${NC}"
else
    echo -e "${AMARILLO}[!] Advertencia: No se pudo modificar permisos de AWS/desplegar.sh (¿existe el archivo?)${NC}"
fi

echo -e "\n${VERDE}=== Configuración de entorno finalizada con éxito ===${NC}"
echo -e "${AMARILLO}Próximos pasos recomendados:${NC}"
echo -e "1. Ejecutar: ${AZUL}gcloud auth application-default login${NC} (Para autenticar GCP)"
echo -e "2. Ejecutar: ${AZUL}aws configure${NC} (Para configurar credenciales de AWS)"
echo -e "3. Desplegar GCP: ${AZUL}cd GCP && terraform init && terraform apply${NC}"
echo -e "4. Desplegar AWS: ${AZUL}cd ../AWS && ./desplegar.sh${NC}"

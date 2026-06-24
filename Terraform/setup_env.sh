#!/bin/bash
# =========================================================================
# SCRIPT DE CONFIGURACIÓN DE ENFORNO - setup_env.sh
# =========================================================================
# Este script verifica y configura los prerrequisitos locales para
# el despliegue de la infraestructura multi-cloud (AWS + GCP), e instala
# automáticamente Docker en sistemas Linux compatibles.

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
# 2. INSTALACIÓN / VERIFICACIÓN DE DOCKER
# -------------------------------------------------------------------------
echo -e "\n${AZUL}[+] Verificando estado de Docker...${NC}"

if command -v docker &>/dev/null; then
    echo -e "${VERDE}[✓] Docker está instalado. (${NC}$(docker --version)${VERDE})${NC}"
else
    echo -e "${AMARILLO}[!] Docker NO está instalado en este sistema.${NC}"
    
    # Detectar Sistema Operativo
    OS_TYPE=$(uname -s | tr '[:upper:]' '[:lower:]')
    
    if [ "$OS_TYPE" = "linux" ]; then
        echo -e "${AZUL}[+] Detectado sistema operativo Linux. Intentando instalar Docker automáticamente...${NC}"
        
        # Detectar Gestor de Paquetes
        if command -v apt-get &>/dev/null; then
            echo -e "${AZUL}[+] Instalando Docker vía APT (Debian/Ubuntu)...${NC}"
            sudo apt-get update && sudo apt-get install -y docker.io docker-compose
        elif command -v dnf &>/dev/null; then
            echo -e "${AZUL}[+] Instalando Docker vía DNF (RHEL/Fedora/Amazon Linux)...${NC}"
            sudo dnf install -y docker
        elif command -v yum &>/dev/null; then
            echo -e "${AZUL}[+] Instalando Docker vía YUM (CentOS)...${NC}"
            sudo yum install -y docker
        else
            echo -e "${ROJO}[!] No se reconoció un gestor de paquetes soportado para instalación automática.${NC}"
            echo -e "${AMARILLO}Por favor, instale Docker manualmente para su distribución de Linux.${NC}"
        fi
        
        # Habilitar e iniciar servicio Docker en Linux si se instaló
        if command -v docker &>/dev/null; then
            echo -e "${AZUL}[+] Iniciando y habilitando servicio Docker...${NC}"
            sudo systemctl enable --now docker 2>/dev/null
            
            # Agregar usuario al grupo docker para evitar usar sudo siempre
            echo -e "${AZUL}[+] Agregando usuario $USER al grupo 'docker' (requiere reiniciar sesión)...${NC}"
            sudo usermod -aG docker "$USER" 2>/dev/null
            echo -e "${VERDE}[✓] Docker instalado e iniciado correctamente.${NC}"
        fi
        
    elif [[ "$OS_TYPE" == *"mingw"* || "$OS_TYPE" == *"cygwin"* || "$OS_TYPE" == *"msys"* ]]; then
        echo -e "${AMARILLO}[!] Detectado entorno Windows (Git Bash/WSL).${NC}"
        echo -e "    -> Por favor, instale Docker Desktop desde: ${AZUL}https://www.docker.com/products/docker-desktop/${NC}"
    elif [ "$OS_TYPE" = "darwin" ]; then
        echo -e "${AMARILLO}[!] Detectado macOS.${NC}"
        echo -e "    -> Por favor, instale Docker Desktop o use Homebrew: ${AZUL}brew install --cask docker${NC}"
    else
        echo -e "${ROJO}[!] Sistema operativo no identificado de forma automática.${NC}"
        echo -e "    -> Por favor, instale Docker de forma manual desde el sitio oficial de Docker.${NC}"
    fi
fi

# -------------------------------------------------------------------------
# 3. VERIFICACIÓN DE OTRAS HERRAMIENTAS CLI REQUERIDAS
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
# 4. ASEGURAR PERMISOS DE EJECUCIÓN
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
echo -e "1. ${AMARILLO}(Si se instaló Docker recién en Linux)${NC} Reinicie sesión para aplicar permisos de Docker sin sudo."
echo -e "2. Ejecutar: ${AZUL}gcloud auth application-default login${NC} (Para autenticar GCP)"
echo -e "3. Ejecutar: ${AZUL}aws configure${NC} (Para configurar credenciales de AWS)"
echo -e "4. Desplegar GCP: ${AZUL}cd GCP && terraform init && terraform apply${NC}"
echo -e "5. Desplegar AWS: ${AZUL}cd ../AWS && ./desplegar.sh${NC}"

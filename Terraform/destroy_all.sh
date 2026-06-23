#!/bin/bash
# =========================================================================
# SCRIPT DE DESTRUCCIÓN Y LIMPIEZA AUTOMATIZADA - destroy_all.sh
# =========================================================================
# Este script destruye la infraestructura en AWS y GCP en el orden correcto,
# y luego elimina todos los archivos locales de estado y caché (.terraform, etc).

# Colores para la terminal
VERDE='\033[0;32m'
ROJO='\033[0;31m'
AZUL='\033[0;34m'
AMARILLO='\033[0;33m'
NC='\033[0m' # Sin color

echo -e "${AZUL}=== Iniciando Proceso de Destrucción Completa ===${NC}"

# 1. Destruir AWS primero (para evitar bloqueos de dependencias)
echo -e "\n${AZUL}[+] 1. Destruyendo infraestructura de AWS...${NC}"
if [ -d "AWS" ]; then
    terraform -chdir=AWS destroy -auto-approve
    if [ $? -eq 0 ]; then
        echo -e "${VERDE}[✓] Infraestructura de AWS destruida con éxito.${NC}"
    else
        echo -e "${AMARILLO}[!] Advertencia: Hubo problemas al destruir AWS o no había recursos activos.${NC}"
    fi
else
    echo -e "${ROJO}[!] ERROR: Directorio AWS no encontrado.${NC}"
fi

# 2. Destruir GCP segundo
echo -e "\n${AZUL}[+] 2. Destruyendo infraestructura de GCP...${NC}"
if [ -d "GCP" ]; then
    terraform -chdir=GCP destroy -auto-approve
    if [ $? -eq 0 ]; then
        echo -e "${VERDE}[✓] Infraestructura de GCP destruida con éxito.${NC}"
    else
        echo -e "${AMARILLO}[!] Advertencia: Hubo problemas al destruir GCP o no había recursos activos.${NC}"
    fi
else
    echo -e "${ROJO}[!] ERROR: Directorio GCP no encontrado.${NC}"
fi

# 3. Limpieza local de caché y estados de Terraform
echo -e "\n${AZUL}[+] 3. Limpiando archivos locales de estado, respaldos y caché de Terraform...${NC}"

# Carpetas y archivos a eliminar
rm -rf AWS/.terraform AWS/.terraform.lock.hcl AWS/terraform.tfstate AWS/terraform.tfstate.backup 2>/dev/null
rm -rf GCP/.terraform GCP/.terraform.lock.hcl GCP/terraform.tfstate GCP/terraform.tfstate.backup 2>/dev/null

echo -e "${VERDE}[✓] Archivos locales de estado (.tfstate, .terraform, lock files) eliminados.${NC}"

echo -e "\n${VERDE}=== Destrucción y Limpieza Finalizada con Éxito ===${NC}"

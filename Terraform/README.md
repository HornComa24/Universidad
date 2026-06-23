# 🌐 Arquitectura Multi-Cloud Híbrida (AWS + GCP) con Terraform

Este repositorio contiene la definición de Infraestructura como Código (IaC) para desplegar un entorno híbrido y multi-cloud altamente seguro y automatizado. Utiliza **AWS** como entorno de ejecución principal de las bases de datos (MariaDB y PostgreSQL) y **GCP** (Google Cloud Storage) como bóveda de respaldo georedundante para recuperación ante desastres (DR) utilizando **Workload Identity Federation (WIF)** libre de llaves estáticas.

---

## 🔒 Beneficios Clave de la Arquitectura
* **Cero Llaves Estáticas:** Autenticación dinámica por tokens temporales e IMDSv2 de AWS.
* **Cifrado AES-256 local:** Encriptación de bases de datos antes de salir de la VPC de AWS.
* **Multi-tenancy Real:** Despliegue personalizable mediante archivos `.tfvars` de manera aislada.

---

## 💻 Guías de Despliegue por Sistema Operativo

Seleccione el apartado correspondiente a su sistema operativo para preparar su entorno local:

---

### 1. 💻 GUÍA DE DESPLIEGUE EN WINDOWS

Para desplegar este proyecto en Windows de manera limpia y sin fricción, se recomienda el uso de **Git Bash** para poder ejecutar los scripts de automatización nativamente.

#### A. Instalación de Herramientas (CLIs)
Abra PowerShell como Administrador e instale los prerrequisitos usando el gestor oficial de Windows **Winget**:
```powershell
# Instalar Terraform
winget install HashiCorp.Terraform

# Instalar AWS CLI
winget install Amazon.AWSCLI

# Instalar Google Cloud SDK (gcloud)
winget install Google.CloudSDK

# Instalar Git (incluye Git Bash para correr scripts)
winget install Git.Git
```
*(Alternativamente, puede descargar los instaladores oficiales `.msi` o `.exe` de cada herramienta).*

#### B. Generación de Llaves SSH
Abra la terminal de **Git Bash** y ejecute el inicializador del entorno:
```bash
./setup_env.sh
```
*Este script detectará su directorio `C:\Users\SU_USUARIO\.ssh\` y creará una llave segura ED25519 si no tiene una existente.*

#### C. Autenticación de Cuentas
En su terminal de **Git Bash**, ejecute:
```bash
# Autenticar AWS
aws configure

# Autenticar GCP (Abrirá el navegador web para iniciar sesión)
gcloud auth application-default login
```

#### D. Despliegue de la Infraestructura
```bash
# 1. Configurar y desplegar GCP
cd GCP/
# (Edite el archivo terraform.tfvars con su ID de proyecto de GCP y ID de cuenta de AWS)
terraform init
terraform apply -auto-approve

# 2. Desplegar AWS con integración de WIF automática
cd ../AWS/
./desplegar.sh
```

---

### 2. 🐧 GUÍA DE DESPLIEGUE EN LINUX

La infraestructura es nativa de Linux, por lo que todo el flujo se ejecuta de manera directa desde su terminal favorita.

#### A. Instalación de Herramientas (CLIs)
Dependiendo de su distribución, ejecute los siguientes comandos:

##### **Debian / Ubuntu / Pop!_OS:**
```bash
# Instalar Terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform

# Instalar AWS CLI
sudo apt-get install -y awscli

# Instalar Google Cloud CLI
sudo apt-get install -y apt-transport-https ca-certificates gnupg curl
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update && sudo apt-get install -y google-cloud-cli
```

##### **RedHat / Fedora / AlmaLinux:**
```bash
# Instalar Terraform
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf install -y terraform

# Instalar AWS CLI
sudo dnf install -y awscli

# Instalar Google Cloud CLI
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << 'EOM'
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key-v10.gpg
EOM
sudo dnf install -y google-cloud-cli
```

#### B. Generación de Llaves SSH
```bash
./setup_env.sh
```

#### C. Autenticación de Cuentas
```bash
# Autenticar AWS
aws configure

# Autenticar GCP
gcloud auth application-default login
```

#### D. Despliegue de la Infraestructura
```bash
# 1. Desplegar GCP
cd GCP/
# (Edite el archivo terraform.tfvars con su project_id y aws_account_id)
terraform init
terraform apply -auto-approve

# 2. Desplegar AWS
cd ../AWS/
./desplegar.sh
```

---

### 3. 🍎 GUÍA DE DESPLIEGUE EN macOS

En macOS, el uso de **Homebrew** simplifica significativamente la instalación y gestión de todas las herramientas.

#### A. Instalación de Herramientas (CLIs)
Abra la terminal e instale Homebrew si no lo tiene. Luego ejecute:
```bash
# Agregar el repositorio de Hashicorp e instalar Terraform
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Instalar AWS CLI
brew install awscli

# Instalar Google Cloud CLI
brew install --cask google-cloud-sdk
```

#### B. Generación de Llaves SSH
```bash
./setup_env.sh
```
*El script generará una llave ED25519 en su directorio nativo de macOS `~/.ssh/` si no se encuentra ninguna.*

#### C. Autenticación de Cuentas
```bash
# Autenticar AWS
aws configure

# Autenticar GCP
gcloud auth application-default login
```

#### D. Despliegue de la Infraestructura
```bash
# 1. Desplegar GCP
cd GCP/
# (Edite el archivo terraform.tfvars con sus parámetros dinámicos)
terraform init
terraform apply -auto-approve

# 2. Desplegar AWS
cd ../AWS/
./desplegar.sh
```

---

## 🧪 Verificación de Funcionamiento de Backups

Una vez finalizado el despliegue de AWS en cualquier plataforma, ingrese mediante SSH a cualquiera de sus instancias utilizando su llave privada:
```bash
ssh -i ~/.ssh/id_ed25519 ec2-user@IP_PUBLICA_DEL_SERVIDOR
```
Y ejecute el script de respaldo para confirmar el flujo OIDC:
```bash
sudo /opt/scripts/backup_gcp.sh
```
*Verifique la presencia de los respaldos encriptados en su consola web de GCP o localmente usando `gcloud storage ls gs://NOMBRE_DE_TU_BUCKET`.*

---

## 🧹 Limpieza y Destrucción Automatizada (Evitar Facturación)

Cuando termine de validar su laboratorio, puede destruir toda la infraestructura en la nube en el orden correcto y limpiar todos los archivos locales de caché (`.terraform`, `.tfstate`, etc.) ejecutando el script unificado de destrucción en la raíz del proyecto (desde Linux, macOS o Git Bash en Windows):

```bash
./destroy_all.sh
```

*Este script se encargará automáticamente de:*
1. *Destruir la infraestructura de AWS.*
2. *Destruir la infraestructura de GCP.*
3. *Eliminar toda la caché de Terraform, estados locales (`.tfstate`) y archivos de bloqueo para dejar la carpeta completamente limpia.*


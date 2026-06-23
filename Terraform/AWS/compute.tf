locals {
  # Agregamos tolist() para convertir el set de archivos en una lista que element() pueda leer
  ruta_final_llave = var.ruta_clave_publica != "" ? pathexpand(var.ruta_clave_publica) : "${pathexpand("~/.ssh")}/${element(tolist(fileset(pathexpand("~/.ssh"), "*.pub")), 0)}"

  # Scripts de aprovisionamiento en formato Base64 para evitar problemas de interpolación y copia cíclica
  user_data_mariadb = <<-EOF
#!/bin/bash
# 0. Configurar Swap de 1.5GB para evitar OOM (Out Of Memory)
sudo fallocate -l 1.5G /swapfile || sudo dd if=/dev/zero of=/swapfile bs=1M count=1536
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab

# 1. Instalar Google Cloud CLI para gsutil y gcloud
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << 'EOM'
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key-v10.gpg
EOM
if command -v dnf &>/dev/null; then
  sudo dnf install -y google-cloud-cli
else
  sudo yum install -y google-cloud-cli
fi

# 2. Desempaquetar y ejecutar script de base de datos (MariaDB)
echo "${base64encode(file("${path.module}/scripts/instalar_mariadb.sh"))}" | base64 -d > /tmp/instalar_mariadb.sh
chmod +x /tmp/instalar_mariadb.sh
bash /tmp/instalar_mariadb.sh

# 3. Desempaquetar y ejecutar script de población de datos
echo "${base64encode(file("${path.module}/scripts/poblar_datos.sh"))}" | base64 -d > /tmp/poblar_datos.sh
chmod +x /tmp/poblar_datos.sh
bash /tmp/poblar_datos.sh

# 4. Desempaquetar script de backup de GCP directamente a /opt/scripts
mkdir -p /opt/scripts
echo "${base64encode(file("${path.module}/scripts/backup_gcp.sh"))}" | base64 -d > /opt/scripts/backup_gcp.sh
chmod +x /opt/scripts/backup_gcp.sh

# 4. Generar la configuración de credenciales para Workload Identity Federation (WIF) compatible con IMDSv2
gcloud iam workload-identity-pools create-cred-config \
  "projects/${var.gcp_project_number}/locations/global/workloadIdentityPools/${var.gcp_pool_id}/providers/${var.gcp_provider_id}" \
  --service-account="${var.gcp_sa_email}" \
  --aws \
  --enable-imdsv2 \
  --output-file=/opt/scripts/gcp-wif.json

# 5. Programar en el crontab para ejecutarse cada 15 minutos
(crontab -l 2>/dev/null | grep -v 'backup_gcp.sh'; echo '*/15 * * * * /opt/scripts/backup_gcp.sh') | crontab -
EOF

  user_data_postgres = <<-EOF
#!/bin/bash
# 0. Configurar Swap de 1.5GB para evitar OOM (Out Of Memory)
sudo fallocate -l 1.5G /swapfile || sudo dd if=/dev/zero of=/swapfile bs=1M count=1536
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab

# 1. Instalar Google Cloud CLI para gsutil y gcloud
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << 'EOM'
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key-v10.gpg
EOM
if command -v dnf &>/dev/null; then
  sudo dnf install -y google-cloud-cli
else
  sudo yum install -y google-cloud-cli
fi

# 2. Desempaquetar y ejecutar script de base de datos (PostgreSQL)
echo "${base64encode(file("${path.module}/scripts/instalar_postgresql.sh"))}" | base64 -d > /tmp/instalar_postgresql.sh
chmod +x /tmp/instalar_postgresql.sh
bash /tmp/instalar_postgresql.sh

# 3. Desempaquetar y ejecutar script de población de datos
echo "${base64encode(file("${path.module}/scripts/poblar_datos.sh"))}" | base64 -d > /tmp/poblar_datos.sh
chmod +x /tmp/poblar_datos.sh
bash /tmp/poblar_datos.sh

# 4. Desempaquetar script de backup de GCP directamente a /opt/scripts
mkdir -p /opt/scripts
echo "${base64encode(file("${path.module}/scripts/backup_gcp.sh"))}" | base64 -d > /opt/scripts/backup_gcp.sh
chmod +x /opt/scripts/backup_gcp.sh

# 4. Generar la configuración de credenciales para Workload Identity Federation (WIF) compatible con IMDSv2
gcloud iam workload-identity-pools create-cred-config \
  "projects/${var.gcp_project_number}/locations/global/workloadIdentityPools/${var.gcp_pool_id}/providers/${var.gcp_provider_id}" \
  --service-account="${var.gcp_sa_email}" \
  --aws \
  --enable-imdsv2 \
  --output-file=/opt/scripts/gcp-wif.json

# 5. Programar en el crontab para ejecutarse cada 15 minutos
(crontab -l 2>/dev/null | grep -v 'backup_gcp.sh'; echo '*/15 * * * * /opt/scripts/backup_gcp.sh') | crontab -
EOF
}

# Crear la llave SSH en AWS dinámicamente usando la clave pública del usuario
resource "aws_key_pair" "deployer" {
  key_name   = "key-proyecto-compartido"
  public_key = file(local.ruta_final_llave)
}

# Busca automáticamente la AMI de Amazon Linux 2023
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# 2. Definición de las instancias/VM de AWS
resource "aws_instance" "vm_aws" {
  count         = 2
  subnet_id     = aws_subnet.mis_subredes[count.index].id
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  # Habilitar almacenamiento optimizado para EBS y configurar volumen raíz cifrado
  ebs_optimized = true
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    encrypted             = true
    delete_on_termination = true
  }

  iam_instance_profile = aws_iam_instance_profile.backup_profile.name

  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.sg_web.id]

  user_data                   = count.index == 0 ? local.user_data_mariadb : local.user_data_postgres
  user_data_replace_on_change = true

  tags = {
    Name = "Server-${count.index + 1}"
  }
}

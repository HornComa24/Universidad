locals {
  # Agregamos tolist() para convertir el set de archivos en una lista que element() pueda leer
  ruta_final_llave = var.ruta_clave_publica != "" ? pathexpand(var.ruta_clave_publica) : "${pathexpand("~/.ssh")}/${element(tolist(fileset(pathexpand("~/.ssh"), "*.pub")), 0)}"

  # =========================================================================
  # SCRIPT DE ARRANQUE PARA SERVER-1 (WEB & API - DOCKER)
  # =========================================================================
  user_data_web = <<-EOF
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
  sudo dnf install -y google-cloud-cli unzip
else
  sudo yum install -y google-cloud-cli unzip
fi

# 2. Instalar Docker y habilitar el servicio
sudo dnf install -y docker || sudo yum install -y docker
sudo systemctl enable --now docker
sudo usermod -aG docker ec2-user

# 3. Instalar Docker Compose v2 de forma robusta y oficial
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-linux-x86_64" -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
sudo ln -s /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

# 4. Descargar el empaquetado zip de la aplicación de S3 y descomprimirlo
sudo mkdir -p /opt/academic-management
aws s3 cp s3://${aws_s3_bucket.storage_principal.id}/docker_app.zip /tmp/docker_app.zip
sudo unzip -o /tmp/docker_app.zip -d /opt/academic-management

# 5. Configurar dinámicamente la IP privada de Server-2 como host de base de datos
sudo sed -i 's/DB_HOST=data-base/DB_HOST=${aws_instance.vm_db.private_ip}/g' /opt/academic-management/docker-compose.yml

# 6. Levantar la aplicación frontend (app) y backend (api) mediante Docker Compose
cd /opt/academic-management
sudo docker compose up -d app api --build

# 7. Descargar scripts de backup y restauración desde AWS SSM directamente a /opt/scripts
sudo mkdir -p /opt/scripts
aws ssm get-parameter --name "/scripts/backup_gcp" --query "Parameter.Value" --output text > /opt/scripts/backup_gcp.sh
aws ssm get-parameter --name "/scripts/restore_gcp" --query "Parameter.Value" --output text > /opt/scripts/restore_gcp.sh
sudo chmod +x /opt/scripts/backup_gcp.sh /opt/scripts/restore_gcp.sh

# 8. Generar la configuración de credenciales para Workload Identity Federation (WIF) compatible con IMDSv2
sudo gcloud iam workload-identity-pools create-cred-config \
  "projects/${var.gcp_project_number}/locations/global/workloadIdentityPools/${var.gcp_pool_id}/providers/${var.gcp_provider_id}" \
  --service-account="${var.gcp_sa_email}" \
  --aws \
  --enable-imdsv2 \
  --output-file=/opt/scripts/gcp-wif.json

# 9. Instalar y configurar el agente de AWS CloudWatch
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOM'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/backup_gcp.log",
            "log_group_name": "/aws/ec2/backup_gcp.log",
            "log_stream_name": "{instance_id}",
            "retention_in_days": 7
          }
        ]
      }
    }
  }
}
EOM

sudo dnf install -y amazon-cloudwatch-agent || sudo yum install -y amazon-cloudwatch-agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
EOF


  # =========================================================================
  # SCRIPT DE ARRANQUE PARA SERVER-2 (DATABASE - DOCKER)
  # =========================================================================
  user_data_db = <<-EOF
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
  sudo dnf install -y google-cloud-cli unzip
else
  sudo yum install -y google-cloud-cli unzip
fi

# 2. Instalar Docker y habilitar el servicio
sudo dnf install -y docker || sudo yum install -y docker
sudo systemctl enable --now docker
sudo usermod -aG docker ec2-user

# 3. Instalar Docker Compose v2 de forma robusta y oficial
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-linux-x86_64" -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
sudo ln -s /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

# 4. Descargar el empaquetado zip de la aplicación de S3 y descomprimirlo
sudo mkdir -p /opt/academic-management
aws s3 cp s3://${aws_s3_bucket.storage_principal.id}/docker_app.zip /tmp/docker_app.zip
sudo unzip -o /tmp/docker_app.zip -d /opt/academic-management

# 5. Levantar únicamente el contenedor de PostgreSQL (data) mediante Docker Compose
cd /opt/academic-management
sudo docker compose up -d data --build

# 6. Descargar scripts de backup y restauración desde AWS SSM directamente a /opt/scripts
sudo mkdir -p /opt/scripts
aws ssm get-parameter --name "/scripts/backup_gcp" --query "Parameter.Value" --output text > /opt/scripts/backup_gcp.sh
aws ssm get-parameter --name "/scripts/restore_gcp" --query "Parameter.Value" --output text > /opt/scripts/restore_gcp.sh
sudo chmod +x /opt/scripts/backup_gcp.sh /opt/scripts/restore_gcp.sh

# 7. Generar la configuración de credenciales para Workload Identity Federation (WIF) compatible con IMDSv2
sudo gcloud iam workload-identity-pools create-cred-config \
  "projects/${var.gcp_project_number}/locations/global/workloadIdentityPools/${var.gcp_pool_id}/providers/${var.gcp_provider_id}" \
  --service-account="${var.gcp_sa_email}" \
  --aws \
  --enable-imdsv2 \
  --output-file=/opt/scripts/gcp-wif.json

# 8. Instalar y configurar el agente de AWS CloudWatch
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOM'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/backup_gcp.log",
            "log_group_name": "/aws/ec2/backup_gcp.log",
            "log_stream_name": "{instance_id}",
            "retention_in_days": 7
          }
        ]
      }
    }
  }
}
EOM

sudo dnf install -y amazon-cloudwatch-agent || sudo yum install -y amazon-cloudwatch-agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# 9. Programar en el crontab para ejecutarse cada 15 minutos redireccionando logs
sudo touch /var/log/backup_gcp.log
sudo chmod 666 /var/log/backup_gcp.log
(crontab -l 2>/dev/null | grep -v 'backup_gcp.sh'; echo '*/15 * * * * /opt/scripts/backup_gcp.sh >> /var/log/backup_gcp.log 2>&1') | crontab -
EOF
}

# =========================================================================
# RECURSOS DE INFRAESTRUCTURA DE CÓMPUTO (AWS)
# =========================================================================

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

# 1. Server-2 (VM Privada de Base de Datos)
# Nota: La creamos primero para que Server-1 pueda conocer e inyectar su IP privada
resource "aws_instance" "vm_db" {
  subnet_id     = aws_subnet.mis_subredes[1].id # Subred Privada
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  ebs_optimized = true
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    encrypted             = true
    delete_on_termination = true
  }

  iam_instance_profile = aws_iam_instance_profile.backup_profile.name

  associate_public_ip_address = false
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.sg_db.id]

  user_data                   = local.user_data_db
  user_data_replace_on_change = true

  tags = {
    Name = "Server-2"
  }
}

# 2. Server-1 (VM Pública Web)
resource "aws_instance" "vm_web" {
  subnet_id     = aws_subnet.mis_subredes[0].id # Subred Pública
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

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

  user_data                   = local.user_data_web
  user_data_replace_on_change = true

  tags = {
    Name = "Server-1"
  }

  # Asegura que Server-2 esté listo antes de que Server-1 intente desplegarse para conocer su IP privada
  depends_on = [aws_instance.vm_db]
}

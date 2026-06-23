# =========================================================================
# CONFIGURACIÓN DE VARIABLES PARA AWS
# =========================================================================
# Reemplace los valores a continuación con los de su propio entorno.

# 1. Región de AWS donde se desplegarán todos los recursos
aws_region = "us-east-1"

# 2. Zonas de disponibilidad para la VPC y subredes
zonas = ["us-east-1a", "us-east-1b"]

# 3. CIDR de origen permitido para SSH (por defecto 'detect' busca su IP pública automáticamente)
ssh_allowed_cidr = "detect"



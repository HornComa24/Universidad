# =========================================================================
# CONFIGURACIÓN DE MONITOREO Y ALERTAS CON CLOUDWATCH
# =========================================================================

# 1. Grupo de Logs centralizado para el script de respaldo
resource "aws_cloudwatch_log_group" "backup_log_group" {
  name              = "/aws/ec2/backup_gcp.log"
  retention_in_days = 7
}

# 2. Filtro de Métricas en los Logs de CloudWatch para buscar fallos de respaldo
resource "aws_cloudwatch_log_metric_filter" "backup_error_filter" {
  name           = "FiltroErroresRespaldo"
  pattern        = "\"[!]\"" # Coincide con la etiqueta de error '[!]' de nuestro script
  log_group_name = aws_cloudwatch_log_group.backup_log_group.name

  metric_transformation {
    name      = "BackupFailureCount"
    namespace = "MultiCloudBackup"
    value     = "1"
  }
}

# 3. ALARMA 1: Fallo de Respaldo detectado en los logs (GCP Upload failures)
resource "aws_cloudwatch_metric_alarm" "backup_failure_alarm" {
  alarm_name          = "Alarma-Fallo-Respaldo-GCP"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "BackupFailureCount"
  namespace           = "MultiCloudBackup"
  period              = 900 # Evaluar cada 15 minutos
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Se dispara de inmediato si el script de respaldo 'backup_gcp.sh' registra un error en la subida a GCP."
  actions_enabled     = false
}

# 4. ALARMAS de Utilización de CPU (CPU > 85% durante 10 minutos)
resource "aws_cloudwatch_metric_alarm" "cpu_alarm_web" {
  alarm_name          = "CPU-Critico-Server-1-Web"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300 # 5 minutos
  statistic           = "Average"
  threshold           = 85
  alarm_description   = "Se dispara si el uso promedio de CPU de Server-1 (Web) supera el 85% durante 10 minutos."
  dimensions = {
    InstanceId = aws_instance.vm_web.id
  }
  actions_enabled     = false
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_db" {
  alarm_name          = "CPU-Critico-Server-2-Database"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300 # 5 minutos
  statistic           = "Average"
  threshold           = 85
  alarm_description   = "Se dispara si el uso promedio de CPU de Server-2 (Database) supera el 85% durante 10 minutos."
  dimensions = {
    InstanceId = aws_instance.vm_db.id
  }
  actions_enabled     = false
}

# 5. ALARMAS de Fallo de Comprobación de Estado de Hardware/Hipervisor (StatusCheckFailed)
resource "aws_cloudwatch_metric_alarm" "status_check_web" {
  alarm_name          = "Fallo-Hardware-Server-1-Web"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60 # 1 minuto
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Se dispara de inmediato si falla la comprobación de estado de hardware de AWS para Server-1."
  dimensions = {
    InstanceId = aws_instance.vm_web.id
  }
  actions_enabled     = false
}

resource "aws_cloudwatch_metric_alarm" "status_check_db" {
  alarm_name          = "Fallo-Hardware-Server-2-Database"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60 # 1 minuto
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Se dispara de inmediato si falla la comprobación de estado de hardware de AWS para Server-2."
  dimensions = {
    InstanceId = aws_instance.vm_db.id
  }
  actions_enabled     = false
}

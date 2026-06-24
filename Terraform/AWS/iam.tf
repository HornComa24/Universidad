resource "aws_iam_role" "backup_role" {
  name = "ec2-backup-to-gcp-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "ssm_read_policy" {
  name = "ssm-read-gcp-key"
  role = aws_iam_role.backup_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "backup_profile" {
  name = "backup-instance-profile"
  role = aws_iam_role.backup_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_core" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Política en línea específica para descargar el archivo zip de Docker desde el bucket S3 principal
resource "aws_iam_role_policy" "s3_read_policy" {
  name = "s3-read-docker-app"
  role = aws_iam_role.backup_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.storage_principal.arn,
          "${aws_s3_bucket.storage_principal.arn}/*"
        ]
      }
    ]
  })
}




resource "aws_kms_key" "ec2" {
  description             = "KMS key for EC2 encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_kms_key" "secrets" {
  description             = "KMS key for Secrets Manager"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}
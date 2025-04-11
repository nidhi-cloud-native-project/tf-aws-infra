data "aws_caller_identity" "current" {}

resource "aws_kms_key" "ec2" {
  description             = "KMS key for EC2 encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-ec2-policy",
    Statement : [
      {
        Sid : "AllowFullAccessToIAMUserEC2",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/aws-cli-demo-user"
        },
        Action : "kms:*",
        Resource : "*"
      }
    ]
  })
}

resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-rds-policy",
    Statement : [
      {
        Sid : "AllowFullAccessToIAMUserRDS",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/aws-cli-demo-user"
        },
        Action : "kms:*",
        Resource : "*"
      }
    ]
  })
}

resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-s3-policy",
    Statement : [
      {
        Sid : "AllowFullAccessToIAMUserS3",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/aws-cli-demo-user"
        },
        Action : "kms:*",
        Resource : "*"
      }
    ]
  })
}

resource "aws_kms_key" "secrets" {
  description             = "KMS key for Secrets Manager"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-secrets-policy",
    Statement : [
      {
        Sid : "AllowFullAccessToIAMUserSecrets",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/aws-cli-demo-user"
        },
        Action : "kms:*",
        Resource : "*"
      }
    ]
  })
}
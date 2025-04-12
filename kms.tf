data "aws_caller_identity" "current" {}

# EC2 Key
resource "aws_kms_key" "ec2" {
  description             = "KMS key for EC2 encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-ec2-policy",
    Statement : [
      {
        Sid : "AllowRootAccountAccess",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action : "kms:*",
        Resource : "*"
      },
      {
        Sid : "AllowEC2Access",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ec2-combined-role"
        },
        Action : [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:ReEncrypt*",
          "kms:CreateGrant"
        ],
        Resource : "*"
      },
      {
        Sid : "AllowTerraformApplyUser",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/aws-cli-demo-user"
        },
        Action : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:ReEncrypt*",
          "kms:CreateGrant"
        ],
        Resource : "*"
      }
    ]
  })
}

# RDS Key
resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  tags = {
    Name = "rds-kms-${random_id.kms_suffix.hex}"
  }

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-rds-policy",
    Statement : [
      {
        Sid : "AllowRootAccountAccess",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action : "kms:*",
        Resource : "*"
      },
      {
        Sid : "AllowEC2Access",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ec2-combined-role"
        },
        Action : [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:ReEncrypt*",
          "kms:CreateGrant"
        ],
        Resource : "*"
      },
      {
        Sid : "AllowTerraformApplyUser",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/aws-cli-demo-user"
        },
        Action : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:ReEncrypt*",
          "kms:CreateGrant"
        ],
        Resource : "*"
      },
      {
        Sid : "AllowRDSServiceAccess",
        Effect : "Allow",
        Principal : {
          Service : "rds.amazonaws.com"
        },
        Action : [
          "kms:GenerateDataKey*",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:ReEncrypt*",
          "kms:CreateGrant"
        ],
        Resource : "*"
      }
    ]
  })
}

# S3 Key
resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-s3-policy",
    Statement : [
      {
        Sid : "AllowRootAccountAccess",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action : "kms:*",
        Resource : "*"
      },
      {
        Sid : "AllowEC2Access",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ec2-combined-role"
        },
        Action : [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:ReEncrypt*",
          "kms:CreateGrant"
        ],
        Resource : "*"
      },
      {
        Sid : "AllowTerraformApplyUser",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/aws-cli-demo-user"
        },
        Action : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:ReEncrypt*",
          "kms:CreateGrant"
        ],
        Resource : "*"
      }
    ]
  })
}

# Secrets Manager Key
resource "aws_kms_key" "secrets" {
  description             = "KMS key for Secrets Manager"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-secrets-policy",
    Statement : [
      {
        Sid : "AllowRootAccountAccess",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action : "kms:*",
        Resource : "*"
      },
      {
        Sid : "AllowSecretsManagerServiceAccess",
        Effect : "Allow",
        Principal : {
          Service : "secretsmanager.amazonaws.com"
        },
        Action : [
          "kms:GenerateDataKey*",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:ReEncrypt*",
          "kms:CreateGrant"
        ],
        Resource : "*"
      },
      {
        Sid : "AllowEC2RoleAccess",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ec2-combined-role"
        },
        Action : [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:ReEncrypt*",
          "kms:CreateGrant"
        ],
        Resource : "*"
      },
      {
        Sid : "AllowTerraformApplyUser",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/aws-cli-demo-user"
        },
        Action : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:ReEncrypt*",
          "kms:CreateGrant"
        ],
        Resource : "*"
      }
    ]
  })
}
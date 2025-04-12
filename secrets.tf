resource "aws_secretsmanager_secret" "db_credentials" {
  name       = "csye6225-db-password-${random_id.secret_suffix.hex}"
  kms_key_id = aws_kms_key.secrets.arn
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    password = random_password.db_password.result
  })
}
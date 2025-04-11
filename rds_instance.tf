# Create RDS instance with required configurations
resource "aws_db_instance" "rds_instance" {
  identifier             = "csye6225"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro" # Cheapest instance class
  db_name                = "csye6225"
  username               = "csye6225"
  password               = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string).password
  kms_key_id             = aws_kms_key.rds.arn
  parameter_group_name   = aws_db_parameter_group.custom_pg.name
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  multi_az               = false
  publicly_accessible    = false # Do not expose RDS to internet
  skip_final_snapshot    = true

  tags = {
    Name = "csye6225-RDS"
  }
}
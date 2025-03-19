# Create a custom parameter group for MySQL 8.0
resource "aws_db_parameter_group" "custom_pg" {
  name        = "custom-db-parameter-group"
  family      = "mysql8.0"
  description = "Custom parameter group for RDS"

  tags = {
    Name = "CustomRDSParamGroup"
  }
}
# Define RDS subnet group using private subnets only
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-private-subnet-group"
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name = "RDSPrivateSubnetGroup"
  }
}
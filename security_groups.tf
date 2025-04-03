# Security Group for Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "load-balancer-sg"
  description = "Allow HTTP and HTTPS from the internet"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Accept HTTP from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Accept HTTPS from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "LoadBalancerSecurityGroup"
  }
}

# Security Group for Web Application EC2 Instance
resource "aws_security_group" "app_sg" {
  name        = "webapp-sg"
  description = "Allow SSH from developer IP and HTTP access from Load Balancer only"
  vpc_id      = aws_vpc.main_vpc.id

  # Allow SSH access from developer machine only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr_block]
  }

  # Allow app port ONLY from the Load Balancer security group
  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebAppSecurityGroup"
  }
}

# Security Group for RDS Database
resource "aws_security_group" "db_sg" {
  name        = "db-security-group"
  description = "Allow MySQL access from the Web App EC2"
  vpc_id      = aws_vpc.main_vpc.id

  # Only allow MySQL access (port 3306) from the Web App SG
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DatabaseSecurityGroup"
  }
}
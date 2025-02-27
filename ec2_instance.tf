resource "aws_instance" "app_instance" {
  ami                         = var.custom_ami_id # Your custom AMI built using Packer
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = var.ssh_key_name
  associate_public_ip_address = true

  # Ensuring EBS volume termination on instance termination
  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "AppInstance"
  }
}
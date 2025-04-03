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

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  # User data to set environment variables at EC2 boot
  user_data = <<-EOF
              #!/bin/bash
              echo "DB_HOST=${aws_db_instance.rds_instance.address}" >> /opt/webapp/.env
              echo "DB_NAME=csye6225" >> /opt/webapp/.env
              echo "DB_USER=csye6225" >> /opt/webapp/.env
              echo "DB_PASSWORD=${var.db_password}" >> /opt/webapp/.env
              echo "S3_BUCKET_NAME=${aws_s3_bucket.file_storage_bucket.id}" >> /opt/webapp/.env
              echo "AWS_REGION=${var.aws_region}" >> /opt/webapp/.env

              chown csye6225:csye6225 /opt/webapp/.env
              chmod 600 /opt/webapp/.env

              systemctl restart webapp.service
            EOF

  tags = {
    Name = "AppInstance"
  }
}
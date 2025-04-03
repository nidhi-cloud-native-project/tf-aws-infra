resource "aws_launch_template" "asg_template" {
  name_prefix   = "webapp-template-"
  image_id      = var.custom_ami_id
  instance_type = var.instance_type
  key_name      = var.ssh_key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    DB_HOST         = aws_db_instance.rds_instance.address,
    DB_PASSWORD     = var.db_password,
    S3_BUCKET_NAME  = aws_s3_bucket.file_storage_bucket.id,
    AWS_REGION      = var.aws_region
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "webapp-instance"
    }
  }
}
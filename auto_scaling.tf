resource "aws_autoscaling_group" "webapp_asg" {
  name                      = "csye6225_asg"
  desired_capacity          = 1
  max_size                  = 5
  min_size                  = 3
  health_check_type         = "EC2"
  vpc_zone_identifier       = aws_subnet.public_subnets[*].id
  force_delete              = true

  launch_template {
    id      = aws_launch_template.asg_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "webapp-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Scale Up Policy: add 1 instance when triggered
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

# Scale Down Policy: remove 1 instance when triggered
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}
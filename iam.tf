# IAM Role: Base EC2
resource "aws_iam_role" "ec2_base_role" {
  name = "ec2-base-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Role: S3 Access
resource "aws_iam_role" "s3_access_role" {
  name = "s3-access-role"

  assume_role_policy = aws_iam_role.ec2_base_role.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# IAM Role: CloudWatch Agent
resource "aws_iam_role" "cloudwatch_agent_role" {
  name = "cloudwatch-agent-role"

  assume_role_policy = aws_iam_role.ec2_base_role.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "attach_cw_policy" {
  role       = aws_iam_role.cloudwatch_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Instance Profile attaches all 3 roles
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-multi-role-instance-profile"
  role = aws_iam_role.ec2_base_role.name
}

# Inline policy to allow base role to assume others
resource "aws_iam_policy" "assume_other_roles" {
  name = "AllowAssumeS3AndCloudWatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource = [
          aws_iam_role.s3_access_role.arn,
          aws_iam_role.cloudwatch_agent_role.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_assume_policy" {
  role       = aws_iam_role.ec2_base_role.name
  policy_arn = aws_iam_policy.assume_other_roles.arn
}
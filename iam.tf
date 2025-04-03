# IAM Role: Unified EC2 Role
resource "aws_iam_role" "ec2_unified_role" {
  name = "ec2-unified-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach S3 Full Access to unified role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_unified_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Attach CloudWatch Agent policy to unified role
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  role       = aws_iam_role.ec2_unified_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach IAM PassRole (optional, if you're using fromTemporaryCredentials in code)
resource "aws_iam_role_policy_attachment" "attach_passrole" {
  role       = aws_iam_role.ec2_unified_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

# Instance Profile to attach to EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-unified-instance-profile"
  role = aws_iam_role.ec2_unified_role.name
}
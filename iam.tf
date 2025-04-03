# Role: EC2 App Role (SSM + logging)
resource "aws_iam_role" "ec2_app_role" {
  name = "ec2-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "ec2.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Role: CloudWatch Agent Role
resource "aws_iam_role" "cloudwatch_agent_role" {
  name = "cloudwatch-agent-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "ec2.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cwagent_policy_attach" {
  role       = aws_iam_role.cloudwatch_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Role: S3 Access Role (Minimal access to app bucket only)
resource "aws_iam_role" "s3_access_role" {
  name = "s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "ec2.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Custom S3 Policy: Only access to a specific bucket
resource "aws_iam_policy" "s3_limited_access" {
  name        = "s3-limited-access"
  description = "Least privilege S3 access to app bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "arn:aws:s3:::${aws_s3_bucket.file_storage_bucket.id}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.s3_limited_access.arn
}

# Unified Role: Attach all policies directly (final role to attach to EC2)
resource "aws_iam_role" "ec2_combined_role" {
  name = "ec2-combined-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach required policies directly (instead of role chaining)
resource "aws_iam_role_policy_attachment" "combined_attach_ssm" {
  role       = aws_iam_role.ec2_combined_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "combined_attach_cloudwatch_agent" {
  role       = aws_iam_role.ec2_combined_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "combined_attach_s3" {
  role       = aws_iam_role.ec2_combined_role.name
  policy_arn = aws_iam_policy.s3_limited_access.arn
}

# Instance profile to attach to EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-combined-instance-profile"
  role = aws_iam_role.ec2_combined_role.name
}
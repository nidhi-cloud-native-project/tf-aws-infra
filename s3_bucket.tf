# Generate a unique UUID for the S3 bucket name
resource "random_uuid" "s3_bucket_name" {}

# Create a private S3 bucket with the generated UUID
resource "aws_s3_bucket" "file_storage_bucket" {
  bucket        = random_uuid.s3_bucket_name.result
  force_destroy = true # Allows deletion even if the bucket is not empty

  tags = {
    Name = "FileStorageBucket"
  }
}

# Enable default server-side encryption for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.file_storage_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3.arn
    }
  }
}

# Add lifecycle policy to transition objects to STANDARD_IA after 30 days
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_policy" {
  bucket = aws_s3_bucket.file_storage_bucket.id

  rule {
    id     = "TransitionToStandardIA"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}
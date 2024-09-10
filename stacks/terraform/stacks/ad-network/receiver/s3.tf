resource "aws_s3_bucket" "artifact" {
  bucket        = local.artifact_bucket_name
  force_destroy = true

  tags = { Name = local.artifact_bucket_name }
}

resource "aws_s3_bucket_versioning" "artifact" {
  bucket = aws_s3_bucket.artifact.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artifact" {
  bucket = aws_s3_bucket.artifact.id

  rule {
    id     = "7-days-noncurrent-version-retention"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

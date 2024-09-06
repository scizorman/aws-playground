resource "aws_s3_bucket" "vpc_flow_log" {
  bucket = local.vpc_flow_log_bucket_name

  tags = {
    Name = local.vpc_flow_log_bucket_name
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "vpc_flow_log" {
  bucket = aws_s3_bucket.vpc_flow_log.id

  rule {
    id     = "30-days-retention"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}

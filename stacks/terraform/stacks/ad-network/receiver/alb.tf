resource "aws_lb" "this" {
  name                       = local.name
  internal                   = false
  ip_address_type            = "dualstack-without-public-ipv4"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false
  drop_invalid_header_fields = true

  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    prefix  = local.alb_access_logs_prefix
    enabled = true
  }

  connection_logs {
    bucket  = aws_s3_bucket.alb_log.id
    prefix  = local.alb_connection_logs_prefix
    enabled = true
  }

  tags = {
    Name = local.name
  }
}

resource "aws_security_group" "alb" {
  name        = "${local.name}-alb"
  description = "Security group for the ALB of '${local.name}'"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "alb_from_all_http_ipv4" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow inbound HTTP traffic from all IPv4 addresses"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_from_all_http_ipv6" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow inbound HTTP traffic from all IPv6 addresses"
  cidr_ipv6         = "::/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_to_vpc_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow all outbound traffic to IPv4 addresses within the VPC"
  cidr_ipv4         = module.vpc.vpc_cidr_block
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_vpc_all_traffic_ipv6" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow all outbound traffic to IPv6 addresses within the VPC"
  cidr_ipv6         = module.vpc.vpc_ipv6_cidr_block
  ip_protocol       = "-1"
}

resource "aws_s3_bucket" "alb_log" {
  bucket = local.alb_log_bucket_name

  tags = {
    Name = local.alb_log_bucket_name
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log_bucket.json
}

data "aws_elb_service_account" "this" {}

data "aws_iam_policy_document" "alb_log_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.this.arn]
    }

    actions = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.alb_log.arn}/${local.alb_access_logs_prefix}/*",
      "${aws_s3_bucket.alb_log.arn}/${local.alb_connection_logs_prefix}/*",
    ]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  rule {
    id     = "365-days-retention-with-transitions"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER_IR"
    }

    expiration {
      days = 365
    }
  }
}

resource "aws_lb_target_group" "this" {
  name     = local.name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    matcher = "200"
    path    = "/health/readiness"
  }

  tags = {
    Name = local.name
  }
}

resource "aws_lb_listener" "this_http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name        = local.name
  cidr        = local.cidr
  azs         = local.azs
  enable_ipv6 = true

  public_subnets                                = local.public_subnets
  public_subnet_assign_ipv6_address_on_creation = true
  public_subnet_ipv6_prefixes                   = local.public_subnet_ipv6_prefixes

  private_subnets                                = local.private_subnets
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = local.private_subnet_ipv6_prefixes

  enable_flow_log                     = true
  flow_log_destination_type           = "s3"
  flow_log_destination_arn            = aws_s3_bucket.vpc_flow_log.arn
  flow_log_file_format                = "parquet"
  flow_log_hive_compatible_partitions = true
  flow_log_per_hour_partition         = true
  vpc_flow_log_tags                   = { Name = "${local.name}-vpc-flow-log" }
}

resource "aws_s3_bucket" "vpc_flow_log" {
  bucket        = local.vpc_flow_log_bucket_name
  force_destroy = true

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

resource "aws_security_group" "vpc_endpoints" {
  name        = "${local.name}-vpc-endpoints"
  description = "Security group for VPC endpoints of ${local.name}"
  vpc_id      = module.vpc.vpc_id

  tags = { Name = "${local.name}-vpc-endpoints" }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_endpoint_from_vpc_https_ipv4" {
  security_group_id = aws_security_group.vpc_endpoints.id
  description       = "Allow inbound HTTPS traffic from all IPv4 addresses within the VPC"
  cidr_ipv4         = module.vpc.vpc_cidr_block
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "vpc_endpoint_from_vpc_https_ipv6" {
  security_group_id = aws_security_group.vpc_endpoints.id
  description       = "Allow inbound HTTPS traffic from all IPv6 addresses within the VPC"
  cidr_ipv6         = module.vpc.vpc_ipv6_cidr_block
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "vpc_endpoint_to_vpc_all_https_ipv4" {
  security_group_id = aws_security_group.vpc_endpoints.id
  description       = "Allow outbound HTTPS traffic to all IPv4 addresses within the VPC"
  cidr_ipv4         = module.vpc.vpc_cidr_block
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "vpc_endpoint_to_vpc_all_https_ipv6" {
  security_group_id = aws_security_group.vpc_endpoints.id
  description       = "Allow outbound HTTPS traffic to all IPv6 addresses within the VPC"
  cidr_ipv6         = module.vpc.vpc_ipv6_cidr_block
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

module "gateway_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.13.0"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = module.vpc.private_route_table_ids
      tags            = { Name = "${local.name}-s3" }
    }
  }
}

module "interface_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.13.0"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.vpc_endpoints.id]
  subnet_ids         = module.vpc.private_subnets

  endpoints = {
    ec2 = {
      service         = "ec2"
      service_type    = "Interface"
      route_table_ids = module.vpc.private_route_table_ids
      tags            = { Name = "${local.name}-ec2" }
    }

    ec2messages = {
      service         = "ec2messages"
      service_type    = "Interface"
      route_table_ids = module.vpc.private_route_table_ids
      tags            = { Name = "${local.name}-ec2messages" }
    }

    ssm = {
      service         = "ssm"
      service_type    = "Interface"
      route_table_ids = module.vpc.private_route_table_ids
      tags            = { Name = "${local.name}-ssm" }
    }

    ssmmessages = {
      service         = "ssmmessages"
      service_type    = "Interface"
      route_table_ids = module.vpc.private_route_table_ids
      tags            = { Name = "${local.name}-ssmmessages" }
    }
  }
}

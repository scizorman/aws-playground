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

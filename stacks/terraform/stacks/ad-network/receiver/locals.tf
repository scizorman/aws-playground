locals {
  name = "ad-network-receiver"

  cidr                         = "10.100.0.0/16"
  azs                          = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnets               = ["10.100.1.0/24", "10.100.3.0/24", "10.100.4.0/24"]
  public_subnet_ipv6_prefixes  = [1, 3, 4]
  private_subnets              = ["10.100.11.0/24", "10.100.13.0/24", "10.100.14.0/24"]
  private_subnet_ipv6_prefixes = [11, 13, 14]

  vpc_flow_log_bucket_name = "${local.name}-vpc-flow-log"
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Project   = "aws-playground"
      Service   = "ad-network"
      Function  = "receiver"
      Terraform = true
    }
  }
}

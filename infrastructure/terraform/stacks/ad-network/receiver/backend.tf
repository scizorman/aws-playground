terraform {
  backend "s3" {
    bucket = "aws-playground-terraform-state"
    key    = "ad-network/receiver/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

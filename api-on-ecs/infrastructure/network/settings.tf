terraform {
  required_version = "1.0.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.50.0"
    }
  }

  backend "s3" {
    bucket  = "aws-playground-tfstate"
    key     = "network/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
    acl     = "private"
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Project = "aws-playground"
    }
  }
}

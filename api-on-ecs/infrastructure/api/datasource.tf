data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "aws-playground-tfstate"
    key    = "network/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

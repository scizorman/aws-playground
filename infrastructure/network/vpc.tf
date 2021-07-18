resource "aws_vpc" "aws_playground" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "aws-playground"
  }
}

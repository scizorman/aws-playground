resource "aws_internet_gateway" "aws_playground" {
  vpc_id = aws_vpc.aws_playground.id

  tags = {
    "Name" = "aws-playground"
  }
}

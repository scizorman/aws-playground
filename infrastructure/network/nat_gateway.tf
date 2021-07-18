resource "aws_eip" "nat_gateway_1a" {
  vpc = true

  tags = {
    Name = "aws-playground-nat-gateway-1a"
  }
}

resource "aws_nat_gateway" "nat_gateway_1a" {
  subnet_id     = aws_subnet.public_1a.id
  allocation_id = aws_eip.nat_gateway_1a.id

  tags = {
    "Name" = "aws-playground-1a"
  }
}

resource "aws_eip" "nat_gateway_1c" {
  vpc = true

  tags = {
    Name = "aws-playground-nat-gateway-1c"
  }
}

resource "aws_nat_gateway" "nat_gateway_1c" {
  subnet_id     = aws_subnet.public_1c.id
  allocation_id = aws_eip.nat_gateway_1c.id

  tags = {
    "Name" = "aws-playground-1c"
  }
}

resource "aws_eip" "nat_gateway_1d" {
  vpc = true

  tags = {
    Name = "aws-playground-nat-gateway-1d"
  }
}

resource "aws_nat_gateway" "nat_gateway_1d" {
  subnet_id     = aws_subnet.public_1d.id
  allocation_id = aws_eip.nat_gateway_1d.id

  tags = {
    "Name" = "aws-playground-1d"
  }
}

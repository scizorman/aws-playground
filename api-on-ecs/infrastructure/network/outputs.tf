output "vpc_id" {
  value = aws_vpc.aws_playground.id
}

output "subnet_id" {
  value = {
    public_1a  = aws_subnet.public_1a.id
    public_1c  = aws_subnet.public_1c.id
    public_1d  = aws_subnet.public_1d.id
    private_1a = aws_subnet.private_1a.id
    private_1c = aws_subnet.private_1c.id
    private_1d = aws_subnet.private_1d.id
  }
}

resource "aws_vpc" "vpc_virginia" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC-VIRGINIA"
    env = "Dev"
  }
}


resource "aws_vpc" "vpc_ohio" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC-OHIO"
    env = "Dev"
  }
  provider = aws.ohio
}
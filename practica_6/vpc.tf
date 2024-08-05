resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    Name = "VPC-VIRGINIA"
    env = "Dev"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc_virginia.id
  cidr_block =var.subnets[0]
  map_public_ip_on_launch = true # al poner true le estamos indicando que le asigne direcciones ip públicas a las instancia donde lo despleguemos
  tags  = {
    Name = "Public Subnet"
    env = "Dev"
  }
}
resource "aws_subnet" "privade_subnet" {
  vpc_id = aws_vpc.vpc_virginia.id
  cidr_block = var.subnets[1]
  tags = {
    Name = "Private Subnet"
    env = "Dev"
  }
}
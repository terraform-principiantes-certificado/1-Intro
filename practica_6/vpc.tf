resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    Name = "VPC-VIRGINIA"
    env = "Dev"
  }
}

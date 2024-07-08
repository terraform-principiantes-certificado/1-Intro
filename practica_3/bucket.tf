resource "aws_s3_bucket" "proveedores" {
  count = 2
  bucket = "proveedores-${random_string.sufijo[count.index].id}"
   tags = {
    Owner       = "Patri"
    Environment = "Dev"
    Office = "proveedores"
  }
}


resource "random_string" "sufijo" {
  count  = 2 
  length = 8
  special = false
  upper = false
  numeric = false
}

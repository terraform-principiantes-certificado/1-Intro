variable "virginia_cidr" {
    description = "CIDR Virginia"
    type = string
    ## sensitive = true
}
variable "public_subnet" {
    description = "CDIR public subnet"
    type = string
}
variable "privade_subnet" {
  description = "CDIR privade subnet"
  type = string
}
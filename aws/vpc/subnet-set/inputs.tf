variable "env" { }
variable "name" { }
variable "scope" { }
variable "segment" { }

variable "vpc_id" { description = "VPC ID" }
variable "cidrs" {
  description = "List of CIDRs, which determines the number of subnets created"
  type = "list"
}

variable "azs" {
  description = "List of AZs"
  type = "list"
}

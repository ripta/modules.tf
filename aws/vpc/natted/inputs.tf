variable "az"   {
  description = "The qualified name of the AZ, e.g., us-west-2"
  default = "us-west-2"
}

variable "name" { description = "A descriptive name for the VPC." }

variable "cidr" {
  description = "The IP space for the VPC in CIDR form."
  default = "172.28.0.0/16"
}

variable "private_cidr" {
  description = "The IP space for the private subnet; must be contained in the VPC IP space (`cidr` above)."
  default = "172.28.16.0/20"
}
variable "public_cidr" {
  description = "The IP space for the public subnet; must be contained in the VPC IP space (`cidr` above)."
  default = "172.28.0.0/20"
}

variable "key_name" {
  description = "The name of the key-pair used for NAT and bastion instances."
}

variable "amis" {
  description = "List of AMIs for each instance type"

  # Debian 8 Jessie HVM (2015-06-07-12-27)
  default = {
    bastion = "ami-818eb7b1"
    nat = "ami-818eb7b1"
  }
}

variable "instance_types" {
  default = {
    bastion = "t2.micro"
    nat = "t2.small"
  }
}

variable "allowed_external_ips" {
  description = "Comma-delimited (no spaces) list of external IPs allowed to SSH in (default is any and all)"
  default = "0.0.0.0/0"
}

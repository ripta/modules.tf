variable "az"   {
  description = "The qualified name of the AZ, e.g., us-west-2a"
  default = "us-west-2a"
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
    ingress = "ami-818eb7b1"
    egress = "ami-818eb7b1"
  }
}

variable "instance_types" {
  default = {
    ingress = "t2.micro"
    egress = "t2.small"
  }
}

variable "ingress_whitelist_ips" {
  description = "Comma-delimited (no spaces) list of external IPs allowed to SSH in"
}

variable "ingress_ssh_port" {
  description = "The port on `ingress_public_ip` to listen to for SSH"
  default = "2804"
}

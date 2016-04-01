variable "az"   {
  description = "The qualified name of the AZ, e.g., us-west-2a"
  type = "string"
  default = "us-west-2a"
}

variable "name" {
  description = "A descriptive name for the VPC."
  type = "string"
}

variable "cidr" {
  description = "The IP space for the VPC in CIDR form."
  type = "string"
  default = "172.28.0.0/16"
}

variable "private_cidr" {
  description = "The IP space for the private subnet; must be contained in the VPC IP space (`cidr` above)."
  type = "string"
  default = "172.28.16.0/20"
}
variable "public_cidr" {
  description = "The IP space for the public subnet; must be contained in the VPC IP space (`cidr` above)."
  type = "string"
  default = "172.28.0.0/20"
}

variable "key_name" {
  description = "The name of the key-pair used for NAT and bastion instances."
  type = "string"
}

variable "amis" {
  description = "AMIs for each EC2 instance"

  # Debian 8 Jessie HVM (2015-06-07-12-27)
  type = "map"
  default = {
    ingress = "ami-818eb7b1"
    egress = "ami-818eb7b1"
  }
}

variable "instance_types" {
  description = "Instance types for each EC2 instance"
  type = "map"
  default = {
    ingress = "t2.micro"
    egress = "t2.small"
  }
}

variable "ingress_whitelist_ips" {
  description = "Comma-delimited (no spaces) list of external IPs allowed to SSH in"
  type = "string"
}

variable "ingress_ssh_port" {
  description = "The port on `ingress_public_ip` to listen to for SSH"
  type = "string"
  default = "2804"
}

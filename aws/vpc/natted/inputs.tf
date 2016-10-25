variable "env_name" {
  description = "A short textual name for the environment"
  type        = "string"
}

variable "azs" {
  description = "List of qualified name of the AZs"
  type        = "list"
  default     = ["us-west-2a"]
}

variable "name" {
  description = "A descriptive name for the VPC."
  type        = "string"
}

variable "cidr" {
  description = "The IP space for the VPC in CIDR form."
  type        = "string"
  default     = "172.28.0.0/16"
}

variable "dns_root" {
  description = "The DNS root for internal name resoltion"
  type        = "string"
  default     = "compute.internal"
}

variable "private_cidrs" {
  description = "List of the IP space for the private subnets; must be contained in the VPC IP space (`cidr` above)."
  type        = "list"
  default     = ["172.28.16.0/20"]
}

variable "public_cidrs" {
  description = "List of the IP space for the public subnets; must be contained in the VPC IP space (`cidr` above)."
  type        = "list"
  default     = ["172.28.0.0/20"]
}

variable "key_name" {
  description = "The name of the key-pair used for NAT and bastion instances."
  type        = "string"
}

variable "ingress_ami" {
  description = "AMIs for the Ingress EC2 instance (bastion host)"

  # Debian 8 Jessie HVM (2015-06-07-12-27)
  type    = "string"
  default = "ami-818eb7b1"
}

variable "egress_ami" {
  description = "AMIs for the Egress EC2 instance (NAT)"

  # Debian 8 Jessie HVM (2015-06-07-12-27)
  type    = "string"
  default = "ami-818eb7b1"
}

variable "ingress_instance_type" {
  description = "Instance types for the Ingress instance (bastion host)"
  type        = "string"
  default     = "t2.micro"
}

variable "egress_instance_type" {
  description = "Instance types for the Egress instance (NAT)"
  type        = "string"
  default     = "t2.micro"
}

variable "ingress_whitelist_ips" {
  description = "Comma-delimited (no spaces) list of external IPs allowed to SSH in"
  type        = "string"
}

variable "ingress_ssh_port" {
  description = "The port on `ingress_public_ip` to listen to for SSH"
  type        = "string"
  default     = "2804"
}

variable "nat_count" {
  description = "Number of NAT instances"
  default     = 1
}

variable "nat_setup_script" {
  description = "(optional) setup script on first boot of NAT"
  type        = "string"
  default     = ""
}

variable "bastion_count" {
  description = "Number of Bastion instances"
  default     = 1
}

variable "bastion_setup_script" {
  description = "(optional) setup script on first boot of bastion"
  type        = "string"
  default     = ""
}

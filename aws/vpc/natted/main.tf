resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Env  = "${var.env_name}"
    Name = "${var.name}"
    DnsRoot = "${var.dns_root}"
  }
}

resource "aws_vpc_dhcp_options" "main" {
  domain_name = "${var.dns_root}"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name = "${var.dns_root}"
  }
}

resource "aws_vpc_dhcp_options_association" "resolver" {
  vpc_id = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.main.id}"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Env  = "${var.env_name}"
    Name = "main"
  }
}

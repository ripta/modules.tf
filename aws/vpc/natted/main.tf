resource "aws_vpc" "main" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    Env = "${var.env_name}"
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Env = "${var.env_name}"
    Name = "main"
  }
}

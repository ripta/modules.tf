resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.az}"
  cidr_block = "${var.public_cidr}"
  map_public_ip_on_launch = false # require an EIP even on public instances

  tags {
    Name = "${var.name}-public-1"
    Scope = "public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.name}-public-1"
    Scope = "public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route" "public" {
  route_table_id = "${aws_route_table.public.id}"

  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
}

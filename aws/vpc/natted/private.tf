resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.az}"
  cidr_block = "${var.private_cidr}"
  map_public_ip_on_launch = false

  tags {
    Name = "${var.name}-private-1"
    Scope = "private"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.name}-private-1"
    Scope = "private"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route" "private" {
  route_table_id = "${aws_route_table.private.id}"

  destination_cidr_block = "0.0.0.0/0"
  instance_id = "${aws_instance.nat.id}"
}

resource "aws_subnet" "private" {
  count = "${length(var.azs)}"

  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${element(var.azs, count.index)}"
  cidr_block              = "${element(var.private_cidrs, count.index)}"
  map_public_ip_on_launch = false

  tags {
    Env   = "${var.env_name}"
    Name  = "${var.name}-private-${count.index + 1}"
    Scope = "private"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(var.azs)}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Env   = "${var.env_name}"
    Name  = "${var.name}-private-${count.index + 1}"
    Scope = "private"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(var.azs)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route" "private" {
  count          = "${length(var.azs)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"

  destination_cidr_block = "0.0.0.0/0"
  instance_id            = "${element(aws_instance.nat.*.id, count.index)}"
}

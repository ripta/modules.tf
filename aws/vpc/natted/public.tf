resource "aws_subnet" "public" {
  count                   = "${length(var.azs)}"
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${element(var.azs, count.index)}"
  cidr_block              = "${element(var.public_cidrs, count.index)}"
  map_public_ip_on_launch = false                                       # use an EIP if you need a public IP

  tags {
    Env   = "${var.env_name}"
    Name  = "${var.name}-public-${count.index + 1}"
    Scope = "public"
  }
}

resource "aws_route_table" "public" {
  count  = "${length(var.azs)}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Env   = "${var.env_name}"
    Name  = "${var.name}-public-${count.index + 1}"
    Scope = "public"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.azs)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_route" "public" {
  count          = "${length(var.azs)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_subnet" "set" {
  count = "${length(var.cidrs)}"

  vpc_id     = "${var.vpc_id}"
  cidr_block = "${element(var.cidrs, count.index)}"

  availability_zone = "${element(var.azs, count.index)}"

  tags {
    Env     = "${var.env}"
    Name    = "${var.name}-${count.index + 1}"
    Scope   = "${var.scope}"
    Segment = "${var.segment}"
    KubernetesCluster = "${lookup(var.custom_tags, "KubernetesCluster")}"
  }
}

resource "aws_route_table" "set" {
  vpc_id = "${var.vpc_id}"

  tags {
    Env     = "${var.env}"
    Name    = "${var.name}"
    Scope   = "${var.scope}"
    Segment = "${var.segment}"
    KubernetesCluster = "${lookup(var.custom_tags, "KubernetesCluster")}"
  }
}

resource "aws_route_table_association" "set" {
  count = "${length(var.cidrs)}"

  subnet_id      = "${element(aws_subnet.set.*.id, count.index)}"
  route_table_id = "${aws_route_table.set.id}"
}

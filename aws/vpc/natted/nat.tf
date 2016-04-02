resource "template_file" "nat" {
  template = "config/nat.sh"
  vars = {
    vpc_cidr = "${var.cidr}"
  }
}


resource "aws_security_group" "nat" {
  name = "nat"
  description = "Public-facing resources"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "nat"
    Scope = "public"
  }
}

resource "aws_security_group_rule" "nat_in_any_bastion" {
  security_group_id = "${aws_security_group.nat.id}"
  type = "ingress"

  protocol = "-1"
  from_port = 0
  to_port = 0
  self = true
  source_security_group_id = ["${aws_security_group.bastion.id}"]
}

resource "aws_security_group_rule" "nat_out_http_80" {
  security_group_id = "${aws_security_group.nat.id}"
  type = "egress"

  protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nat_out_http_443" {
  security_group_id = "${aws_security_group.nat.id}"
  type = "egress"

  protocol = "tcp"
  from_port = 443
  to_port = 443
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nat_out_icmp_all" {
  security_group_id = "${aws_security_group.nat.id}"
  type = "egress"

  protocol = "icmp"
  from_port = -1
  to_port = -1
  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_instance" "nat" {
  ami = "${egress_ami}"
  instance_type = "${egress_instance_type}"
  key_name = "${var.key_name}"

  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  source_dest_check = false
  subnet_id = "${aws_subnet.public.id}"
  user_data = "${template_file.nat.rendered}"

  root_block_device {
    volume_size = 16
    volume_type = "gp2"
  }

  tags {
    Name = "nat-01"
    Scope = "public"
    Role = "gateway"
    GatewayType = "egress"
  }
}

resource "aws_eip" "nat" {
  instance = "${aws_instance.nat.id}"
  vpc = true
}

resource "template_file" "bastion" {
  template = "${file("${path.module}/config/bastion.sh")}"
  vars = {
    # unused, but here to mirror `template_file.nat`
    vpc_cidr = "${var.cidr}"
  }
}


resource "aws_security_group" "bastion" {
  name = "bastion"
  description = "Ingress-only public-facing resources"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "bastion"
    Scope = "public"
  }
}

resource "aws_security_group_rule" "bastion_in_ssh_22" {
  security_group_id = "${aws_security_group.bastion.id}"
  type = "ingress"

  protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_blocks = ["${split(",", var.ingress_whitelist_ips)}"]
}

resource "aws_security_group_rule" "bastion_in_ssh_2804" {
  security_group_id = "${aws_security_group.bastion.id}"
  type = "ingress"

  protocol = "tcp"
  from_port = 2804
  to_port = 2804
  cidr_blocks = ["${split(",", var.ingress_whitelist_ips)}"]
}

resource "aws_security_group_rule" "bastion_in_icmp_all" {
  security_group_id = "${aws_security_group.bastion.id}"
  type = "ingress"

  protocol = "icmp"
  from_port = -1
  to_port = -1
  cidr_blocks = ["${split(",", var.ingress_whitelist_ips)}"]
}

resource "aws_security_group_rule" "bastion_out_any_vpc" {
  security_group_id = "${aws_security_group.bastion.id}"
  type = "egress"

  protocol = "-1"
  from_port = 0
  to_port = 0
  cidr_blocks = ["${var.cidr}"]
}


resource "aws_instance" "bastion" {
  ami = "${var.ingress_ami}"
  instance_type = "${var.ingress_instance_type}"
  key_name = "${var.key_name}"

  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  source_dest_check = true
  subnet_id = "${aws_subnet.public.id}"
  user_data = "${template_file.bastion.rendered}"

  root_block_device {
    volume_size = 16
    volume_type = "gp2"
  }

  tags {
    Name = "bastion-01"
    Scope = "public"
    Role = "gateway"
    GatewayType = "ingress"
  }
}


resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true
}

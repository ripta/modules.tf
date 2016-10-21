data "template_file" "bastion" {
  template = "${file("${path.module}/config/bastion.sh")}"

  vars = {
    postscript = "${var.bastion_setup_script}"

    # unused, but here to mirror `template_file.nat`
    vpc_cidr = "${var.cidr}"
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Ingress-only public-facing resources"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    Env   = "${var.env_name}"
    Name  = "bastion"
    Scope = "public"
  }
}

resource "aws_security_group_rule" "bastion_in_ssh_22" {
  security_group_id = "${aws_security_group.bastion.id}"
  type              = "ingress"

  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["${split(",", var.ingress_whitelist_ips)}"]
}

resource "aws_security_group_rule" "bastion_in_ssh_2804" {
  security_group_id = "${aws_security_group.bastion.id}"
  type              = "ingress"

  protocol    = "tcp"
  from_port   = 2804
  to_port     = 2804
  cidr_blocks = ["${split(",", var.ingress_whitelist_ips)}"]
}

resource "aws_security_group_rule" "bastion_in_icmp_all" {
  security_group_id = "${aws_security_group.bastion.id}"
  type              = "ingress"

  protocol    = "icmp"
  from_port   = -1
  to_port     = -1
  cidr_blocks = ["${split(",", var.ingress_whitelist_ips)}"]
}

resource "aws_security_group_rule" "bastion_out_any_vpc" {
  security_group_id = "${aws_security_group.bastion.id}"
  type              = "egress"

  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_iam_instance_profile" "bastion" {
  name  = "${var.name}-bastion"
  roles = ["${aws_iam_role.dmz.name}"]
}

resource "aws_instance" "bastion" {
  count = "${var.bastion_count}"

  ami                  = "${var.ingress_ami}"
  instance_type        = "${var.ingress_instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.bastion.name}"

  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  source_dest_check      = true
  subnet_id              = "${element(aws_subnet.public.*.id, count.index)}"
  user_data              = "${data.template_file.bastion.rendered}"

  root_block_device {
    volume_size = 16
    volume_type = "gp2"
  }

  tags {
    Env         = "${var.env_name}"
    Name        = "${format("bastion-%02d", count.index + 1)}"
    Scope       = "public"
    Roles       = "bastion,gateway"
    GatewayType = "ingress"
  }
}

resource "aws_eip" "bastion" {
  count    = "${var.bastion_count}"
  instance = "${element(aws_instance.bastion.*.id, count.index)}"
  vpc      = true
}

resource "template_file" "bastion" {
  template = "config/bastion.sh"
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

  # incoming ssh over port 22
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["${split(",", var.allowed_external_ips)}"]
  }

  # incoming ssh over port 2804
  ingress {
    protocol = "tcp"
    from_port = 2804
    to_port = 2804
    cidr_blocks = ["${split(",", var.allowed_external_ips)}"]
  }

  # incoming icmp
  ingress {
    protocol = "icmp"
    from_port = -1
    to_port = -1
    cidr_blocks = ["${split(",", var.allowed_external_ips)}"]
  }

  # allow all egress
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami = "${lookup(var.amis, "ingress")}"
  instance_type = "${lookup(var.instance_types, "ingress")}"
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

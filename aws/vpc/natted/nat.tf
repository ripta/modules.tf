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

  ingress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    self = true
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  # outgoing, destined to HTTP (tcp/80)
  egress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outgoing, destined to HTTPS (tcp/443)
  egress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outgoing ICMP packets
  egress {
    protocol = "icmp"
    from_port = -1
    to_port = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nat" {
  ami = "${lookup(var.amis, "nat")}"
  instance_type = "${lookup(var.instance_types, "nat")}"
  key_name = "${var.key_name}"

  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  source_dest_check = false
  subnet_id = "${aws_subnet.public.id}"
  user_data = "${template_file.nat.rendered}"

  root_block_device {
    volume_size = 32
    volume_type = "gp2"
  }

  tags {
    Name = "nat-01"
  }
}

resource "aws_eip" "nat" {
  instance = "${aws_instance.nat.id}"
  vpc = true
}

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

resource "aws_security_group" "nodes" {
  name = "nodes"
  description = "Private resources"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "nodes"
    Scope = "private"
  }

  # allow free communication between resources in this SG
  ingress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    self = true
  }

  # allow all incoming from bastion
  ingress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    source_security_group_id = "${aws_security_group.bastion.id}"
  }

  # allow all outgoing connections anywhere
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

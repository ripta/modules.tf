output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "ec2_trust_policy" {
  value = "${data.aws_iam_policy_document.ec2_trust_policy.json}"
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_route_id" {
  value = ["${aws_route_table.private.*.id}"]
}

output "public_route_id" {
  value = ["${aws_route_table.public.*.id}"]
}

output "ingress_sg_id" {
  value = "${aws_security_group.bastion.id}"
}

output "egress_sg_id" {
  value = "${aws_security_group.nat.id}"
}

output "bastion_private_ip" {
  value = ["${aws_instance.bastion.*.private_ip}"]
}

output "nat_private_ip" {
  value = ["${aws_instance.nat.*.private_ip}"]
}

output "nat_instances" {
  value = ["${aws_instance.nat.*.id}"]
}

output "ingress_public_ip" {
  value = ["${aws_eip.bastion.*.public_ip}"]
}

output "egress_public_ip" {
  value = ["${aws_eip.nat.*.public_ip}"]
}

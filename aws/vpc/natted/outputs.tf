output "vpc_id" { value = "${aws_vpc.main.id}" }

output "private_subnet" { value = "${aws_subnet.private.id}" }
output "public_subnet"  { value = "${aws_subnet.public.id}"  }

output "private_route_id" { value = "${aws_route_table.private.id}" }
output "public_route_id"  { value = "${aws_route_table.public.id}"  }

output "bastion_public_ip" { value = "${aws_eip.bastion.public_ip}" }
output "nat_public_ip"     { value = "${aws_eip.nat.public_ip}"     }

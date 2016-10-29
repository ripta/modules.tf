output "route_tables" {
  value = ["${aws_route_table.set.*.id}"]
}

output "subnets" {
  value = ["${aws_subnet.set.*.id}"]
}

output "master_script_tpl" {
  value = "${file("${path.module}/config/master.sh")}"
}

output "minion_script_tpl" {
  value = "${file("${path.module}/config/minion.sh")}"
}

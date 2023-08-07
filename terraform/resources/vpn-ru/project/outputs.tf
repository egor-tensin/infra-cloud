output "zone" {
  value = var.zone
}
output "project_stub" {
  value = var.project_stub
}

output "subnet_id" {
  value = yandex_vpc_subnet.this.id
}
output "security_group_id" {
  value = module.firewall.id
}
output "server_ip" {
  value = yandex_vpc_address.server.external_ipv4_address[0].address
}

output "ssh_port" {
  value = var.ssh_port
}

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
output "ip_address" {
  value = yandex_vpc_address.this.external_ipv4_address[0].address
}

output "region" {
  value = var.region
}
output "region_ru" {
  value = var.region_ru
}

output "project_id" {
  value = digitalocean_project.this.id
}
output "project_stub" {
  value = var.stub
}

output "user" {
  value = var.user
}
output "ssh_keys" {
  value = sort(data.digitalocean_ssh_keys.this.ssh_keys.*.public_key)
}
output "ssh_port" {
  value = var.ssh_port
}

output "vpc_id" {
  value = digitalocean_vpc.this.id
}
output "subnet_id_ru" {
  value = yandex_vpc_subnet.this.id
}

output "server_ip_vpn" {
  value = local.ip_vpn
}
output "server_ip_web" {
  value = local.ip_web
}
output "server_ip_vpn_ru" {
  value = local.ip_vpn_ru
}

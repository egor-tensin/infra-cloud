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
  value = module.vpc_int.id
}
output "subnet_id_ru" {
  value = module.vpc_rus.id
}

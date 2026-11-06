output "zone_int" {
  value = var.zone_int
}
output "zone_rus" {
  value = var.zone_rus
}

output "project_id" {
  value = digitalocean_project.this.id
}

output "config" {
  value = {
    user     = var.user
    ssh_keys = sort(data.digitalocean_ssh_keys.this.ssh_keys.*.public_key)
    ssh_port = var.ssh_port
  }
}

output "vpc_id_int" {
  value = module.vpc_int.id
}
output "vpc_id_rus" {
  value = module.vpc_rus.id
}

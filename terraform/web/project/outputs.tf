output "region" {
  value = var.region
}
output "project_id" {
  value = digitalocean_project.this.id
}
output "project_stub" {
  value = var.stub
}
output "vpc_id" {
  value = digitalocean_vpc.this.id
}
output "server_ip" {
  value = digitalocean_floating_ip.server.ip_address
}

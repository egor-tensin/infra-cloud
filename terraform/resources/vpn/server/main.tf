data "digitalocean_ssh_keys" "this" {
  sort {
    key       = "fingerprint"
    direction = "asc"
  }
}

locals {
  user           = "maintenance"
  wireguard_port = "443"
  ssh_port       = "993"
}

module "server" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/server?ref=v0.0.1"

  region     = data.terraform_remote_state.project.outputs.region
  project_id = data.terraform_remote_state.project.outputs.project_id

  name       = "${data.terraform_remote_state.project.outputs.project_stub}-server"
  vpc_id     = data.terraform_remote_state.project.outputs.vpc_id
  ip_address = data.terraform_remote_state.project.outputs.server_ip

  user     = local.user
  ssh_keys = data.digitalocean_ssh_keys.this.ssh_keys.*.public_key
  ssh_port = local.ssh_port
}

module "firewall" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/firewall?ref=v0.0.4"

  name        = "${data.terraform_remote_state.project.outputs.project_stub}-firewall"
  open_ports  = [local.wireguard_port, local.ssh_port]
  droplet_ids = [module.server.droplet_id]
}

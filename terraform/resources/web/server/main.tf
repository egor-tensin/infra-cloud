data "digitalocean_ssh_keys" "this" {
  sort {
    key       = "fingerprint"
    direction = "asc"
  }
}

locals {
  user = "maintenance"

  ssh_port   = "993"
  gitea_port = "22"
  web_ports  = ["80", "443"]

  open_ports = concat([local.gitea_port, local.ssh_port], local.web_ports)
}

module "server" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/server?ref=v1.0.0"

  region     = data.terraform_remote_state.project.outputs.region
  project_id = data.terraform_remote_state.project.outputs.project_id

  name       = "${data.terraform_remote_state.project.outputs.project_stub}-server"
  vpc_id     = data.terraform_remote_state.project.outputs.vpc_id
  ip_address = data.terraform_remote_state.project.outputs.server_ip
  volume_ids = [data.terraform_remote_state.data.outputs.volume_id]

  user     = local.user
  ssh_keys = data.digitalocean_ssh_keys.this.ssh_keys.*.public_key
  ssh_port = local.ssh_port

  size = "s-2vcpu-4gb"
}

module "firewall" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/firewall?ref=v1.0.0"

  name        = "${data.terraform_remote_state.project.outputs.project_stub}-firewall"
  open_ports  = local.open_ports
  droplet_ids = [module.server.droplet_id]
}

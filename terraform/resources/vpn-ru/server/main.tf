locals {
  user     = "maintenance"
  ssh_port = "993"
}

data "digitalocean_ssh_keys" "this" {
  sort {
    key       = "fingerprint"
    direction = "asc"
  }
}

module "server" {
  source = "../../../modules/yc_server"

  zone       = data.terraform_remote_state.project.outputs.zone
  name       = data.terraform_remote_state.project.outputs.project_stub
  subnet_id  = data.terraform_remote_state.project.outputs.subnet_id
  ip_address = data.terraform_remote_state.project.outputs.ip_address

  user     = local.user
  ssh_keys = data.digitalocean_ssh_keys.this.ssh_keys.*.public_key
  ssh_port = local.ssh_port

  core_fraction = 20
}

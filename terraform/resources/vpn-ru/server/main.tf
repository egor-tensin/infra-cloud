locals {
  user = "maintenance"
}

data "digitalocean_ssh_keys" "this" {
  sort {
    key       = "fingerprint"
    direction = "asc"
  }
}

module "server" {
  source = "github.com/egor-tensin/infra-terraform//yandex/server?ref=v0.0.2"

  zone       = data.terraform_remote_state.project.outputs.zone
  name       = "${data.terraform_remote_state.project.outputs.project_stub}-server"
  subnet_id  = data.terraform_remote_state.project.outputs.subnet_id
  ip_address = data.terraform_remote_state.project.outputs.ip_address

  user     = local.user
  ssh_keys = data.digitalocean_ssh_keys.this.ssh_keys.*.public_key
  ssh_port = data.terraform_remote_state.project.outputs.ssh_port

  core_fraction = 20
}

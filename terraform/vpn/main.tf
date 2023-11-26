data "digitalocean_ssh_keys" "this" {
  sort {
    key       = "fingerprint"
    direction = "asc"
  }
}

module "server" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/server?ref=v1.0.0"

  region     = data.terraform_remote_state.meta.outputs.region
  project_id = data.terraform_remote_state.meta.outputs.project_id

  name       = "vpn-server"
  vpc_id     = data.terraform_remote_state.meta.outputs.vpc_id
  ip_address = data.terraform_remote_state.meta.outputs.server_ip_vpn
  volume_ids = [data.terraform_remote_state.data.outputs.volume_id_vpn]

  user     = data.terraform_remote_state.meta.outputs.user
  ssh_keys = data.digitalocean_ssh_keys.this.ssh_keys.*.public_key
  ssh_port = data.terraform_remote_state.meta.outputs.ssh_port
}

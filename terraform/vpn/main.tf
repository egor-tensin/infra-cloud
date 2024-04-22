module "server" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/server?ref=v1.1.1"

  region     = data.terraform_remote_state.meta.outputs.region
  project_id = data.terraform_remote_state.meta.outputs.project_id

  name       = "vpn-server"
  # dnscrypt-proxy is not available on Debian 12.
  image      = "debian-11-x64"
  vpc_id     = data.terraform_remote_state.meta.outputs.vpc_id
  ip_address = data.terraform_remote_state.meta.outputs.server_ip_vpn
  volume_ids = [data.terraform_remote_state.data.outputs.volume_id_vpn]

  user     = data.terraform_remote_state.meta.outputs.user
  ssh_keys = data.terraform_remote_state.meta.outputs.ssh_keys
  ssh_port = data.terraform_remote_state.meta.outputs.ssh_port

  # I'm tired from these alerts, the Tor deamon bombards me with those.
  alert_cpu_enable = false
}

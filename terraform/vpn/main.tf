module "server" {
  source = "github.com/egor-tensin/infra-terraform//digitalocean/server?ref=v4.0.0"

  zone       = data.terraform_remote_state.meta.outputs.zone_int
  project_id = data.terraform_remote_state.meta.outputs.project_id
  name       = "vpn-server"
  size       = "small"

  network = {
    vpc_id = data.terraform_remote_state.meta.outputs.vpc_id_int
  }

  storage = [
    {
      disk_id = data.terraform_remote_state.data.outputs.id_vpn
    },
  ]

  config = data.terraform_remote_state.meta.outputs.config

  # I'm tired of these alerts, the Tor deamon bombards me with those.
  alert_cpu_enable = false
}

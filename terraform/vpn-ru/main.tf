module "server" {
  source = "github.com/egor-tensin/infra-terraform//yandex/server?ref=v4.0.0"

  zone = data.terraform_remote_state.meta.outputs.zone_rus
  name = "vpn-ru-server"
  size = "small"

  network = {
    vpc_id = data.terraform_remote_state.meta.outputs.vpc_id_rus
    ip_address = local.ip
  }

  storage = [
    {
      disk_id   = data.terraform_remote_state.data.outputs.id_vpn_ru
      disk_name = "data"
    },
  ]

  config = data.terraform_remote_state.meta.outputs.config
}

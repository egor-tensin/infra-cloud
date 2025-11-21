module "server" {
  source = "github.com/egor-tensin/infra-terraform//yandex/server?ref=v1.2.0-fixme"

  zone       = data.terraform_remote_state.meta.outputs.region_ru
  name       = "vpn-ru-server"
  subnet_id  = data.terraform_remote_state.meta.outputs.subnet_id_ru
  ip_address = data.terraform_remote_state.meta.outputs.server_ip_vpn_ru

  user     = data.terraform_remote_state.meta.outputs.user
  ssh_keys = data.terraform_remote_state.meta.outputs.ssh_keys
  ssh_port = data.terraform_remote_state.meta.outputs.ssh_port

  core_fraction = 20
}
